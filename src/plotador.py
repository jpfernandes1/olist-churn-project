import pandas as pd
import matplotlib.pyplot as plt
import sqlite3
import os

# Caminho completo para o arquivo de banco de dados
db_path = os.path.abspath(os.path.join('data', 'olist.db'))

# Conectar ao banco de dados
conn = sqlite3.connect(db_path)

# Executar a query e ler os resultados em um DataFrame
query = open(os.path.abspath((os.path.join('src', 'etl', 'pagamentos.sql')))).read()
df = pd.read_sql_query(query, conn)

# Fechar a conexão com o banco de dados
conn.close()

# Plotar o gráfico
plt.plot(df['dtPedido'], df['qtPedido'])
plt.xlabel('Rótulo do Eixo X')
plt.ylabel('Rótulo do Eixo Y')
plt.title('Título do Gráfico')
plt.show()
