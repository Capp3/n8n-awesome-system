# Awesome Production Data Management System

Welcome to the Awesome Production Data Management System documentation.

This system provides comprehensive n8n-based workflow automation for managing the [Awesome Production](https://github.com/Capp3/awesome-production) list with automated data entry, categorization, and health monitoring.

## 🎯 System Overview

The Awesome Production Data Management System is a Level 4 complex system that automates the management of a curated list of manufacturers, vendors, standards organizations, and useful resources for live events, concert touring, theatre, and broadcast.

### Key Features

- **Automated Data Entry**: Process new vendor submissions through web forms
- **AI-Powered Categorization**: Automated category assignment using LLM
- **Health Monitoring**: Regular checks to ensure all vendor URLs remain active
- **Repository Management**: Automatic updates and pull requests to the main repository
- **Database Management**: Centralized data storage with NocoDB/PostgreSQL

## 🏗️ Architecture

The system consists of three main workflows:

1. **Import Workflow** - One-time data migration from existing Awesome List
2. **New Entry Workflow** - Processes new vendor submissions via web form
3. **Health Check Workflow** - Monthly monitoring of all vendor URLs

## 🚀 Quick Start

1. **Prerequisites**: n8n 1.112.4, PostgreSQL, NocoDB
2. **Installation**: Follow the [Installation Guide](docs/installation.md)
3. **Configuration**: Set up database and API credentials
4. **Deployment**: Import workflows and configure nodes

## 📚 Documentation Structure

- **Getting Started**: Overview, requirements, and installation
- **Architecture**: System patterns and implementation details
- **Workflows**: Detailed workflow documentation and diagrams
- **Database**: Schema and setup information
- **Development**: Active context and progress tracking

## 🔧 Technology Stack

- **n8n 1.112.4**: Self-hosted workflow automation platform
- **PostgreSQL**: Primary database backend
- **NocoDB**: Database interface and management
- **GitHub API**: Repository management and PR creation
- **AI Agent Node**: LLM categorization and processing

## 📖 Contributing

This system is designed for the Awesome Production project. For questions or contributions, please refer to the [GitHub repository](https://github.com/Capp3/awesome-production).
