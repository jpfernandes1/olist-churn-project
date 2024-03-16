import os
import sqlalchemy

from sklearn import model_selection
from sklearn import tree
from sklearn import pipeline
from sklearn import metrics
from sklearn import ensemble
import lightgbm

from feature_engine import imputation

import scikitplot as skplt

import pandas as pd

ML_DIR = os.path.dirname(os.path.abspath(__file__))
LOCAL_DEV_DIR = os.path.dirname(ML_DIR)
ROOT_DIR = os.path.dirname(LOCAL_DEV_DIR)
DATA_DIR = os.path.join(ROOT_DIR, 'data')
DB_PATH = os.path.join(DATA_DIR, 'olist.db')

engine = sqlalchemy.create_engine((f"sqlite:///{DB_PATH}"))

with engine.connect() as con:
    df = pd.read_sql_table("abt_olist_churn", con)


object_files = ['maxReview', 'minReview', 'minQtdeParcelas', 'maxQtdeParcelas', 'maxValorProduto', 'minValorProduto']

#Convertendo object em float
for o in object_files:
    df[o] = df[o].astype(float)

# Base Out Of Time
df_oot = df[df['dtReference'] >= '2018-01-01']

# Base de treino
df_train = df[df['dtReference'] < '2018-01-01']
            
# Definição de variáveis
var_identity = ['dtReference', 'seller_id']
target = 'flChurn'
to_remove = ['qtdRecencia', target] + var_identity

# A coluna de Recencia foi removida devido à alta importancia que o modelo 
# atruibuiu a ela (muito discrepante das demais e tem uma relação muito forte 
# com a variável alvo, já que é considerado churn o cliente que passou > 45 dia sem comprar)

features = df.columns.tolist()
features = list(set(features) - set(to_remove))
features.sort()
features

# Sampling

X_train, X_test, y_train, y_test = model_selection.train_test_split(df_train[features],
                                                                    df_train[target],
                                                                    train_size=0.8,
                                                                    random_state=42)

print("Proporção resposta Treino: ", y_train.mean())
print("Proporção resposta Teste: ", y_test.mean())

# EDA
X_train.isna().sum().sort_values(ascending=False)

missing_minus_100 = [ 'avgIntervaloVendas',
                      'maxReview',
                      #'medianNota',
                      'minReview',
                      'avgReview',
                      'avgProduct_vol',
                      'minVolProduct',
                      'maxVolProduct',
                      #'medianVolumeProduto'
                    ]

missing_0 = [#'medianQtdeParcelas',
             'avgQtdeParcelas',
             'minQtdeParcelas',
             'maxQtdeParcelas'
            ]

# Transform
imputer_minus_100 = imputation.ArbitraryNumberImputer(arbitrary_number=-100,
                                                    variables=missing_minus_100)

imputer_0 = imputation.ArbitraryNumberImputer(arbitrary_number=0,
                                              variables=missing_0)


# Model
model = lightgbm.LGBMClassifier(n_jobs=-1,
                                 learning_rate=0.1,
                                 min_child_samples=30,
                                 max_depth=10,
                                 n_estimators=400)

# Pipeline
model_pipeline = pipeline.Pipeline([("Imputer -100", imputer_minus_100),
                                    ("Imputer 0", imputer_0),
                                    ("LGBM Model", model)])


#Treino do algoritmo
model_pipeline.fit(X_train, y_train)

auc_train= metrics.roc_auc_score(y_train, model_pipeline.predict_proba(X_train)[:,1])
auc_test= metrics.roc_auc_score(y_test, model_pipeline.predict_proba(X_test)[:,1])
auc_oot = metrics.roc_auc_score(df_oot[target], model_pipeline.predict_proba(df_oot[features])[:,1])

metrics_model = {"auc_train": auc_train,
                 "auc_test": auc_test,
                 "auc_oot": auc_oot}

print(metrics_model)