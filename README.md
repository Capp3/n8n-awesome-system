# Awesome Production Data Management System

A comprehensive n8n-based workflow system for managing the [Awesome Production](https://github.com/Capp3/awesome-production) list with automated data entry, categorization, and health monitoring.

## Purpose & Relationship

This repository serves as the **data management backend** for the [Awesome Production](https://github.com/Capp3/awesome-production) repository. The Awesome Production list is a curated collection of manufacturers, vendors, standards organizations, and useful resources for live events, concert touring, theatre, and broadcast.

**Key Points:**
- This system automates the maintenance and updates of the Awesome Production list
- All changes are synchronized with the main [awesome-production](https://github.com/Capp3/awesome-production) repository
- The system ensures data quality, prevents duplicates, and maintains URL health
- Updates to the Awesome Production list should be made through this system, not directly in the main repo

## What This System Does

This project provides a complete automation solution for managing the Awesome Production list, including:

- **Data Entry Automation**: Process new vendor submissions through web forms
- **Quality Assurance**: Automated categorization using LLM and duplicate detection
- **Health Monitoring**: Regular checks to ensure all vendor URLs remain active
- **Repository Management**: Automatic updates and pull requests to the main repository

## System Architecture

The system consists of three main workflows:

1. **One-Time Import Workflow** - Populates the database with existing Awesome List data
2. **New Entry Workflow** - Processes new vendor submissions via web form
3. **Health Check Workflow** - Monthly monitoring of all vendor URLs

## Database Schema

The system uses NocoDB as the database interface with PostgreSQL as the backend to store vendor information. The database structure includes:

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
- **Repository Sync**: Keeps the main [awesome-production](https://github.com/Capp3/awesome-production) repository updated with all changes

## Technical Stack

- **n8n**: Workflow automation platform
- **NocoDB/PostgreSQL**: Database management
- **LLM Integration**: Automated categorization
- **GitHub API**: Version control and PR management
- **HTTP Requests**: Health monitoring and data fetching

## Prerequisites

Before setting up this system, you'll need:

- **n8n instance** (self-hosted or cloud) - The workflow automation platform
- **NocoDB** - Database interface and management (NocoDB setup and configuration is not covered in this documentation)
- **PostgreSQL database** - Backend storage (can be managed through NocoDB)
- **GitHub repository access** - For creating pull requests to the main awesome-production repo
- **LLM API access** - OpenAI, Anthropic, or similar for automated categorization

> **Note**: This documentation assumes you already have NocoDB installed and configured. NocoDB setup, configuration, and administration are outside the scope of this project documentation.

## Getting Started

### Quick Setup Guide

1. **Database Setup**: Create the database schema in your NocoDB instance (see [Database Schema](database/schema.md))
2. **n8n Configuration**: Import workflows and configure API credentials for GitHub and LLM services
3. **Initial Data Load**: Run the [One-Time Import Workflow](workflows/01-import-workflow.md) to populate existing data
4. **Deploy Entry System**: Set up the [New Entry Workflow](workflows/02-new-entry-workflow.md) for processing submissions
5. **Schedule Monitoring**: Configure the [Health Check Workflow](workflows/03-health-check-workflow.md) to run monthly

### Important Setup Notes

- Ensure your NocoDB instance is properly connected to PostgreSQL
- Configure all required API keys and credentials in n8n
- Test each workflow individually before deploying to production
- Verify GitHub permissions for creating pull requests to the awesome-production repository

## Resources

### n8n Resources
- [n8n Documentation](https://n8n.io/docs/)
- [n8n Node Reference](https://github.com/n8n-io/n8n/tree/master/packages/nodes-base)
- [n8n Integrations](https://n8n.io/integrations/)
- [Context7 n8n Resources](https://context7.com/?q=n8n)

### NocoDB Resources
- [NocoDB Documentation](https://docs.nocodb.com/)
- [NocoDB GitHub](https://github.com/nocodb/nocodb)

> **Note**: For NocoDB setup and configuration help, please refer to the official NocoDB documentation.

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

This is the data management system for the [Awesome Production](https://github.com/Capp3/awesome-production) list. 

**For Awesome List Updates:**
- All updates to the Awesome Production list should be made through this system
- Use the new entry workflow for adding vendors
- The system will automatically create pull requests to the main repository
- Do not make direct changes to the main awesome-production repository

**For System Development:**
- This repository contains the n8n workflows and database management system
- For questions or issues with the data management system, please refer to the individual workflow documentation or contact the project maintainer

## License

This project is part of the Awesome Production list management system.

### GPT-3 License

This project uses GPT-3 for automated categorization of vendor entries. The use of GPT-3 is subject to OpenAI's Terms of Service and API usage policies. Please ensure you have appropriate OpenAI API access and are compliant with their usage terms when using this system.
