#!/bin/bash

# Ensure the GitHub token is available
if [ -z "$GH_TOKEN" ]; then
  echo "Error: GH_TOKEN is not set."
  exit 1
fi

# Ensure the GitHub event data is available
if [ ! -f "$GITHUB_EVENT_PATH" ]; then
  echo "Error: GITHUB_EVENT_PATH is not set or file does not exist."
  exit 1
fi

# Extract PR number and repository name from the GitHub event data
PR_NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")
REPO_NAME=$(jq --raw-output .repository.full_name "$GITHUB_EVENT_PATH")

# Comment body
COMMENT_BODY="This is an automated comment."

# Create the PR comment
curl -s -H "Authorization: token $GH_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     --data "{\"body\": \"$COMMENT_BODY\"}" \
     "https://api.github.com/repos/$REPO_NAME/issues/$PR_NUMBER/comments" || {
       echo "Error: Failed to create PR comment."
       exit 1
     }

echo "Comment created successfully."
