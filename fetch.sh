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

echo "Pulling from destination repository with smart conflict resolution..."

# First, fetch the remote changes
git fetch dest master || { echo "Failed to fetch from destination"; exit 1; }

# Create a backup branch just in case
BACKUP_BRANCH="backup-$TAG"
git branch $BACKUP_BRANCH || { echo "Failed to create backup branch"; exit 1; }
echo "Created backup branch: $BACKUP_BRANCH"

# Strategy 1: Try merge with "ours" strategy (keeps our changes in conflicts)
if git merge dest/master -X ours --no-commit; then
    echo "Merge successful with 'ours' strategy (local changes preserved)"
    
    # Check if there were any conflicts that were auto-resolved
    if git diff --name-only --diff-filter=U | grep -q .; then
        echo "Note: Some conflicts were automatically resolved in favor of local changes"
    fi
    
    # Commit the merge
    git commit -m "Merge dest/master with preference for local changes" || {
        echo "Failed to commit merge"; 
        exit 1;
    }
else
    # If the merge failed even with the strategy
    echo "Merge with 'ours' strategy failed. Aborting merge."
    git merge --abort
    
    # Try a different approach: cherry-pick changes
    echo "Attempting alternative approach: identifying and applying non-conflicting changes..."
    
    # Find the common ancestor
    COMMON_ANCESTOR=$(git merge-base HEAD dest/master)
    
    # Create a temporary branch for analysis
    TEMP_BRANCH="temp-analysis"
    git branch -D $TEMP_BRANCH 2>/dev/null || true
    git checkout -b $TEMP_BRANCH || { 
        echo "Failed to create temporary branch"; 
        git checkout $TAG;
        exit 1; 
    }
    
    # Get list of files changed in dest/master since common ancestor
    CHANGED_FILES=$(git diff --name-only $COMMON_ANCESTOR dest/master)
    
    # Go back to our branch
    git checkout $TAG || { echo "Failed to return to original branch"; exit 1; }
    
    # For each changed file, try to apply changes
    for FILE in $CHANGED_FILES; do
        if [ -f "$FILE" ]; then
            # If we have the file too, check if we modified it
            if git diff --quiet $COMMON_ANCESTOR -- "$FILE"; then
                # We didn't modify it, safe to take their version
                echo "Taking remote version of $FILE (not modified locally)"
                git checkout dest/master -- "$FILE" || echo "Warning: Failed to update $FILE"
            else
                # Both sides modified the file
                echo "Both sides modified $FILE - keeping local version"
                # You could use git merge-file here for more sophisticated merging
            fi
        else
            # File doesn't exist in our branch, safe to add
            echo "Adding new file from remote: $FILE"
            git checkout dest/master -- "$FILE" || echo "Warning: Failed to add $FILE"
        fi
    done
    
    # Commit these changes
    git add . || { echo "Failed to stage changes"; exit 1; }
    git commit -m "Applied non-conflicting changes from dest/master" || {
        echo "No changes to commit or commit failed";
    }
fi

echo "Merge process completed. Your changes have been preserved where possible."
echo "A backup of your original branch is available as: $BACKUP_BRANCH"

echo "Success! Branch $TAG created and updated."
echo "To create a PR, run: gh pr create --repo andrewhertog/codex --base master"

# Commented out PR creation
# gh pr create --repo andrewhertog/codex --base master
