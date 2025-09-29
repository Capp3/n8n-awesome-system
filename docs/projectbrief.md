# Project Brief - Awesome Production Data Management System

## Project Overview
A comprehensive n8n-based workflow system for managing the [Awesome Production](https://github.com/Capp3/awesome-production) list with automated data entry, categorization, and health monitoring.

## Purpose & Relationship
This repository serves as the **data management backend** for the [Awesome Production](https://github.com/Capp3/awesome-production) repository. The Awesome Production list is a curated collection of manufacturers, vendors, standards organizations, and useful resources for live events, concert touring, theatre, and broadcast.

## Key Objectives
- **Data Entry Automation**: Process new vendor submissions through web forms
- **Quality Assurance**: Automated categorization using LLM and duplicate detection
- **Health Monitoring**: Regular checks to ensure all vendor URLs remain active
- **Repository Management**: Automatic updates and pull requests to the main repository

## Technical Stack
- **n8n**: Workflow automation platform
- **NocoDB/PostgreSQL**: Database management
- **LLM Integration**: Automated categorization
- **GitHub API**: Version control and PR management
- **HTTP Requests**: Health monitoring and data fetching

## System Architecture
The system consists of three main workflows:
1. **One-Time Import Workflow** - Populates the database with existing Awesome List data
2. **New Entry Workflow** - Processes new vendor submissions via web form
3. **Health Check Workflow** - Monthly monitoring of all vendor URLs

## Current Status
- Project initialized with comprehensive documentation
- Memory Bank system established
- Ready for implementation planning

## Success Criteria
- Automated vendor submission processing
- 100% URL health monitoring coverage
- Seamless GitHub integration for updates
- Zero manual intervention for routine maintenance
