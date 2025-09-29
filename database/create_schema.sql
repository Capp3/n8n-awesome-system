-- Awesome Production Data Management System
-- Database Schema Creation Script
-- PostgreSQL Database Schema

-- Create vendors table
CREATE TABLE IF NOT EXISTS vendors (
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

-- Create essential indexes for performance
CREATE INDEX IF NOT EXISTS idx_vendors_name ON vendors(vendor_name);
CREATE INDEX IF NOT EXISTS idx_vendors_url ON vendors(url);
CREATE INDEX IF NOT EXISTS idx_vendors_status ON vendors(status);
CREATE INDEX IF NOT EXISTS idx_vendors_category ON vendors(category, subcategory);
CREATE INDEX IF NOT EXISTS idx_vendors_last_checked ON vendors(last_checked) WHERE status = 'active';
CREATE UNIQUE INDEX IF NOT EXISTS idx_vendors_name_url ON vendors(vendor_name, url);

-- Create constraints
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_status') THEN
        ALTER TABLE vendors ADD CONSTRAINT chk_status
        CHECK (status IN ('active', 'inactive', 'pending_review'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_created_by') THEN
        ALTER TABLE vendors ADD CONSTRAINT chk_created_by
        CHECK (created_by IN ('form', 'import', 'manual'));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'chk_url_format') THEN
        ALTER TABLE vendors ADD CONSTRAINT chk_url_format
        CHECK (url ~ '^https?://[^\s]+$');
    END IF;
END $$;

-- Create triggers for automatic timestamp updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_vendors_updated_at ON vendors;
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

DROP TRIGGER IF EXISTS track_vendors_status_change ON vendors;
CREATE TRIGGER track_vendors_status_change
BEFORE UPDATE ON vendors
FOR EACH ROW EXECUTE FUNCTION track_status_change();

-- Create useful views
CREATE OR REPLACE VIEW active_vendors AS
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

CREATE OR REPLACE VIEW health_monitoring AS
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

CREATE OR REPLACE VIEW category_summary AS
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

-- Insert sample data for testing (optional)
INSERT INTO vendors (vendor_name, url, description, category, subcategory, created_by) VALUES
('Test Vendor 1', 'https://example1.com', 'Test description 1', 'Audio', 'Mixing Consoles', 'manual'),
('Test Vendor 2', 'https://example2.com', 'Test description 2', 'Video', 'Cameras & Acquisition', 'manual')
ON CONFLICT (vendor_name, url) DO NOTHING;

-- Verify schema creation
SELECT 'Schema created successfully' as status;
SELECT COUNT(*) as vendor_count FROM vendors;
SELECT * FROM category_summary;
