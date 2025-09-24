# Awesome Production Data Management System

A comprehensive n8n-based workflow system for managing the [Awesome Production](https://github.com/Capp3/awesome-production) list with automated data entry, categorization, and health monitoring.

## Overview

This project automates the management of a curated list of manufacturers, vendors, standards organizations, and useful resources for live events, concert touring, theatre, and broadcast. The system uses n8n workflows to handle data entry, LLM-powered categorization, and automated health monitoring.

## System Architecture

The system consists of three main workflows:

1. **One-Time Import Workflow** - Populates the database with existing Awesome List data
2. **New Entry Workflow** - Processes new vendor submissions via web form
3. **Health Check Workflow** - Monthly monitoring of all vendor URLs

## Database Schema

The system uses NocoDB/PostgreSQL to store vendor information with the following structure:

- `id` (Primary Key)
- `vendor_name` (Text)
- `url` (Text)
- `description` (Text, optional)
- `category` (Text) - Main category (e.g., "Audio", "Video", "Lighting & Rigging")
- `subcategory` (Text) - Subcategory (e.g., "Mixing Consoles", "Microphones & IEMs")
- `status` (Text) - "active", "inactive", "pending_review"
- `last_status_change` (DateTime)
- `date_added` (DateTime)
- `last_checked` (DateTime)
- `created_by` (Text) - "form", "import", "manual"

## Workflow Documentation

- [One-Time Import Workflow](workflows/01-import-workflow.md) - Initial data population
- [New Entry Workflow](workflows/02-new-entry-workflow.md) - Processing new submissions
- [Health Check Workflow](workflows/03-health-check-workflow.md) - URL monitoring and maintenance
- [Database Schema](database/schema.md) - Detailed database structure

## Key Features

- **Automated Categorization**: Uses LLM to categorize new entries based on existing list structure
- **Duplicate Detection**: Prevents duplicate entries by checking vendor name and URL
- **Health Monitoring**: Monthly checks to ensure all URLs are still active
- **GitHub Integration**: Creates pull requests for all changes, allowing human review
- **Markdown Generation**: Automatically rebuilds the entire README from database
- **Error Handling**: Comprehensive error handling for API failures and data issues

## Technical Stack

- **n8n**: Workflow automation platform
- **NocoDB/PostgreSQL**: Database management
- **LLM Integration**: Automated categorization
- **GitHub API**: Version control and PR management
- **HTTP Requests**: Health monitoring and data fetching

## Prerequisites

- n8n instance (self-hosted or cloud)
- PostgreSQL database (or NocoDB)
- GitHub repository access
- LLM API access (OpenAI, Anthropic, etc.)

## Getting Started

1. Set up your database with the defined schema
2. Configure n8n with required credentials
3. Run the one-time import workflow to populate initial data
4. Deploy the new entry workflow for form submissions
5. Schedule the health check workflow for monthly monitoring

## Resources

- [n8n Documentation](https://n8n.io/docs/)
- [n8n Node Reference](https://github.com/n8n-io/n8n/tree/master/packages/nodes-base)
- [n8n Integrations](https://n8n.io/integrations/)
- [Context7 n8n Resources](https://context7.com/?q=n8n)

## Project Structure

```
awesome/
├── README.md                           # This file
├── awesomedata.md                     # Original project notes
├── workflows/                         # Individual workflow documentation
│   ├── 01-import-workflow.md
│   ├── 02-new-entry-workflow.md
│   └── 03-health-check-workflow.md
└── database/                          # Database documentation
    └── schema.md
```

## Contributing

This is an internal project for managing the Awesome Production list. For questions or issues, please refer to the individual workflow documentation or contact the project maintainer.

## License

This project is part of the Awesome Production list management system.
