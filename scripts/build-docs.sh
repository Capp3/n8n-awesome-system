#!/bin/bash

# Build Documentation Script
# This script builds the mkdocs documentation locally

set -e

echo "🔧 Building documentation..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🚀 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Build documentation
echo "🏗️ Building documentation..."
mkdocs build

echo "✅ Documentation built successfully!"
echo "📁 Output directory: ./site"
echo "🌐 To preview locally, run: mkdocs serve"
