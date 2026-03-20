-- ============================================================
-- 01_create_schema.sql
-- Creates database schemas for ETL pipeline
-- ============================================================

USE PropertyETL;
GO

-- Staging schema: raw imported data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
GO

-- Production schema (default dbo used for clarity)
-- ETL audit/logging schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'etl')
    EXEC('CREATE SCHEMA etl');
GO

PRINT 'Schemas created successfully.';
