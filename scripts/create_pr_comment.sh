#!/bin/bash

# Ensure the GitHub token is available
if [ -z "$GH_TOKEN" ]; then
  echo "Error: GH_TOKEN is not set."
  exit 1
fi

# Ensure the required environment variables are available
if [ -z "$PR_NUMBER" ] || [ -z "$REPO_NAME" ]; then
  echo "Error: PR_NUMBER or REPO_NAME is not set."
  exit 1
fi

# Comment body
COMMENT_BODY="This is an automated comment."

# Create the PR comment
response=$(curl -s -H "Authorization: token $GH_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     --data "{\"body\": \"$COMMENT_BODY\"}" \
     "https://api.github.com/repos/$REPO_NAME/issues/$PR_NUMBER/comments")

if echo "$response" | grep -q '"id":'; then
  echo "Comment created successfully."
else
  echo "Error: Failed to create PR comment. Response: $response"
  exit 1
fi