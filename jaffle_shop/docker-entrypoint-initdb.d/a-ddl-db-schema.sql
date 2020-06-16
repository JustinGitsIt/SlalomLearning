CREATE USER alice;
CREATE USER eve;
CREATE USER bob;

CREATE DATABASE jaffle_shop;

GRANT ALL PRIVILEGES ON DATABASE jaffle_shop TO alice;
GRANT ALL PRIVILEGES ON DATABASE jaffle_shop TO eve;
GRANT ALL PRIVILEGES ON DATABASE jaffle_shop TO bob;
