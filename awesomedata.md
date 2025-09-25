# Awesome Data - Project Notes

This document contains the original project notes and requirements for the Awesome Production data management system. For the complete documentation, see the [main README](README.md).

## Project Overview

I am looking to build a n8n workflow to manage data for a Github based ["Awesome List"](https://github.com/Capp3/awesome-production). I would like to have a form where a new entry and URL can be entered and then added to the list via Github integration.

Eventually I want to make a second automation that will review the websites and make sure all listings are still active and create a PR if it is not. I believe to accomplish these two goals I will need to utilize a DB of some kind in the middle. I hope to use NocoDB to allow for easy DB management, but its functionality in n8n may not be appropriate. as Postgress is in the background of n8n that may work, but it may be clumsy.

## Documentation Structure

The project has been organized into comprehensive documentation:

- **[README.md](README.md)** - Main project overview and getting started guide
- **[Workflows](workflows/)** - Detailed documentation for each workflow
  - [01-import-workflow.md](workflows/01-import-workflow.md) - One-time data import
  - [02-new-entry-workflow.md](workflows/02-new-entry-workflow.md) - New vendor submissions
  - [03-health-check-workflow.md](workflows/03-health-check-workflow.md) - URL monitoring
- **[Database](database/)** - Database schema and configuration
  - [schema.md](database/schema.md) - Complete database schema documentation

## Resources

Its imperative to use up to date information for n8n, use;
- https://context7.com/?q=n8n
- https://github.com/n8n-io/n8n/tree/master/packages/nodes-base
- https://n8n.io/integrations/

## Original Requirements

The original project requirements have been fully documented in the comprehensive documentation structure above. Key requirements include:

- **Form-based entry**: Simple web form for vendor submissions
- **Automated categorization**: LLM-powered category assignment
- **Health monitoring**: Monthly URL status checks
- **GitHub integration**: Pull request creation for all changes
- **Database management**: NocoDB/PostgreSQL for data storage

## Development Notes

This project evolved from a simple idea into a comprehensive data management system with three main workflows and detailed technical specifications. The documentation structure allows for easy maintenance and future development.

For implementation details, technical specifications, and step-by-step guides, refer to the dedicated documentation files listed above.
