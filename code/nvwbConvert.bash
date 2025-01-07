#!/bin/bash

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
echo ""
echo "Repository '$REPO_NAME' successfully converted to a basic AI Workbench project."
echo "NOTE: Minor additional tweaks may be necessary to achieve satisfactory status. "

