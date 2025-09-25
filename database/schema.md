# Database Schema Documentation

This document describes the database schema for the Awesome Production data management system. The schema is designed to support vendor information storage, categorization, health monitoring, and workflow automation.

## Overview

The database uses PostgreSQL as the primary storage engine, with NocoDB providing a user-friendly interface for data management. The schema is optimized for the three main workflows: import, new entry processing, and health monitoring.

## Table: `vendors`

The main table storing all vendor information and metadata.

### Schema Definition

```sql
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(255) NOT NULL,
    url TEXT NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    last_status_change TIMESTAMP WITH TIME ZONE,
    date_added TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_checked TIMESTAMP WITH TIME ZONE,
    created_by VARCHAR(20) NOT NULL,
    health_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Field Descriptions

#### Primary Key
- **`id`** (SERIAL PRIMARY KEY)
  - Auto-incrementing unique identifier
  - Used for internal references and relationships

#### Core Vendor Information
- **`vendor_name`** (VARCHAR(255) NOT NULL)
  - The name of the vendor/manufacturer
  - Examples: "Allen & Heath", "Avid", "DiGiCo"
  - Indexed for fast searching and duplicate detection

- **`url`** (TEXT NOT NULL)
  - The vendor's website URL
  - Examples: "https://www.allen-heath.com/", "https://www.avid.com/"
  - Used for health monitoring and duplicate detection

- **`description`** (TEXT)
  - Brief description of the vendor's products/services
  - Examples: "Mixers and control surfaces", "Pro Tools and VENUE systems"
  - Optional field, can be NULL

#### Categorization
- **`category`** (VARCHAR(100) NOT NULL)
  - Main category classification
  - Values: "Audio", "Video", "Lighting & Rigging", "Networking & Control", "Infrastructure & Hardware", "Power & Distribution", "Software"
  - Used for grouping and markdown generation

- **`subcategory`** (VARCHAR(100) NOT NULL)
  - Specific subcategory within the main category
  - Examples: "Mixing Consoles", "Microphones & IEMs", "Cameras & Acquisition"
  - Used for detailed organization and markdown generation

#### Status and Health Monitoring
- **`status`** (VARCHAR(20) NOT NULL DEFAULT 'active')
  - Current status of the vendor entry
  - Values: "active", "inactive", "pending_review"
  - Used for filtering and health monitoring

- **`last_status_change`** (TIMESTAMP WITH TIME ZONE)
  - When the status was last changed
  - Used for tracking status changes over time
  - NULL if status has never changed

- **`last_checked`** (TIMESTAMP WITH TIME ZONE)
  - When the URL was last checked for health
  - Used for health monitoring scheduling
  - NULL if never checked

- **`health_notes`** (TEXT)
  - Additional notes about URL health status
  - Examples: "HTTP 404", "Timeout", "Redirect to new domain"
  - Used for debugging and manual review

#### Metadata
- **`date_added`** (TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW())
  - When the vendor was first added to the database
  - Used for tracking and reporting

- **`created_by`** (VARCHAR(20) NOT NULL)
  - Source of the vendor entry
  - Values: "form", "import", "manual"
  - Used for tracking entry sources

- **`created_at`** (TIMESTAMP WITH TIME ZONE DEFAULT NOW())
  - Record creation timestamp
  - Used for auditing and debugging

- **`updated_at`** (TIMESTAMP WITH TIME ZONE DEFAULT NOW())
  - Record last update timestamp
  - Used for auditing and change tracking

## Indexes

### Primary Indexes
```sql
-- Primary key (automatically created)
CREATE UNIQUE INDEX vendors_pkey ON vendors(id);
```

### Performance Indexes
```sql
-- Vendor name lookup and duplicate detection
CREATE INDEX idx_vendors_name ON vendors(vendor_name);

-- URL lookup and duplicate detection
CREATE INDEX idx_vendors_url ON vendors(url);

