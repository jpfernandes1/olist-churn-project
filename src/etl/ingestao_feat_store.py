import datetime
from tqdm import tqdm
import sqlalchemy
import os
import pandas as pd


def import_query(path):
    with open(path, 'r') as open_file:
        return open_file.read()
    
def create_db_engine(path):
    return sqlalchemy.create_engine(f"sqlite:///{path}")

def table_exists(table, engine):
    with engine.connect() as connection:
        tables = sqlalchemy.inspect(connection).get_table_names()
        return table in tables

def execute_etl(query, engine):
    with engine.connect() as connection:
        df = pd.read_sql_query(query, connection)
    return df

def insert_table(df, table_name, engine):
    with engine.connect() as connection:
        df.to_sql(table_name, connection, if_exists= 'replace', index=False)
    return True

def delete_table_rows(table_name, field, value, engine):
    sql = f"DELETE FROM {table_name} where {field} = '{value}';"
    with engine.connect() as connection:
        connection.execute(sqlalchemy.text(sql))
    return True

if __name__ == "__main__":

    ETL_DIR = os.path.dirname(os.path.abspath(__file__))
    LOCAL_DEV_DIR = os.path.dirname(ETL_DIR)
    ROOT_DIR = os.path.dirname(LOCAL_DEV_DIR)
    DATA_DIR = os.path.join(ROOT_DIR, 'data')

    engine = create_db_engine(os.path.join(DATA_DIR, 'olist.db'))

    query_path = os.path.join(ETL_DIR, 'clientes.sql')
    query = import_query(query_path).format(date='2018-01-01')
    df = execute_etl(query, engine)
    
    print("Inserindo dados na tabela...")
    insert_table(df, 'tb_fodase', engine)

    print("Removendo dados da tabela...")
    delete_table_rows('tb_fodase', 'dtReference','2018-01-01', engine)

    print("OK.")