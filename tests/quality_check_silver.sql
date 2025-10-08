/*
==================================================================================
Quality Checks
==================================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy, and
  standardization across the 'silver' schemas. It includes checks for;
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency.
  - Invalid date ranges and orders.
  - Data consistency between related fields.

Usage Notes:
  - Run these checks after data loading Silver Layer.
  - Investigate and resolve any discrepancies found during the checks.
==================================================================================
*/

-- Checking 'silver.crm_cust_info'
--============================================================
-- Check for NULLs or Duplicates im Primary key
-- Expectation: No Results
SELECT 
  cst_id,
  COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
  cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency

SELECT DISTINCT 
  cst_marital_status
FROM silver.crm_cust_info;

--============================================================
-- Checking 'silver.crm_prd_info'
--============================================================
-- Check for NULLS or Duplicates in Primary key
-- Expectation: No Results
SELECT 
  prd_id,
  COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No results
SELECT 
  prd_nm
FROM siler.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Values in cost
-- Expectation: No Results
SELECT 
  prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency 
SELECT DISTINCT
  prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT 
  *
FROM silver.crm_prd_info
WHERE prd_end_dt prd_sart_dt;

--============================================================
-- Checking 'silver.crm_sales_details'
--============================================================
-- Check for Invalid Date Orders ( Order Date > Shipping/Due Date)
-- Expectation: No Results
SELECT 
  *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
  OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales > Quantity > Price
-- Expectation: No Results
SELECT 
  sls_Sales,
  sls_quantity,
  sls_Price
FROM silver.crm_sales_details
WHERE sls_sales != Sls_Quantity * sls_price
  OR sls_sales IS NULL
  OR sls_quantity IS NULL
  OR sls_peice IS NULL
  OR sls_sales <= 0
  OR sls_quantity <= 0
  OR sls_peice <= 0
ORDER BY sls_sales, sls_Quantity, sls_price;

--============================================================
-- Checking 'silver.erp_cust_az12'
--============================================================
-- Identify out of Range Dates
-- Expectation: Birthdate between 1924-01-01 and Today
SELECT DISTINCT 
  bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
  OR bdate > GETDATE()
  
-- Data Standardization & Consistency
SELECT DISTINCT 
  gen
FROM silver.erp_cust_az12;

--============================================================
-- Checking 'silver.erp_loc_a101'
--============================================================
-- Data Standardization & Consistency
SELECT DISTINCT 
  cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

--============================================================
-- Checking 'silver.erp_px_cat_g1v2'
--============================================================
--Check for Unmatched Spaces
-- Epectation: NO
SELECT 
  *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
  OR subcat != TRIM(subcat)
  OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT 
  maintenance 
FROM silver.erp_px_cat_g1v2;
