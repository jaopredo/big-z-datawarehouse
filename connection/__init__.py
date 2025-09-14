import psycopg2
import os


class Connection:
    def __init__(self):
        self.__connection = psycopg2.connect(
            database=os.getenv('DB_DATABASE'),
            user=os.getenv('DB_OWNDER'),
            password=os.getenv('DB_PASSWORD'),
            host=os.getenv('DB_HOST'),
            port=os.getenv('DB_PORT'),
        )

        self.__cursor = self.__connection.cursor()

        self.__cursor.execute(f'SET search_path TO {os.getenv("DB_PATH")};')
    
    def close(self):
        if self.__connection:
            self.__connection.close()
