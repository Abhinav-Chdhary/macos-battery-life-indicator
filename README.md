# macOS Battery Life Indicator

A lightweight macOS menu bar application that displays estimated remaining battery life and detailed battery information.

## Features

- Real-time battery percentage display in the menu bar
- Estimated time remaining when on battery power
- Charging status indicator
- Detailed battery information in dropdown menu:
  - Current battery level
  - Charging status
  - Time remaining
  - Current/Max capacity (mAh)
  - Battery health percentage
- Updates every 30 seconds
- Minimal system resource usage

## Requirements

- macOS 11.0 (Big Sur) or later
- Xcode 15.0 or later

## Quick Start

### Clone the Repository

```bash
git clone <your-repo-url>
cd macos-battery-life-indicator
```

### Build and Install

#### Option 1: Using Xcode (Recommended)

1. **Open the project:**
   ```bash
   cd BatteryIndicator
   open BatteryIndicator.xcodeproj
   ```

2. **Build for release:**
   - In Xcode menu: `Product` → `Build` (or press `Cmd + B`)
   - For testing: Press `Cmd + R` to build and run

3. **Archive the app (for permanent installation):**
   - In Xcode menu: `Product` → `Archive`
   - Wait for the build to complete

#### Option 2: Using Command Line

Build the release version from terminal:

```bash
cd BatteryIndicator
xcodebuild -project BatteryIndicator.xcodeproj -scheme BatteryIndicator -configuration Release build
```

**Note:** Xcode builds apps in the DerivedData folder, not in the project directory.

## Installation for Permanent Use

### Step 1: Locate the Built Application

After building, find the app location:

```bash
find ~/Library/Developer/Xcode/DerivedData -name "BatteryIndicator.app" -path "*/Release/*" 2>/dev/null
```

This will show the path, something like:
```
/Users/[username]/Library/Developer/Xcode/DerivedData/BatteryIndicator-[hash]/Build/Products/Release/BatteryIndicator.app
```

### Step 2: Copy to Applications Folder

**Using Terminal (replace [path] with the actual path from above):**
```bash
cp -r [path]/BatteryIndicator.app /Applications/
```

**Example:**
```bash
cp -r ~/Library/Developer/Xcode/DerivedData/BatteryIndicator-*/Build/Products/Release/BatteryIndicator.app /Applications/
```

**Using Finder:**
1. Press `Cmd + Shift + G` in Finder
2. Paste the path from the find command
3. Drag `BatteryIndicator.app` to your `/Applications` folder

### Step 3: Launch the Application

**Option 1:** Double-click `BatteryIndicator.app` from Applications folder

**Option 2:** Use Spotlight:
- Press `Cmd + Space`
- Type "BatteryIndicator"
- Press Enter

The battery indicator (🔋) should now appear in your menu bar!

### Step 4: Enable Auto-Start on Login (Optional)

To make BatteryIndicator start automatically when you log in:

**macOS Ventura and later:**
1. Open **System Settings**
2. Go to **General** → **Login Items**
3. Click the **+** button under "Open at Login"
4. Navigate to Applications and select **BatteryIndicator.app**
5. Click **Add**

**macOS Monterey and earlier:**
1. Open **System Preferences**
2. Go to **Users & Groups**
3. Click on your username
4. Click the **Login Items** tab
5. Click the **+** button
6. Navigate to Applications and select **BatteryIndicator.app**
7. Click **Add**

Now BatteryIndicator will launch automatically every time you start your Mac!

## Managing the Application

### Running the App
- **Launch:** Open from Applications folder or use Spotlight
- **Check if running:** Look for 🔋 icon in menu bar, or check Activity Monitor

### Quitting the App
- Click the battery icon (🔋) in the menu bar
- Select **Quit** from the dropdown menu

### Updating the App
1. Pull the latest changes from the repository
2. Rebuild using Xcode or command line
3. Replace the existing app in `/Applications/` with the new build

### Uninstalling
1. Quit the application (click menu bar icon → Quit)
2. Remove from Login Items (System Settings → General → Login Items)
3. Delete `/Applications/BatteryIndicator.app`

## Usage

Once running, the application will display in your menu bar showing:
- **Battery percentage:** 🔋 85%
- **Time remaining when on battery:** 🔋 85% (4h 32m)
- **Charging indicator:** 🔋 85% ⚡
- **Plugged in:** 🔋 100% 🔌

### Viewing Detailed Information

Click on the menu bar icon to view detailed battery information:
- **Battery level:** Current percentage
- **Current status:** Charging, Plugged In, or On Battery
- **Estimated time remaining:** Hours and minutes left on battery
- **Battery health:** Overall battery health percentage

### Display Updates
- The battery information updates automatically every 30 seconds
- The menu bar icon always shows current battery status

### Quitting
Click the battery icon (🔋) in the menu bar and select "Quit"

## How It Works

The application uses macOS's IOKit framework to access battery information through the power source APIs. It:
1. Queries the system for current power source information
2. Extracts battery metrics (capacity, charge state, time estimates)
3. Updates the menu bar display every 30 seconds
4. Runs as a menu bar-only application (LSUIElement = true)

## Project Structure

```
macos-battery-life-indicator/
├── BatteryIndicator/
│   ├── BatteryIndicator/
│   │   ├── main.swift              # App entry point
│   │   ├── AppDelegate.swift       # Main app logic and battery monitoring
│   │   └── Info.plist              # App configuration
│   └── BatteryIndicator.xcodeproj/ # Xcode project file
├── README.md
├── LICENSE
└── .gitignore
```

## Troubleshooting

**Application doesn't show battery information:**
- Ensure you're running on a Mac with a battery (MacBook, MacBook Air, MacBook Pro)
- Desktop Macs without batteries won't display battery information
- Check if the IOKit framework has proper permissions

**Menu bar icon not appearing:**
- Verify the app is running (search for "BatteryIndicator" in Activity Monitor)
- Quit and relaunch the application
- If building from Xcode, make sure both `main.swift` and `AppDelegate.swift` are included in the build
- Check that `LSUIElement` is set to `true` in Info.plist (this makes it a menu bar-only app)

**Build errors in Xcode:**
- Clean the build folder: `Product` → `Clean Build Folder` (Cmd + Shift + K)
- Close and reopen Xcode
- Make sure you're using Xcode 15.0 or later
- Verify that `main.swift` is included in the project's compile sources

**Console output not showing:**
- This is normal for menu bar apps with `LSUIElement = true`
- The app runs in the background without a dock icon
- Check Activity Monitor to confirm the app is running

**Inaccurate time estimates:**
- macOS provides time estimates based on current usage patterns
- Estimates may vary significantly as system load changes
- Battery estimates become more accurate over time as the system learns usage patterns

**App won't start automatically:**
- Verify the app is added to Login Items in System Settings
- Make sure the app path is `/Applications/BatteryIndicator.app`
- Check that the app hasn't been moved or renamed

## License

See LICENSE file for details.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.
