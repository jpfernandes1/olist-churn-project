The aim of this project is churn prediction based on Olist datasets.

This project was built following the Teo Calvo's Machine Learning course e the main knowledges
obtained here were:

* How to use github as a To Do list (and code versioning, of course)
* Using SQL to get all the informations, instead of pandas

* Some Machine Learning knowledges:
    - Data Leakage;
    - Data Drift;
    - Batches;
    - Cohorts;
    - Ensemble methods;
    - Overfit and how to avoid;


# Instructions for running

This project uses only `Python` and `SQLite3` as tools.

## Virtual environment preparation
You can create a venv (Virtual Environment) just typing this on your prompt:

```bash
python -m venv venv
```

And then you can activate it using:
```bash
venv\Scripts\Activate
```

The third step is to install the requirements using:
```bash
pip install -r requeriments.txt
```

## Data preparation

You'll need to create the batches (dataset split based on different time ranges)
using the script `src\etl\ingestao_feat_store.py`.
 ```bash
This is the params of this script:

python ingestao_feature_store.py --help
usage: ingestao_feature_store.py [-h] [--table TABLE] [--dt_start DT_START]
                                 [--dt_stop DT_STOP] [--dt_period DT_PERIOD]

options:
  -h, --help            show this help message and exit
  --table TABLE
  --dt_start DT_START
  --dt_stop DT_STOP
  --dt_period DT_PERIOD
```
So you can execute a code like this on your prompt to ingest data into your database:

```bash
python ingestao_feature_store.py --table fs_vendedor_cientes --dt_start "2017-01-01" --dt_stop "2018-02-01" --dt_period "monthly"
```
obs.: You'll need to run this code for all the sql files started with fs.

# Analytical Base Table (ABT)

This is a summary of all the data. It was builded based on the queries we used in the previous
step.
To create it we'll run the query: `src\etl\abt_churn.sql`


# Training the algorithm

Once the ABT is already created, execute the train.py algorithm:

```bash
python train.py
```