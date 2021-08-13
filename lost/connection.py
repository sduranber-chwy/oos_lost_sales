import os
import configparser
from sqlalchemy import create_engine, event
from urllib import parse


config = configparser.ConfigParser()
config.read(os.getenv('DSBCONFIG')+'/db_config.ini')
config.sections()
creds = config["connection"]

con = create_engine(
    'vertica+vertica_python://{user}:{password}@{host}:{port}/{database}'.format(**creds), pool_size=100,max_overflow=20)


@event.listens_for(con, 'before_cursor_execute')
def receive_before_cursor_execute(
  conn, cursor, statement, params, context, executemany):
    if executemany:
        cursor.fast_executemany = True
