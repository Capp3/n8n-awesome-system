# Installation Guide - Awesome Production Data Management System

## Prerequisites

### System Requirements

- **Operating System**: Linux (Ubuntu 20.04+ recommended)
- **CPU**: 4+ cores for optimal performance
- **RAM**: 8GB+ for n8n and database
- **Storage**: 50GB+ for database and logs
- **Network**: Stable internet for API calls

### Software Dependencies

- **Node.js**: Version 18+ (required for n8n 1.113.3)
- **PostgreSQL**: Version 12+ (required for NocoDB 0.264.9)
- **Docker**: Optional for containerized deployment
- **Git**: For repository management

## Installation Steps

### 1. Install Node.js 18+

```bash
# Update package index
sudo apt update

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

### 2. Install PostgreSQL 12+

```bash
# Install PostgreSQL
sudo apt install postgresql postgresql-contrib

# Start and enable PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database and user
sudo -u postgres psql
```

```sql
-- In PostgreSQL shell
CREATE DATABASE awesome_production;
CREATE USER n8n_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE awesome_production TO n8n_user;
\q
```

### 3. Install n8n 1.113.3

```bash
# Install n8n globally
sudo npm install -g n8n@1.113.3

# Create n8n directory
sudo mkdir -p /opt/n8n
sudo chown -R $USER:$USER /opt/n8n

# Set environment variables
export N8N_BASIC_AUTH_ACTIVE=true
export N8N_BASIC_AUTH_USER=admin
export N8N_BASIC_AUTH_PASSWORD=your_admin_password
export DB_TYPE=postgresdb
export DB_POSTGRESDB_HOST=localhost
export DB_POSTGRESDB_PORT=5432
export DB_POSTGRESDB_DATABASE=awesome_production
export DB_POSTGRESDB_USER=n8n_user
export DB_POSTGRESDB_PASSWORD=your_secure_password

# Start n8n
n8n start
```

### 4. Install NocoDB 0.264.9

```bash
# Install NocoDB 0.264.9 via Docker
docker run -d \
  --name nocodb \
  -p 8080:8080 \
  -e NC_DB="postgresql://n8n_user:your_secure_password@localhost:5432/awesome_production" \
  -e NC_AUTH_JWT_SECRET="your_jwt_secret" \
  nocodb/nocodb:0.264.9
```

### 5. Verify Installation

1. **n8n**: Access at `http://localhost:5678`
2. **NocoDB**: Access at `http://localhost:8080`
3. **PostgreSQL**: Test connection with `psql -h localhost -U n8n_user -d awesome_production`

## Configuration

### n8n Configuration

1. **Access n8n**: Navigate to `http://localhost:5678`
2. **Login**: Use admin credentials set in environment variables
3. **Configure Credentials**:
   - GitHub API token
   - AI Agent node configuration
   - Database connection (should auto-configure)

### Database Setup

1. **Run Schema Creation**:

```bash
psql -h localhost -U n8n_user -d awesome_production -f database/create_schema.sql
```

2. **Verify Tables**:

```sql
\dt
SELECT COUNT(*) FROM vendors;
```

### NocoDB Configuration

1. **Access NocoDB**: Navigate to `http://localhost:8080`
2. **Create Account**: Set up admin account
3. **Connect Database**: Should auto-detect PostgreSQL connection
4. **Verify Tables**: Check that vendors table is visible

## Testing Installation

### 1. Test n8n Functionality

- Create a simple workflow
- Test database connection
- Verify GitHub API access

### 2. Test Database Connection

```sql
-- Test basic operations
INSERT INTO vendors (vendor_name, url, category, status)
VALUES ('Test Vendor', 'https://example.com', 'Test Category', 'active');

SELECT * FROM vendors WHERE vendor_name = 'Test Vendor';
```

### 3. Test NocoDB Interface

- Access the web interface
- Verify table visibility
- Test basic CRUD operations

## Troubleshooting

### Common Issues

1. **n8n Won't Start**

   - Check Node.js version: `node --version`
   - Verify environment variables
   - Check port availability: `netstat -tulpn | grep :5678`

2. **Database Connection Issues**

   - Verify PostgreSQL is running: `sudo systemctl status postgresql`
   - Check credentials and permissions
   - Test connection: `psql -h localhost -U n8n_user -d awesome_production`

3. **NocoDB Connection Issues**
   - Check Docker container: `docker ps | grep nocodb`
   - Verify database connection string
   - Check logs: `docker logs nocodb`

### Log Locations

- **n8n Logs**: Check terminal output or `/opt/n8n/logs/`
- **PostgreSQL Logs**: `/var/log/postgresql/postgresql-*.log`
- **NocoDB Logs**: `docker logs nocodb`

## Next Steps

After successful installation:

1. **Import Workflows**: Follow the [Import Workflow Guide](workflows/import-workflow-implementation.md)
2. **Configure APIs**: Set up GitHub and AI Agent credentials
3. **Test System**: Run through the testing procedures
4. **Deploy**: Follow the deployment guide for production setup

## Security Considerations

- Change default passwords
- Use strong database passwords
- Configure firewall rules
- Enable SSL/TLS for production
- Regular security updates

## Support

For installation issues:

1. Check the troubleshooting section
2. Review n8n documentation
3. Check GitHub issues
4. Contact the development team
