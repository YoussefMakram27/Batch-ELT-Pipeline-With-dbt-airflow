FROM apache/airflow:2.8.1

RUN pip install --no-cache-dir \
    pandas \
    sqlalchemy \
    psycopg2-binary \
    pyarrow