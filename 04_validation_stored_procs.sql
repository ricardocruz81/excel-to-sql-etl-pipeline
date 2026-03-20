-- ============================================================
-- 02_create_staging_tables.sql
-- Staging tables receive raw data from Excel via SSIS
-- All columns are nullable to absorb dirty data
-- ============================================================

USE PropertyETL;
GO

-- Drop and recreate staging tables (truncate-and-load pattern)
DROP TABLE IF EXISTS stg.Tenants;
DROP TABLE IF EXISTS stg.Rent;
DROP TABLE IF EXISTS stg.Properties;
GO

-- -------------------------------------------------------
-- stg.Properties
-- -------------------------------------------------------
CREATE TABLE stg.Properties (
    PropertyID          NVARCHAR(50),
    PropertyName        NVARCHAR(200),
    PropertyType        NVARCHAR(100),
    Address1            NVARCHAR(200),
    Address2            NVARCHAR(200),
    Town                NVARCHAR(100),
    PostCode            NVARCHAR(20),
    Bedrooms            NVARCHAR(10),
    IsVoid              NVARCHAR(10),
    -- ETL audit columns
    SourceFile          NVARCHAR(500),
    LoadDate            DATETIME2       DEFAULT GETDATE(),
    BatchID             UNIQUEIDENTIFIER DEFAULT NEWID(),
    StgStatus           NVARCHAR(20)    DEFAULT 'PENDING'
);
GO

-- -------------------------------------------------------
-- stg.Tenants
-- -------------------------------------------------------
CREATE TABLE stg.Tenants (
    TenantID            NVARCHAR(50),
    FirstName           NVARCHAR(100),
    LastName            NVARCHAR(100),
    Email               NVARCHAR(200),
    Phone               NVARCHAR(30),
    PropertyID          NVARCHAR(50),
    LeaseStartDate      NVARCHAR(30),
    LeaseEndDate        NVARCHAR(30),
    -- ETL audit columns
    SourceFile          NVARCHAR(500),
    LoadDate            DATETIME2       DEFAULT GETDATE(),
    BatchID             UNIQUEIDENTIFIER DEFAULT NEWID(),
    StgStatus           NVARCHAR(20)    DEFAULT 'PENDING'
);
GO

-- -------------------------------------------------------
-- stg.Rent
-- -------------------------------------------------------
CREATE TABLE stg.Rent (
    RentID              NVARCHAR(50),
    PropertyID          NVARCHAR(50),
    TenantID            NVARCHAR(50),
    RentAmount          NVARCHAR(30),
    RentDate            NVARCHAR(30),
    PaymentMethod       NVARCHAR(50),
    Notes               NVARCHAR(500),
    -- ETL audit columns
    SourceFile          NVARCHAR(500),
    LoadDate            DATETIME2       DEFAULT GETDATE(),
    BatchID             UNIQUEIDENTIFIER DEFAULT NEWID(),
    StgStatus           NVARCHAR(20)    DEFAULT 'PENDING'
);
GO

PRINT 'Staging tables created successfully.';
