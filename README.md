# Excel to SQL ETL Pipeline (SSIS)

A production-style ETL pipeline built with SQL Server Integration Services (SSIS) that imports multiple Excel files, validates and cleans data, and loads it into SQL Server staging and production tables.

---

## Architecture

```
┌─────────────────────┐
│   Excel Source Files │
│  (Properties.xlsx)  │
│  (Rent.xlsx)        │
│  (Tenants.xlsx)     │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   SSIS Package      │
│  ┌───────────────┐  │
│  │ Data Flow Task│  │
│  │ - Excel Source│  │
│  │ - Data Conv.  │  │
│  │ - Derived Col.│  │
│  │ - Row Count   │  │
│  └───────────────┘  │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  SQL Staging Tables │
│  stg.Properties     │
│  stg.Rent           │
│  stg.Tenants        │
└────────┬────────────┘
         │  Validation & Cleansing
         ▼
┌─────────────────────┐
│ SQL Production Tables│
│  dbo.Properties     │
│  dbo.Rent           │
│  dbo.Tenants        │
└─────────────────────┘
```

---

## Project Structure

```
1-excel-to-sql-etl-pipeline
├── README.md
├── ssis
│   ├── ExcelToSQL_ETL.dtsx          # Main SSIS package
│   └── ExcelToSQL_ETL.dtsConfig     # Configuration file
├── sql
│   ├── 01_create_schema.sql         # Database and schema creation
│   ├── 02_create_staging_tables.sql # Staging table definitions
│   ├── 03_create_production_tables.sql # Production table definitions
│   ├── 04_validation_stored_procs.sql  # Data validation logic
│   └── 05_etl_logging.sql           # ETL audit/logging tables
└── sample-data
    ├── Properties.xlsx
    ├── Rent.xlsx
    └── Tenants.xlsx
```

---

## SQL Server Objects

### Schemas
- `stg` — Staging schema for raw imported data
- `dbo` — Production schema for validated data
- `etl` — Audit and logging schema

### Key Tables
| Table | Schema | Purpose |
|-------|--------|---------|
| Properties | stg / dbo | Property master data |
| Rent | stg / dbo | Rent payment records |
| Tenants | stg / dbo | Tenant information |
| ETL_Log | etl | Pipeline run audit trail |

---

## How to Run

### Prerequisites
- SQL Server 2019+
- SQL Server Integration Services (SSIS)
- Visual Studio with SSIS extension **or** SQL Server Data Tools (SSDT)
- Microsoft ACE OLEDB provider (for Excel)

### Steps

1. **Create the database**
```sql
CREATE DATABASE PropertyETL;
```

2. **Run SQL scripts in order**
```
01_create_schema.sql
02_create_staging_tables.sql
03_create_production_tables.sql
04_validation_stored_procs.sql
05_etl_logging.sql
```

3. **Open SSIS package**
   - Open `ssis/ExcelToSQL_ETL.dtsx` in Visual Studio
   - Update connection strings in `.dtsConfig`
   - Set Excel file paths to `sample-data/` folder

4. **Execute the package**
   - Run via Visual Studio or SQL Server Agent Job

---

## ETL Process Detail

### Stage 1 — Extract
- Reads `.xlsx` files using Excel Source component
- Handles multiple sheets per workbook
- Logs row counts per file

### Stage 2 — Transform
- Data type conversions (Excel float → SQL INT/DECIMAL)
- Null handling for optional fields
- Duplicate detection using Lookup transformation
- Derived columns: `LoadDate`, `SourceFile`, `BatchID`

### Stage 3 — Load
- Truncate-and-load into staging tables
- Stored procedure validates staging data
- Clean records promoted to production tables
- Rejected records written to `etl.RejectedRows`

---

## Data Validation Rules

| Field | Rule |
|-------|------|
| PropertyID | Not null, positive integer |
| RentAmount | Not null, > 0, < 50000 |
| RentDate | Not null, valid date, not future |
| TenantEmail | Valid email format |
| PostCode | UK postcode format |

---

## Skills Demonstrated
- SSIS data flow design
- Staging and production table patterns
- Data validation and error handling
- ETL audit logging
- Excel source configuration
- SQL Server stored procedures