-- Status filtering for health monitoring
CREATE INDEX idx_vendors_status ON vendors(status);

-- Category and subcategory for markdown generation
CREATE INDEX idx_vendors_category ON vendors(category, subcategory);

-- Health monitoring scheduling
CREATE INDEX idx_vendors_last_checked ON vendors(last_checked) WHERE status = 'active';

-- Status change tracking
CREATE INDEX idx_vendors_status_change ON vendors(last_status_change);
```

### Composite Indexes
```sql
-- Duplicate detection
CREATE UNIQUE INDEX idx_vendors_name_url ON vendors(vendor_name, url);

-- Active entries by category
CREATE INDEX idx_vendors_active_category ON vendors(category, subcategory) WHERE status = 'active';

-- Health monitoring priority
CREATE INDEX idx_vendors_health_priority ON vendors(last_checked, status) WHERE status = 'active';
```

## Constraints

### Check Constraints
```sql
-- Status validation
ALTER TABLE vendors ADD CONSTRAINT chk_status
CHECK (status IN ('active', 'inactive', 'pending_review'));

-- Created by validation
ALTER TABLE vendors ADD CONSTRAINT chk_created_by
CHECK (created_by IN ('form', 'import', 'manual'));

-- URL format validation (basic)
ALTER TABLE vendors ADD CONSTRAINT chk_url_format
CHECK (url ~ '^https?://[^\s]+$');
```

### Not Null Constraints
- `vendor_name` - Required for all entries
- `url` - Required for all entries
- `category` - Required for categorization
- `subcategory` - Required for categorization
- `status` - Required for status tracking
- `date_added` - Required for tracking
- `created_by` - Required for source tracking

## Triggers

### Update Timestamp Trigger
```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_vendors_updated_at
BEFORE UPDATE ON vendors
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Status Change Tracking Trigger
```sql
CREATE OR REPLACE FUNCTION track_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        NEW.last_status_change = NOW();
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER track_vendors_status_change
BEFORE UPDATE ON vendors
FOR EACH ROW EXECUTE FUNCTION track_status_change();
```

## Views

### Active Vendors View
```sql
CREATE VIEW active_vendors AS
SELECT
    id,
    vendor_name,
    url,
    description,
    category,
    subcategory,
    date_added,
    last_checked,
    created_by
FROM vendors
WHERE status = 'active'
ORDER BY category, subcategory, vendor_name;
```

### Health Monitoring View
```sql
CREATE VIEW health_monitoring AS
SELECT
    id,
    vendor_name,
    url,
    category,
    subcategory,
    status,
    last_checked,
    health_notes,
    CASE
        WHEN last_checked IS NULL THEN 'Never Checked'
        WHEN last_checked < NOW() - INTERVAL '30 days' THEN 'Overdue'
        WHEN last_checked < NOW() - INTERVAL '7 days' THEN 'Due Soon'
        ELSE 'Recent'
    END as check_status
FROM vendors
WHERE status IN ('active', 'pending_review')
ORDER BY last_checked ASC NULLS FIRST;
```

### Category Summary View
```sql
CREATE VIEW category_summary AS
SELECT
    category,
    subcategory,
    COUNT(*) as total_vendors,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_vendors,
    COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_vendors,
    COUNT(CASE WHEN status = 'pending_review' THEN 1 END) as pending_vendors
FROM vendors
GROUP BY category, subcategory
ORDER BY category, subcategory;
```

## Data Types and Validation

### Vendor Name
- **Type**: VARCHAR(255)
- **Validation**: Non-empty, reasonable length
- **Examples**: "Allen & Heath", "Solid State Logic", "Lawo"

### URL
- **Type**: TEXT
- **Validation**: Valid HTTP/HTTPS URL format
- **Examples**: "https://www.allen-heath.com/", "https://calrec.com/"

### Description
- **Type**: TEXT
- **Validation**: Optional, reasonable length
- **Examples**: "Mixers and control surfaces", "Broadcast audio mixing"

