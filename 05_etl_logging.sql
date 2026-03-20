-- ============================================================
-- 03_create_production_tables.sql
-- Production tables hold validated, clean data
-- ============================================================

USE PropertyETL;
GO

DROP TABLE IF EXISTS dbo.Rent;
DROP TABLE IF EXISTS dbo.Tenants;
DROP TABLE IF EXISTS dbo.Properties;
GO

-- -------------------------------------------------------
-- dbo.Properties
-- -------------------------------------------------------
CREATE TABLE dbo.Properties (
    PropertyID      INT             PRIMARY KEY,
    PropertyName    NVARCHAR(200)   NOT NULL,
    PropertyType    NVARCHAR(100),
    Address1        NVARCHAR(200)   NOT NULL,
    Address2        NVARCHAR(200),
    Town            NVARCHAR(100)   NOT NULL,
    PostCode        NVARCHAR(20)    NOT NULL,
    Bedrooms        TINYINT,
    IsVoid          BIT             NOT NULL DEFAULT 0,
    CreatedDate     DATETIME2       NOT NULL DEFAULT GETDATE(),
    ModifiedDate    DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- -------------------------------------------------------
-- dbo.Tenants
-- -------------------------------------------------------
CREATE TABLE dbo.Tenants (
    TenantID        INT             PRIMARY KEY,
    FirstName       NVARCHAR(100)   NOT NULL,
    LastName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(200),
    Phone           NVARCHAR(30),
    PropertyID      INT             NOT NULL REFERENCES dbo.Properties(PropertyID),
    LeaseStartDate  DATE            NOT NULL,
    LeaseEndDate    DATE,
    CreatedDate     DATETIME2       NOT NULL DEFAULT GETDATE()
);
GO

-- -------------------------------------------------------
-- dbo.Rent
-- -------------------------------------------------------
CREATE TABLE dbo.Rent (
    RentID          INT             IDENTITY(1,1) PRIMARY KEY,
    PropertyID      INT             NOT NULL REFERENCES dbo.Properties(PropertyID),
    TenantID        INT             NOT NULL REFERENCES dbo.Tenants(TenantID),
    RentAmount      DECIMAL(10,2)   NOT NULL,
    RentDate        DATE            NOT NULL,
    PaymentMethod   NVARCHAR(50),
    Notes           NVARCHAR(500),
    CreatedDate     DATETIME2       NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_Rent_Amount CHECK (RentAmount > 0 AND RentAmount < 50000),
    CONSTRAINT CK_Rent_Date   CHECK (RentDate <= CAST(GETDATE() AS DATE))
);
GO

-- Indexes for query performance
CREATE INDEX IX_Rent_PropertyID  ON dbo.Rent (PropertyID);
CREATE INDEX IX_Rent_TenantID    ON dbo.Rent (TenantID);
CREATE INDEX IX_Rent_RentDate    ON dbo.Rent (RentDate);
GO

PRINT 'Production tables created successfully.';
