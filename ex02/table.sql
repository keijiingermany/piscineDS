-- Exercise 02: create and load one customer CSV table.

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS data_2022_oct;

CREATE TABLE data_2022_oct (
    event_time TIMESTAMP NOT NULL,
    event_type VARCHAR(32) NOT NULL,
    product_id INTEGER NOT NULL,
    price NUMERIC(12, 2) NOT NULL,
    user_id BIGINT NOT NULL,
    user_session UUID
);

\copy data_2022_oct (event_time, event_type, product_id, price, user_id, user_session) FROM '../customer/data_2022_oct.csv' WITH (FORMAT csv, HEADER true, NULL '');
