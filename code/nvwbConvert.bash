#!/bin/bash

# # Function to display usage
# usage() {
#     echo "Usage: $0 <git-repo> <project-folder>"
#     exit 1
# }

# # Check for correct arguments
# if [ "$#" -ne 2 ]; then
#     usage
# fi

# GIT_REPO="$1"
# PROJECT_FOLDER="$2"

# Function to display usage
usage() {
    echo ""
    echo "TARGET Repo refers to the Git repo to be converted to a NVWB project. "
    echo "TEMPLATE Repo refers to the existing NVWB project to be used as reference. "
    echo ""
    echo "Please provide the following information:"
    echo ""
}

# Display usage information
usage

# Prompt for TARGET repository URL
read -p "Enter the TARGET repository URL: " GIT_REPO
git clone $GIT_REPO

# Prompt for project folder name
echo ""
read -p "Enter the TEMPLATE repository URL: " TEMPLATE_REPO
git clone $TEMPLATE_REPO

# Validate input
if [ -z "$GIT_REPO" ] || [ -z "$TEMPLATE_REPO" ]; then
    echo "Error: Both TARGET repository URL and TEMPLATE repository URL are required."
    exit 1
fi

# Display the provided information
echo ""
echo "TARGET Repository: $GIT_REPO"
echo "TEMPLATE Repository: $TEMPLATE_REPO"
echo ""

# Extract the name of the git repository (assumes last part of the path is the repo name)
REPO_NAME=${GIT_REPO##*/}
REPO_NAME=${REPO_NAME%.git}

echo ""
echo "TARGET repo name: $REPO_NAME"

PROJECT_FOLDER=${TEMPLATE_REPO##*/}
PROJECT_FOLDER=${PROJECT_FOLDER%.git}

echo "TEMPLATE repo name: $PROJECT_FOLDER"
echo ""

# Ensure the specified git repo is in the current directory
if [ ! -d "$REPO_NAME/.git" ]; then
    echo "Error: $REPO_NAME is not a valid git repository."
    exit 1
fi

# Ensure the specified project folder exists
if [ ! -d "$PROJECT_FOLDER" ]; then
    echo "Error: $PROJECT_FOLDER directory not found."
    exit 1
fi

# Step 1: Copy required files and folders from project folder to git repo
FILES_TO_COPY=(
    ".project"
    "variables.env"
    "requirements.txt"
    "preBuild.bash"
    "postBuild.bash"
    "apt.txt"
)

OVERWRITTEN_FILES=()
SKIPPED_FILES=()

for FILE in "${FILES_TO_COPY[@]}"; do
    if [ -e "$PROJECT_FOLDER/$FILE" ]; then
        if [ -e "$REPO_NAME/$FILE" ]; then
            echo "Warning: $FILE already exists in $REPO_NAME. Overwriting..."
            OVERWRITTEN_FILES+=("$FILE")
        fi
        cp -r "$PROJECT_FOLDER/$FILE" "$REPO_NAME/"
    else
        echo "Warning: $FILE not found in $PROJECT_FOLDER. Skipping..."
        SKIPPED_FILES+=("$FILE")
    fi
done

# Print the OVERWRITTEN_FILES list for debugging
echo "Overwritten files: ${OVERWRITTEN_FILES[*]}"


# # Step 2: Edit spec.yaml file on TARGET
SPEC_FILE="$REPO_NAME/.project/spec.yaml"
python3 modify_spec.py $SPEC_FILE $REPO_NAME
# SPEC_FILE_STATUS=""
# if [ -f "$SPEC_FILE" ]; then
#     echo "Editing $SPEC_FILE..."
#     # Update fields in the YAML file using yq
#     if command -v yq > /dev/null 2>&1; then
#         yq eval ".meta.name = \"$REPO_NAME\"" -i "$SPEC_FILE"
#         yq eval ".meta.image = \"project-$REPO_NAME\"" -i "$SPEC_FILE"
#         SPEC_FILE_STATUS="spec.yaml updated"
#     else
#         # Fallback to sed for editing YAML if yq is not installed
#         if command -v gsed > /dev/null 2>&1; then
#             SED="gsed"
#         else
#             SED="sed"
#         fi

#         # Update the "name" field under "meta"
#         $SED -i '' "/^meta:/,/^[^ ]/ s/^\\s*name:.*/  name: $REPO_NAME/" "$SPEC_FILE"
        
#         # Update the "image" field under "meta"
#         $SED -i '' "/^meta:/,/^[^ ]/ s/^\\s*image:.*/  image: project-$REPO_NAME/" "$SPEC_FILE"

#         SPEC_FILE_STATUS="spec.yaml updated"
#     fi
# else
#     echo "Error: spec.yaml not found in .project. Skipping YAML edits."
#     SPEC_FILE_STATUS="spec.yaml missing"
# fi


# Step 3: Stage and commit changes
cd "$REPO_NAME" || exit 1
git add .

COMMIT_MESSAGE="converting to AI Workbench project by adding .project folder and environment configuration files"
if [ ${#OVERWRITTEN_FILES[@]} -gt 0 ]; then
    COMMIT_MESSAGE+="; overwritten files: ${OVERWRITTEN_FILES[*]}"
else
    COMMIT_MESSAGE+="; no files were overwritten"
fi
if [ ${#SKIPPED_FILES[@]} -gt 0 ]; then
    COMMIT_MESSAGE+="; skipped files: ${SKIPPED_FILES[*]}"
fi
if [ -n "$SPEC_FILE_STATUS" ]; then
    COMMIT_MESSAGE+="; $SPEC_FILE_STATUS"
fi
git commit -am "$COMMIT_MESSAGE"

# Completion message
echo "Repository '$REPO_NAME' successfully converted to a baseline functional AI Workbench project."

