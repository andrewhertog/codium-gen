#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to handle errors
handle_error() {
  echo "Error occurred at line $1"
  exit 1
}

# Set up trap to catch errors
trap 'handle_error $LINENO' ERR

echo "Creating vscodium directory..."
mkdir -p vscodium || { echo "Failed to create directory"; exit 1; }

echo "Changing to vscodium directory..."
cd vscodium || { echo "Failed to change directory"; exit 1; }

echo "Initializing git repository..."
git init -q || { echo "Failed to initialize git repository"; exit 1; }

echo "Adding VSCodium remote..."
git remote add origin https://github.com/VSCodium/vscodium.git || { 
  # If remote already exists, update it instead
  git remote set-url origin https://github.com/VSCodium/vscodium.git || {
    echo "Failed to add or update origin remote"; 
    exit 1; 
  }
}

echo "Adding destination remote..."
git remote add dest https://github.com/andrewhertog/codex.git || {
  # If remote already exists, update it instead
  git remote set-url dest https://github.com/andrewhertog/codex.git || {
    echo "Failed to add or update dest remote"; 
    exit 1; 
  }
}

echo "Fetching from origin..."
git fetch origin || { echo "Failed to fetch from origin"; exit 1; }

echo "Checking out version 1.97.0.25037..."
git checkout 1.97.0.25037 || { echo "Failed to checkout version"; exit 1; }

echo "Creating new branch..."
TAG=update/$(date +%Y-%m-%d-%H-%M-%S)
git switch -c $TAG || { echo "Failed to create and switch to new branch"; exit 1; }

echo "Pulling from destination repository..."
if ! git pull dest master --allow-unrelated-histories -X theirs; then
  echo "Failed to pull from destination repository"
  echo "You may need to resolve conflicts manually"
  exit 1
fi

echo "Success! Branch $TAG created and updated."
echo "To create a PR, run: gh pr create --repo andrewhertog/codex --base master"

# Commented out PR creation
# gh pr create --repo andrewhertog/codex --base master
