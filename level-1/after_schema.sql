-- Create a rule to prevent duplicate records from being created
CREATE OR REPLACE RULE db_table_ignore_duplicate_customers AS
	ON INSERT TO customers
	WHERE (EXISTS (SELECT 1
				  FROM customers
				  WHERE customers.customer_id = NEW.customer_id))
	DO INSTEAD NOTHING;

-- Recreate table products to include product_category - no way to separate the 2 datasets
DROP TABLE PRODUCTS;

-- This table will contain only unique values
CREATE TABLE products (
  product_id TEXT PRIMARY KEY NOT NULL UNIQUE,
  product_title TEXT,
  product_category TEXT
);