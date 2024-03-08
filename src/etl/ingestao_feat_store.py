import datetime
from tqdm import tqdm
import sqlalchemy
import os
import pandas as pd
    
class Ingestor:

    def __init__(self, path, table, key_field):
        self.path = path
        self.engine = self.create_db_engine()
        self.table = table
        self.key_field = key_field
    
    def create_db_engine(self):
        return sqlalchemy.create_engine(f"sqlite:///{self.path}")
    
    def import_query(self, path):
        with open(path, 'r') as open_file:
            return open_file.read()

    def table_exists(self):
        with self.engine.connect() as connection:
            tables = sqlalchemy.inspect(connection).get_table_names()
            return self.table in tables

    def execute_etl(self, query):
        with self.engine.connect() as connection:
            df = pd.read_sql_query(query, connection)
        return df

    def insert_table(self, df):
        with self.engine.connect() as connection:
            df.to_sql(self.table, connection, if_exists= 'replace', index=False)
        return True

    def delete_table_rows(self, value):
        sql = f"DELETE FROM {self.table} where {self.key_field} = '{value}';"
        with self.engine.connect() as connection:
            connection.execute(sqlalchemy.text(sql))
            connection.commit()
        return True

if __name__ == "__main__":

    ETL_DIR = os.path.dirname(os.path.abspath(__file__))
    LOCAL_DEV_DIR = os.path.dirname(ETL_DIR)
    ROOT_DIR = os.path.dirname(LOCAL_DEV_DIR)
    DATA_DIR = os.path.join(ROOT_DIR, 'data')
    DB_PATH = os.path.join(DATA_DIR, 'olist.db')

    ingestor = Ingestor(DB_PATH, 'tb_fodase', 'dtReference')

    print("Importando Query...")
    query_path = os.path.join(ETL_DIR, 'clientes.sql')
    query = ingestor.import_query(query_path).format(date='2018-01-01')

    print("Executando ETL..")
    df = ingestor.execute_etl(query)
    
    print("Inserindo dados na tabela...")
    ingestor.insert_table(df)

    print("Removendo dados da tabela...")
    ingestor.delete_table_rows('2018-01-01')

    print("OK.")
