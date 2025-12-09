-- Migration: Create initial database schema
-- Run this in Supabase SQL editor or via psql.

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create sequences
CREATE SEQUENCE IF NOT EXISTS counters_id_seq;
CREATE SEQUENCE IF NOT EXISTS employees_id_seq;
CREATE SEQUENCE IF NOT EXISTS intrari_solutie_id_seq;
CREATE SEQUENCE IF NOT EXISTS reception_number_id_seq;
CREATE SEQUENCE IF NOT EXISTS solutions_new_id_seq;

-- Create tables
CREATE TABLE IF NOT EXISTS public.counters (
  id integer NOT NULL DEFAULT nextval('counters_id_seq'::regclass),
  current_value integer NOT NULL,
  CONSTRAINT counters_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.customers (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
  name text,
  phone text,
  email text,
  location character varying,
  contract_number character varying,
  contractnumber character varying,
  jobs jsonb,
  surface text,
  CONSTRAINT customers_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.employees (
  id integer NOT NULL DEFAULT nextval('employees_id_seq'::regclass),
  name character varying NOT NULL,
  id_series character varying NOT NULL,
  CONSTRAINT employees_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.reception_number (
  id integer NOT NULL DEFAULT nextval('reception_number_id_seq'::regclass),
  current_number integer NOT NULL,
  CONSTRAINT reception_number_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.solutions (
  name character varying NOT NULL,
  concentration character varying NOT NULL,
  lot character varying NOT NULL,
  stock double precision NOT NULL CHECK (stock >= 0::double precision AND stock <= 9999999::double precision),
  id integer NOT NULL DEFAULT nextval('solutions_new_id_seq'::regclass),
  remaining_quantity double precision,
  quantity_per_sqm double precision,
  initial_stock double precision,
  total_quantity double precision,
  unit_of_measure character varying,
  is_active boolean DEFAULT true,
  minimum_reserve double precision DEFAULT 0,
  total_intrari numeric DEFAULT 0,
  expiration_date timestamp with time zone,
  furnizor text,
  CONSTRAINT solutions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.lucrari (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  numar_ordine numeric NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
  client_name character varying NOT NULL,
  client_contract character varying,
  client_location character varying,
  employee_name character varying NOT NULL,
  procedure1 character varying,
  product1_name character varying,
  product1_lot character varying,
  product1_quantity numeric,
  procedure2 character varying,
  product2_name character varying,
  product2_lot character varying,
  product2_quantity numeric,
  procedure3 character varying,
  product3_name character varying,
  product3_lot character varying,
  product3_quantity numeric,
  user_login character varying DEFAULT 'Excusemymanners'::character varying,
  notes text,
  product4_name character varying,
  product4_lot character varying,
  product4_quantity numeric,
  procedure4 character varying,
  concentration1 numeric,
  concentration2 numeric,
  concentration3 numeric,
  concentration4 numeric,
  CONSTRAINT lucrari_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.intrari_solutie (
  id integer NOT NULL DEFAULT nextval('intrari_solutie_id_seq'::regclass),
  solution_id integer,
  quantity numeric NOT NULL,
  previous_stock numeric DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  tip character varying DEFAULT 'Intrare'::character varying,
  beneficiar character varying,
  lot character varying,
  post_stock numeric,
  numar_ordine text,
  numar_factura character varying,
  expiration_date timestamp with time zone,
  furnizor text,
  CONSTRAINT intrari_solutie_pkey PRIMARY KEY (id),
  CONSTRAINT intrari_solutie_solution_id_fkey FOREIGN KEY (solution_id) REFERENCES public.solutions(id)
);

-- Insert initial data
INSERT INTO reception_number (current_number) VALUES (1) ON CONFLICT DO NOTHING;

-- Create RPC function for incrementing reception number
CREATE OR REPLACE FUNCTION increment_reception_number()
RETURNS void AS $$
BEGIN
  UPDATE reception_number SET current_number = current_number + 1 WHERE id = 1;
END;
$$ LANGUAGE plpgsql;