import os,sys
import pandas as pd
import snowflake.connector
# from lost.connection import SNOWFLAKE_CREDS

import sqlalchemy as sa


snow_uri = (
  f"snowflake://{username}@chewy.com:{password}@chewy.us-east-1/EDLDB/"
)

engine = sa.create_engine(
    snow_uri,
    echo=True,
    convert_unicode=True,
    encoding="utf8",
    connect_args={"authenticator": "https://chewy.okta.com"},
)


def snowflake_execute(script: str) -> pd.DataFrame:

    script = [q for q in script.split(";") if len(q) > 5]
    exec_queries = script[:-1]
    read_query = script[-1]

    with engine.connect() as con:
        for i, query in enumerate(exec_queries):
            print(f"{i+1}/{len(exec_queries)}")
            try:
                con.execute(query)
            except Exception as e:
                print(f"Script {i+1} encountered an error: {str(e)}")
        df = pd.read_sql_query(read_query, con)

    return df

