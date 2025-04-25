CREATE DATABASE my_citus_db;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

SELECT create_distributed_table('users', 'id');

SELECT * FROM pg_dist_shards WHERE logicalrelation = 'users';

INSERT INTO users (name, email) VALUES ('Matic', 'matic@primer.com');
INSERT INTO users (name, email) VALUES ('Zanet', 'zanet@primer.com');
INSERT INTO users (name, email) VALUES ('Mia', 'mia@primer.com');