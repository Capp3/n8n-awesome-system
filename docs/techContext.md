# Technical Context - Awesome Production Data Management System

## Technology Stack

### Core Platform

- **n8n**: Self-hosted workflow automation platform (version 1.114.4)
- **Node.js**: Runtime environment for n8n
- **Airtable**: Cloud database and interface (replacing PostgreSQL/NocoDB)

### Database Layer

- **Airtable**: Primary database and interface
- **Schema**: Normalized structure for vendor data
- **Previous Stack**: PostgreSQL/NocoDB (migrating away)

### External Integrations

- **GitHub API**: Repository management and PR creation
- **AI Agent Node**: n8n 1.114.4 AI Agent node for categorization (not provider-specific)
- **HTTP APIs**: URL health monitoring
- **Context7**: Code review and n8n best practices validation

## System Requirements

### Hardware Requirements

- **CPU**: 2+ cores recommended for n8n
- **RAM**: 4GB+ for optimal performance
- **Storage**: 10GB+ for database and logs
- **Network**: Stable internet for API calls and Airtable access

### Software Dependencies

- **Node.js**: Version 18+ (n8n requirement)
- **n8n**: Version 1.114.4 (self-hosted)
- **Airtable**: Cloud-based (no local installation required)
- **Docker**: Optional for containerized n8n deployment

## n8n 1.114.4 Implementation Requirements

### Node Usage Guidelines

- **Purpose-Built Nodes**: Always use n8n's purpose-built nodes
- **AI Agent Node**: Use for all LLM operations (not OpenAI/Anthropic nodes) - Available in n8n 1.114.4
- **Avoid Code Blocks**: Minimize use of Function/Code nodes
- **Context7 Validation**: All implementations must be validated with Context7

### Required Node Types

1. **GitHub Node**: Repository operations and PR creation
2. **Airtable Node**: Database operations and queries
3. **AI Agent Node**: LLM categorization and processing
4. **HTTP Request Node**: URL health monitoring
5. **Webhook Node**: Form submission handling
6. **Schedule Node**: Automated health check triggers
7. **Set Node**: Data transformation and mapping
8. **Switch Node**: Conditional logic and routing
9. **HTML Node**: HTML content extraction
10. **Markdown Node**: Markdown to HTML conversion
11. **Split In Batches Node**: Iterative processing

### Prohibited Patterns

- **Code Block Overuse**: Avoid Function nodes for simple operations
- **Provider-Specific AI**: Don't use OpenAI/Anthropic nodes directly
- **Complex Custom Logic**: Use built-in node capabilities instead

## Database Schema (Airtable)

### Core Table: Vendors

**Base Name**: Awesome Production Data
**Table Name**: Vendors

### Key Fields

- **Vendor Name** (Single line text, Primary field)
- **URL** (URL field)
- **Description** (Long text, optional)
- **Category** (Single select) - Main category
- **Subcategory** (Single select) - Specific subcategory
- **Status** (Single select) - active/inactive/pending_review
- **Last Status Change** (Date field)
- **Date Added** (Date field, auto-populated)
- **Last Checked** (Date field)
- **Created By** (Single select) - form/import/manual
- **Health Notes** (Long text, optional)

### Airtable Features

- **Views**: All Vendors, Active Only, By Category, Health Monitoring
- **Filters**: Pre-configured filters for each view
- **Sorting**: By category, subcategory, vendor name
- **Grouping**: By category for easy navigation

## API Integrations

### GitHub API

- **Authentication**: Personal access token
- **Endpoints**: Repository, PR, and file management
- **Rate Limits**: 5000 requests/hour for authenticated users

### Airtable API

- **Authentication**: API key or Personal Access Token
- **Endpoints**: Record creation, updates, queries
- **Rate Limits**: 5 requests/second per base

### LLM APIs (via AI Agent Node)

- **OpenAI**: GPT-3.5/4 for categorization
- **Anthropic**: Claude as alternative
- **Rate Limits**: Varies by provider and plan
- **Integration**: Through n8n AI Agent node

### Health Monitoring

- **HTTP Requests**: Direct URL checking
- **Timeout**: 30 seconds per URL
- **Retry Logic**: 3 attempts with exponential backoff

## Deployment Architecture

### Development Environment

- **Local n8n**: Docker or direct installation (v1.114.4)
- **Airtable**: Cloud-based, accessed via API
- **Testing**: Manual triggers and workflow testing

### Production Environment

- **n8n**: Self-hosted or cloud (v1.114.4)
- **Airtable**: Cloud-based managed service
- **Monitoring**: Built-in n8n monitoring + custom alerts

## Security Considerations

### API Security

- **Credential Management**: n8n encrypted credential storage
- **API Key Rotation**: Regular credential updates
- **Rate Limiting**: Respect API limits and implement backoff

### Data Security

- **Airtable Encryption**: At-rest and in-transit encryption (managed by Airtable)
- **Access Control**: Airtable workspace permissions
- **Backup Strategy**: Airtable automatic backups + manual exports

## Performance Considerations

### Workflow Optimization

- **Parallel Processing**: Concurrent URL health checks
- **Batch Operations**: Bulk Airtable record updates
- **Caching**: LLM response caching for similar entries

### Monitoring

- **Workflow Metrics**: Execution time and success rates
- **Airtable Performance**: API rate limit monitoring
- **API Usage**: Rate limit monitoring and optimization

## Migration Notes

### PostgreSQL/NocoDB → Airtable

**Reason for Migration**:

- Simpler setup and management
- Better UI for data viewing
- Native n8n integration
- No self-hosted database maintenance

**Migration Impact**:

- All workflow documentation needs updating
- Node configurations change from PostgreSQL to Airtable
- Schema remains conceptually the same
- Improved ease of use and collaboration