### Category
- **Type**: VARCHAR(100)
- **Validation**: Must match predefined categories
- **Values**: Audio, Video, Lighting & Rigging, Networking & Control, Infrastructure & Hardware, Power & Distribution, Software

### Subcategory
- **Type**: VARCHAR(100)
- **Validation**: Must match predefined subcategories within category
- **Examples**: Mixing Consoles, Microphones & IEMs, Cameras & Acquisition

### Status
- **Type**: VARCHAR(20)
- **Validation**: Must be one of: active, inactive, pending_review
- **Default**: active

## Migration Scripts

### Initial Schema Creation
```sql
-- Create vendors table
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(255) NOT NULL,
    url TEXT NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    last_status_change TIMESTAMP WITH TIME ZONE,
    date_added TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_checked TIMESTAMP WITH TIME ZONE,
    created_by VARCHAR(20) NOT NULL,
    health_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_vendors_name ON vendors(vendor_name);
CREATE INDEX idx_vendors_url ON vendors(url);
CREATE INDEX idx_vendors_status ON vendors(status);
CREATE INDEX idx_vendors_category ON vendors(category, subcategory);
CREATE INDEX idx_vendors_last_checked ON vendors(last_checked) WHERE status = 'active';
CREATE UNIQUE INDEX idx_vendors_name_url ON vendors(vendor_name, url);

-- Create constraints
ALTER TABLE vendors ADD CONSTRAINT chk_status
CHECK (status IN ('active', 'inactive', 'pending_review'));
ALTER TABLE vendors ADD CONSTRAINT chk_created_by
CHECK (created_by IN ('form', 'import', 'manual'));
ALTER TABLE vendors ADD CONSTRAINT chk_url_format
CHECK (url ~ '^https?://[^\s]+$');

-- Create triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_vendors_updated_at
BEFORE UPDATE ON vendors
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION track_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        NEW.last_status_change = NOW();
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER track_vendors_status_change
BEFORE UPDATE ON vendors
FOR EACH ROW EXECUTE FUNCTION track_status_change();
```

## NocoDB Configuration

### Table Configuration
- **Table Name**: vendors
- **Display Name**: Vendors
- **Description**: Vendor information for Awesome Production list

### Field Configuration
- **vendor_name**: Text field, required, searchable
- **url**: URL field, required, searchable
- **description**: Long text field, optional
- **category**: Single select, required, searchable
- **subcategory**: Single select, required, searchable
- **status**: Single select, required, filterable
- **date_added**: Date field, read-only
- **last_checked**: Date field, filterable
- **created_by**: Single select, required, filterable

### Views in NocoDB
- **All Vendors**: Complete list with all fields
- **Active Vendors**: Filtered to active status only
- **Health Monitoring**: Focused on health check data
- **By Category**: Grouped by category and subcategory

## Backup and Recovery

### Backup Strategy
- **Daily Backups**: Full database backup
- **Transaction Logs**: Continuous backup for point-in-time recovery
- **Schema Backups**: Version control for schema changes

### Recovery Procedures
- **Point-in-Time Recovery**: Restore to specific timestamp
- **Schema Recovery**: Restore from version control
- **Data Validation**: Verify data integrity after recovery

## Performance Considerations

### Query Optimization
- **Index Usage**: Monitor index usage and effectiveness
- **Query Analysis**: Regular analysis of slow queries
- **Connection Pooling**: Optimize database connections

### Scaling Considerations
- **Partitioning**: Consider partitioning by category if table grows large
- **Read Replicas**: Use read replicas for reporting queries
- **Caching**: Implement caching for frequently accessed data

## Security Considerations

### Access Control
- **Role-Based Access**: Different access levels for different users
- **API Access**: Secure API access for n8n workflows
- **Audit Logging**: Track all database access and changes

### Data Protection
- **Encryption**: Encrypt sensitive data at rest
- **Network Security**: Secure database connections
- **Regular Updates**: Keep database software updated
