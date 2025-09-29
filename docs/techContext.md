# Technical Context - Awesome Production Data Management System

## Technology Stack

### Core Platform

- **n8n**: Self-hosted workflow automation platform (version 1.112.4)
- **Node.js**: Runtime environment for n8n
- **PostgreSQL**: Primary database backend

### Database Layer

- **NocoDB**: Database interface and management
- **PostgreSQL**: Relational database for data storage
- **Schema**: Normalized structure for vendor data

### External Integrations

- **GitHub API**: Repository management and PR creation
- **AI Agent Node**: n8n 1.112.4 AI Agent node for categorization (not provider-specific)
- **HTTP APIs**: URL health monitoring
- **Context7**: Code review and n8n best practices validation

## System Requirements

### Hardware Requirements

- **CPU**: 2+ cores recommended for n8n
- **RAM**: 4GB+ for optimal performance
- **Storage**: 10GB+ for database and logs
- **Network**: Stable internet for API calls

### Software Dependencies

- **Node.js**: Version 18+ (n8n requirement)
- **PostgreSQL**: Version 12+ (NocoDB requirement)
- **n8n**: Version 1.112.4 (self-hosted)
- **Docker**: Optional for containerized deployment

## n8n 1.112.4 Implementation Requirements

### Node Usage Guidelines

- **Purpose-Built Nodes**: Always use n8n's purpose-built nodes
- **AI Agent Node**: Use for all LLM operations (not OpenAI/Anthropic nodes) - Available in n8n 1.112.4
- **Avoid Code Blocks**: Minimize use of Function/Code nodes
- **Context7 Validation**: All implementations must be validated with Context7

### Required Node Types

1. **GitHub Node**: Repository operations and PR creation
2. **PostgreSQL Node**: Database operations and queries
3. **AI Agent Node**: LLM categorization and processing
4. **HTTP Request Node**: URL health monitoring
5. **Webhook Node**: Form submission handling
6. **Schedule Node**: Automated health check triggers
7. **Set Node**: Data transformation and mapping
8. **Switch Node**: Conditional logic and routing

### Prohibited Patterns

- **Code Block Overuse**: Avoid Function nodes for simple operations
- **Provider-Specific AI**: Don't use OpenAI/Anthropic nodes directly
- **Complex Custom Logic**: Use built-in node capabilities instead

## Database Schema

### Core Tables

- **vendors**: Primary vendor information
- **categories**: Category hierarchy
- **health_checks**: URL monitoring history
- **submissions**: Form submission tracking

### Key Fields

- **vendor_name**: Unique identifier
- **url**: Vendor website URL
- **category/subcategory**: Hierarchical categorization
- **status**: active/inactive/pending_review
- **timestamps**: Creation, update, and check times

## API Integrations

### GitHub API

- **Authentication**: Personal access token
- **Endpoints**: Repository, PR, and file management
- **Rate Limits**: 5000 requests/hour for authenticated users

### LLM APIs

- **OpenAI**: GPT-3.5/4 for categorization
- **Anthropic**: Claude as alternative
- **Rate Limits**: Varies by provider and plan

### Health Monitoring

- **HTTP Requests**: Direct URL checking
- **Timeout**: 30 seconds per URL
- **Retry Logic**: 3 attempts with exponential backoff

## Deployment Architecture

### Development Environment

- **Local n8n**: Docker or direct installation
- **Local PostgreSQL**: Docker or system installation
- **NocoDB**: Docker container or cloud instance

### Production Environment

- **n8n Cloud**: Managed service (recommended)
- **Database**: Managed PostgreSQL (AWS RDS, etc.)
- **Monitoring**: Built-in n8n monitoring + custom alerts

## Security Considerations

### API Security

- **Credential Management**: n8n encrypted credential storage
- **API Key Rotation**: Regular credential updates
- **Rate Limiting**: Respect API limits and implement backoff

### Data Security

- **Database Encryption**: At-rest and in-transit encryption
- **Access Control**: Role-based database access
- **Backup Strategy**: Regular automated backups

## Performance Considerations

### Workflow Optimization

- **Parallel Processing**: Concurrent URL health checks
- **Batch Operations**: Bulk database updates
- **Caching**: LLM response caching for similar entries

### Monitoring

- **Workflow Metrics**: Execution time and success rates
- **Database Performance**: Query optimization and indexing
- **API Usage**: Rate limit monitoring and optimization
