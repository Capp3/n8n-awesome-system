# Database Setup Guide

## 🎯 Quick Setup Instructions

Since you have NocoDB connected to PostgreSQL with a "base" setup and no tables, here's how to create the database schema:

> **Note**: This guide is specifically for NocoDB version 0.264.9. If you're using a different version, some features may vary.

### Option 1: Using NocoDB Interface (Recommended)

1. **Access NocoDB**: Go to your NocoDB interface
2. **Create Table**: Click "Create Table" or "+"
3. **Table Name**: Enter `vendors`
4. **Add Columns**: Add the following columns:
   - `id` (Auto Number, Primary Key)
   - `vendor_name` (Single Line Text, Required)
   - `url` (URL, Required)
   - `description` (Long Text)
   - `category` (Single Line Text, Required)
   - `subcategory` (Single Line Text, Required)
   - `status` (Single Select: active, inactive, pending_review, Default: active)
   - `last_status_change` (DateTime)
   - `date_added` (DateTime, Default: Now)
   - `last_checked` (DateTime)
   - `created_by` (Single Select: form, import, manual, Required)
   - `health_notes` (Long Text)
   - `created_at` (DateTime, Default: Now)
   - `updated_at` (DateTime, Default: Now)

### Option 2: Using SQL Script (If you have direct PostgreSQL access)

1. **Connect to PostgreSQL**: Use your preferred PostgreSQL client
2. **Run Script**: Execute the `/database/create_schema.sql` file
3. **Verify**: Check that the `vendors` table was created

### Option 2.5: Connect to Existing PostgreSQL Database (NocoDB 0.264.9)

If you've already run the SQL script directly on PostgreSQL and want to connect NocoDB to your existing database:

1. **Access NocoDB Interface**: Go to your NocoDB web interface (typically `http://localhost:8080`)
2. **Create New Project**: Click "New Project" or the "+" button
3. **Select Database Type**: Choose "PostgreSQL" from the database options
4. **Enter Connection Details**:
   - **Host**: Your PostgreSQL server address (e.g., `localhost` or your server IP)
   - **Port**: `5432` (default PostgreSQL port)
   - **Database Name**: The name of your database where you ran the script
   - **Username**: Your PostgreSQL username
   - **Password**: Your PostgreSQL password
5. **Test Connection**: Click "Test Connection" to verify the connection works
6. **Create Project**: Click "Create Project" to connect to your existing database
7. **Verify Tables**: You should see your `vendors` table and any views you created

### Option 3: Using n8n PostgreSQL Node

1. **Create Test Workflow**: Create a simple n8n workflow
2. **Add PostgreSQL Node**: Configure with your database credentials
3. **Execute Query**: Run the SQL from `/database/create_schema.sql`

## 🔧 Verification Steps

After creating the table, verify it's working:

### Check Table Structure

```sql
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'vendors'
ORDER BY ordinal_position;
```

### Test Insert

```sql
INSERT INTO vendors (vendor_name, url, description, category, subcategory, created_by)
VALUES ('Test Vendor', 'https://example.com', 'Test description', 'Audio', 'Mixing Consoles', 'manual');
```

### Verify Data

```sql
SELECT * FROM vendors WHERE vendor_name = 'Test Vendor';
```

## 📊 Expected Table Structure

| Column             | Type         | Constraints | Default        |
| ------------------ | ------------ | ----------- | -------------- |
| id                 | SERIAL       | PRIMARY KEY | Auto-increment |
| vendor_name        | VARCHAR(255) | NOT NULL    | -              |
| url                | TEXT         | NOT NULL    | -              |
| description        | TEXT         | -           | -              |
| category           | VARCHAR(100) | NOT NULL    | -              |
| subcategory        | VARCHAR(100) | NOT NULL    | -              |
| status             | VARCHAR(20)  | NOT NULL    | 'active'       |
| last_status_change | TIMESTAMP    | -           | -              |
| date_added         | TIMESTAMP    | NOT NULL    | NOW()          |
| last_checked       | TIMESTAMP    | -           | -              |
| created_by         | VARCHAR(20)  | NOT NULL    | -              |
| health_notes       | TEXT         | -           | -              |
| created_at         | TIMESTAMP    | -           | NOW()          |
| updated_at         | TIMESTAMP    | -           | NOW()          |

## 🚨 Troubleshooting

### Issue: Table Already Exists

**Solution**: Drop the existing table first or use `CREATE TABLE IF NOT EXISTS`

### Issue: Permission Denied

**Solution**: Ensure your database user has CREATE TABLE permissions

### Issue: Column Type Mismatch

**Solution**: Check that your PostgreSQL version supports the data types used

### Issue: NocoDB Not Showing Table

**Solution**:

- Refresh NocoDB interface (Ctrl+F5 or Cmd+Shift+R)
- Check table permissions in PostgreSQL
- For NocoDB 0.264.9: Ensure your PostgreSQL user has `USAGE` permission on the schema
- Try disconnecting and reconnecting the project

### Issue: NocoDB 0.264.9 Connection Timeout

**Solution**:

- Check if PostgreSQL is accepting connections: `sudo systemctl status postgresql`
- Verify firewall settings allow port 5432
- For NocoDB 0.264.9, ensure the connection string format is correct

## 🎯 Next Steps

Once the database schema is created:

1. **Verify in NocoDB**: Confirm the `vendors` table appears in your NocoDB interface
2. **Test Connection**: Ensure n8n can connect to the database
3. **Configure n8n**: Set up PostgreSQL credentials in n8n
4. **Begin Workflow**: Start implementing the import workflow using the provided guide

## 📝 Notes

- The schema includes essential indexes for performance
- Triggers are set up for automatic timestamp updates
- Constraints ensure data integrity
- Views are created for common queries
- Sample data is included for testing (optional)

## 🆕 NocoDB 0.264.9 Features

### New Features Available

- **Dashboards**: Create visual dashboards for data monitoring
- **Private Base**: Enhanced security for sensitive data
- **Bulk Update Extension**: Efficiently update multiple records
- **Page Designer**: Custom page layouts and forms
- **Script Steps**: Advanced automation capabilities

### Version-Specific Considerations

- **UI Changes**: Updated interface with improved navigation
- **Performance**: Enhanced query performance and caching
- **Security**: Improved authentication and access controls
- **API**: Updated REST API endpoints and responses

This setup follows our focus principles:

- ✅ Essential features only
- ✅ No advanced features
- ✅ Basic schema for core functionality
- ✅ Ready for iterative import workflow
- ✅ Compatible with NocoDB 0.264.9
