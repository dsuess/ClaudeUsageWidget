project := "ClaudeUsageWidget.xcodeproj"
app_name := "ClaudeUsageWidget"
extension_name := "ClaudeUsageWidgetExtension"
config := "Debug"
install_path := "/Applications/ClaudeUsageWidget.app"

# List available recipes
default:
    @just --list

# Build the app and widget extension
build:
    xcodebuild -project {{project}} -scheme {{app_name}} -configuration {{config}} \
        CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=YES DEVELOPMENT_TEAM="" build

# Kill running instances of the app and widget
kill:
    -killall {{app_name}} 2>/dev/null
    -killall {{extension_name}} 2>/dev/null

# Rebuild: kill running instances, then build fresh
rebuild: kill build

# Install built app to /Applications and register widget extension
install: build
    ditto "$(xcodebuild -project {{project}} -scheme {{app_name}} -configuration {{config}} -showBuildSettings 2>/dev/null | grep ' BUILT_PRODUCTS_DIR' | awk '{print $3}')/{{app_name}}.app" {{install_path}}
    pluginkit -a {{install_path}}

# Build, install, and launch
run: install
    open {{install_path}}

# Clean build artifacts
clean:
    xcodebuild -project {{project}} -scheme {{app_name}} -configuration {{config}} clean
    rm -rf ~/Library/Developer/Xcode/DerivedData/{{app_name}}-*
