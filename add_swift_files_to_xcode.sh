#!/bin/bash

echo "Adding Swift files to Xcode project..."

# Path to the Xcode project
PROJECT_PATH="/Users/lucaspires/Documents/Flutter projects/rua404/ios/Runner.xcodeproj"
RUNNER_PATH="/Users/lucaspires/Documents/Flutter projects/rua404/ios/Runner"

# Check if Xcode project exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: Xcode project not found at $PROJECT_PATH"
    exit 1
fi

echo "✅ Xcode project found"

# Check if Swift files exist
if [ ! -f "$RUNNER_PATH/ARViewController.swift" ]; then
    echo "Error: ARViewController.swift not found"
    exit 1
fi

if [ ! -f "$RUNNER_PATH/ARPlugin.swift" ]; then
    echo "Error: ARPlugin.swift not found"
    exit 1
fi

echo "✅ Swift files found"

echo ""
echo "📋 MANUAL STEPS REQUIRED:"
echo ""
echo "1. Open Xcode:"
echo "   open '$PROJECT_PATH'"
echo ""
echo "2. In Xcode:"
echo "   - Right-click on 'Runner' in the project navigator"
echo "   - Select 'Add Files to \"Runner\"'"
echo "   - Navigate to: $RUNNER_PATH"
echo "   - Select: ARViewController.swift and ARPlugin.swift"
echo "   - Make sure 'Add to target: Runner' is checked"
echo "   - Click 'Add'"
echo ""
echo "3. Verify in Xcode:"
echo "   - Both Swift files should appear under 'Runner'"
echo "   - Build the project (Cmd+B)"
echo ""
echo "4. If build fails:"
echo "   - Check that both files are added to the 'Runner' target"
echo "   - Clean build folder (Cmd+Shift+K)"
echo "   - Build again (Cmd+B)"
echo ""

echo "🚀 After adding files to Xcode, you can run:"
echo "   flutter run"

