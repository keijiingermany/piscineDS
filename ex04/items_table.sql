-- Exercise 04: create and load the items table.
-- Run from this directory with:
--   psql -h localhost -U kuehara -d piscineds -f items_table.sql

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS items;

CREATE TABLE items (
    product_id BIGINT NOT NULL,
    category_id BIGINT,
    category_code TEXT,
    brand VARCHAR(128)
);

\copy items (product_id, category_id, category_code, brand) FROM '../item/item.csv' WITH (FORMAT csv, HEADER true, NULL '');
