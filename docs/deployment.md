# Deployment Guide - GitHub Pages

This guide explains how the documentation is automatically deployed to GitHub Pages.

## Automatic Deployment

The documentation is automatically deployed to GitHub Pages whenever changes are pushed to the `main` branch.

### GitHub Actions Workflow

The deployment is handled by the `.github/workflows/docs.yml` workflow which:

1. **Triggers**: On push to `main` branch and pull requests
2. **Builds**: Documentation using mkdocs
3. **Deploys**: To GitHub Pages automatically

### Workflow Steps

1. **Checkout**: Gets the latest code
2. **Setup Python**: Installs Python 3.12
3. **Install Dependencies**: Installs mkdocs and required packages
4. **Build Documentation**: Runs `mkdocs build`
5. **Upload Artifact**: Uploads the built site
6. **Deploy**: Deploys to GitHub Pages (main branch only)

## Manual Deployment

### Local Build

To build the documentation locally:

```bash
# Using the build script
./scripts/build-docs.sh

# Or manually
source venv/bin/activate
pip install -r requirements.txt
mkdocs build
```

### Local Preview

To preview the documentation locally:

```bash
source venv/bin/activate
mkdocs serve
```

The documentation will be available at `http://localhost:8000`

## Configuration

### Site URL

The documentation is configured to deploy to:

- **URL**: https://capp3.github.io/n8n-awesome-system
- **Repository**: n8n-awesome-system
- **Branch**: main

### Dependencies

All Python dependencies are specified in `requirements.txt`:

- mkdocs==1.6.1
- mkdocs-material==9.6.20
- pymdown-extensions==10.16.1

## Troubleshooting

### Build Failures

If the GitHub Actions build fails:

1. **Check Dependencies**: Ensure all required packages are in `requirements.txt`
2. **Test Locally**: Run `./scripts/build-docs.sh` to test locally
3. **Check mkdocs.yml**: Verify the configuration is valid
4. **Check File Paths**: Ensure all referenced files exist

### Common Issues

1. **Missing Files**: Some files referenced in navigation may not exist yet
2. **Broken Links**: Internal links may point to non-existent files
3. **Mermaid Diagrams**: Ensure diagrams are properly formatted

### GitHub Pages Setup

To enable GitHub Pages:

1. Go to repository Settings
2. Navigate to Pages section
3. Select "GitHub Actions" as source
4. The workflow will automatically deploy

## Customization

### Adding New Pages

1. Add the markdown file to the appropriate directory
2. Update `mkdocs.yml` navigation
3. Push to main branch
4. Documentation will be automatically deployed

### Changing Theme

To change the theme:

1. Update `mkdocs.yml` theme configuration
2. Update `requirements.txt` if needed
3. Test locally with `mkdocs serve`
4. Push changes to main branch

### Adding Plugins

To add new mkdocs plugins:

1. Add to `requirements.txt`
2. Update `mkdocs.yml` plugins section
3. Test locally
4. Push to main branch

## Monitoring

### Build Status

Check the Actions tab in GitHub to monitor build status:

- Green checkmark: Build successful
- Red X: Build failed
- Yellow circle: Build in progress

### Deployment Status

The deployment status is shown in the Actions tab:

- "Deploy to GitHub Pages" step shows deployment progress
- Check the Pages section in repository settings for live status

## Security

### Permissions

The workflow uses minimal required permissions:

- `contents: read` - Read repository contents
- `pages: write` - Deploy to GitHub Pages
- `id-token: write` - Authenticate with GitHub

### Secrets

No secrets are required for this deployment as it only builds and deploys documentation.

## Support

For deployment issues:

1. Check the Actions tab for error details
2. Test locally with the build script
3. Verify all dependencies are correct
4. Check GitHub Pages settings in repository
