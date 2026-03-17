FROM postgis/postgis:15-3.3

WORKDIR /database
COPY init.sh /docker-entrypoint-initdb.d/
COPY seed.sql .
COPY cities.csv .

RUN chmod +x /docker-entrypoint-initdb.d/init.sh