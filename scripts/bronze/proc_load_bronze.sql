/*
=================================================
  This Stored Procedure loads the data into the bronze Schema via externa CSV file.
=================================================
Method Used: Truncate and Insert.
USES BULK INSERT.

Parameters: None
  This Stored procedure does not accept any parameters or return any values.
USAGE example:
  EXEC brone.load_bronze
=================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME,  @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		Print '========================================';
		print 'Loading Bronze Layer';
		print '========================================';

		print '----------------------------------------';
		print 'Loading CRM Tables';
		print '----------------------------------------';
		SET @batch_start_time = Getdate();
		SET @start_time = GETDATE();
		PRINT 'Truncating the table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info; 
		print 'Inserting the Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Ahmed\SQL and Project tools\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds';
		
		SET @start_time = GETDATE();
		PRINT 'Truncating the table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		print 'Inserting the Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Ahmed\SQL and Project tools\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		Print 'Truncating the table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		Print 'Inserting the Data Into:bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\HP ZBOOK 15 v\Downloads\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds';
	
		print '----------------------------------------';
		print 'Loading ERP Tables';
		print '----------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT 'Truncating the table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT 'Inserting the table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\HP ZBOOK 15 v\Downloads\sql-data-warehouse-project\01_datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		PRINT 'Truncating the table: bronze.erp_LOC_A101';
		TRUNCATE TABLE bronze.erp_LOC_A101;
		PRINT 'Inserting the table: bronze.erp_LOC_A101';
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\HP ZBOOK 15 v\Downloads\sql-data-warehouse-project\01_datasets\source_erp\LOC_A101.csv'
			WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		PRINT 'Truncating the table: bronze.erp_PX_CAT_G1V2';
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
		PRINT 'Inserting the table: bronze.erp_PX_CAT_G1V2';
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\HP ZBOOK 15 v\Downloads\sql-data-warehouse-project\01_datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR) + ' seconds';
		SET @batch_end_time = GETDATE();
		PRINT '>> Batch Duration: ' + CAST(DATEDIFF(second, @batch_end_time, @batch_start_time) AS NVARCHAR) + ' seconds';

	END TRY
BEGIN CATCH
	PRINT '============================================';
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT 'Error Message' + ERROR_MESSAGE();
	PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
	PRINT '============================================';
END CATCH
END
