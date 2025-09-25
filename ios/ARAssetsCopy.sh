#!/bin/bash

# Script to copy AR assets to iOS bundle
echo "Copying AR assets to iOS bundle..."

# Create directories if they don't exist
mkdir -p "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ar_targets"
mkdir -p "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ar_videos"
mkdir -p "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ar_config"

# Copy AR targets
if [ -d "$PROJECT_DIR/../../assets/ar_targets" ]; then
    cp -r "$PROJECT_DIR/../../assets/ar_targets"/* "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ar_targets/"
    echo "AR targets copied successfully"
else
    echo "AR targets directory not found"
fi

# Copy AR videos
if [ -d "$PROJECT_DIR/../../assets/ar_videos" ]; then
    cp -r "$PROJECT_DIR/../../assets/ar_videos"/* "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ar_videos/"
    echo "AR videos copied successfully"
else
    echo "AR videos directory not found"
fi

# Copy AR config
if [ -d "$PROJECT_DIR/../../assets/ar_config" ]; then
    cp -r "$PROJECT_DIR/../../assets/ar_config"/* "$TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/ar_config/"
    echo "AR config copied successfully"
else
    echo "AR config directory not found"
fi

echo "AR assets copy completed!"

