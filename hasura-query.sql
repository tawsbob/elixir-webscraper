CREATE TABLE product (
   id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
   brand varchar(100) NOT NULL,
   brand_slug varchar(100) NOT NULL,
   product_name varchar(150) NOT NULL,
   product_slug varchar(100) NOT NULL,
   image varchar(250) NOT NULL,
   created_date timestamptz DEFAULT now(),
   specifications_section json NOT NULL
);