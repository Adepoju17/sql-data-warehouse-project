/*
--===============================================================================
Quality Checks
--===============================================================================
Script Purpose:
  This script performs quality checks to validate the Integrity, consistency,
  and accuracy of the Gold layer. These checks ensure:
  - Uniqueness of Surrogaye keys dimension tables.
  - Referential Integrity between fact and dimension tables.
  - Validation of relationships in the data model for analytical purpose.

Usage: 
  - Run these checks after data loading Silver layer
  - Investigate and resolve any discrepancies found during the checks.
 --=============================================================================== 
*/

--===============================================================================
-- Checking 'gold.customer_key'
--===============================================================================
-- Check for Uniqueness of Customer key in gold.dim_customers
-- Expectation: No Results
SELECT DISTINCT 
  customer_key,
  COUNT(*)        AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

--===============================================================================
-- Checking 'gold.product_key'
--===============================================================================
-- Check for Uniqueness of Product key in gold.dim_products
-- Expectation: No Results
SELECT DISTINCT 
  prd_key,
  COUNT(*)        AS duplicate_count
FROM gold.dim_products
GROUP BY prd_key
HAVING COUNT(*) > 1;

--===============================================================================
-- Checking 'gold.fact_sales'
--===============================================================================
-- Check the data model connectivity between fact and dimension
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
