# WDIO demo app iOS UI automation

This project runs XCTest and XCUIAutomation against the separately installed WDIO demo app (`org.wdiodemoapp`). The `LifeCycleDemo` app is a placeholder host, not the app under test.

## Setup

1. Open `WDIODemoAutomation.xcodeproj` in Xcode and choose an available iOS simulator (iOS 18.2 or later).
2. Download the iOS simulator ZIP from [WDIO native demo app releases](https://github.com/webdriverio/native-demo-app/releases). Under a release's **Assets**, choose the file named `ios.simulator.wdio.native.app.*.zip` (not the Android APK or source code). The app is not included in this repository. Release versions can change the UI or selectors used by these tests.
3. Extract the downloaded ZIP and locate the `.app` bundle. Replace the ZIP path with the file you downloaded:

   ```bash
   mkdir -p ~/Downloads/wdio-simulator
   ditto -x -k ~/Downloads/ios.simulator.wdio.native.app.v2.2.0.zip ~/Downloads/wdio-simulator
   find ~/Downloads/wdio-simulator -type d -name '*.app' -print
   ```

4. Choose a simulator ID from the first command, then boot it and install the extracted app using the path printed above:

   ```bash
   xcrun simctl list devices available
   xcrun simctl boot '<SIMULATOR_UDID>'
   xcrun simctl bootstatus '<SIMULATOR_UDID>' -b
   xcrun simctl install '<SIMULATOR_UDID>' '/path/to/extracted/app.app'
   xcrun simctl get_app_container '<SIMULATOR_UDID>' org.wdiodemoapp app
   ```

   Skip the boot command if the simulator is already running. The last command verifies that the expected bundle ID is installed. Install the app on every simulator used for testing.

## Test plans and runner

Select the `WDIODemoAutomation` scheme and the All, Smoke, or Lifecycle test plan in Xcode. All contains the UI suite, Smoke contains login and signup, and Lifecycle contains cold relaunch and warm resume tests.

From the repository root, run:

```bash
make test       # All
make smoke      # Login and signup
make lifecycle  # Lifecycle scenarios
```

The default destination is iPhone 16 Pro on iOS 18.2. Override it with an installed simulator's name and OS version or its UDID:

```bash
make lifecycle DESTINATION='platform=iOS Simulator,name=iPhone 16 Pro,OS=18.2'
make smoke DESTINATION='platform=iOS Simulator,id=<SIMULATOR_UDID>'
```

Run a device matrix sequentially by invoking the runner for each prepared simulator. For example, replace the names and versions below with available devices on your machine:

```bash
for destination in \
  'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.2' \
  'platform=iOS Simulator,name=iPhone 16,OS=18.2'; do
  make lifecycle DESTINATION="$destination" || exit 1
done
```

Each run writes a uniquely named `.xcresult` bundle under `build/test-results`, including on test failure. Open it in Xcode or use `xcrun xcresulttool`. A CI job can archive that directory; a hosted runner must first obtain and install the separately distributed app.

Parallel testing defaults to `NO` so the run stays on the prepared simulator. To experiment with at most two parallel workers, run `make test PARALLEL=YES` after confirming the WDIO app is available on Xcode's simulator clones and that the tests remain isolated. Override the limit with `WORKERS=3` if needed. Xcode can schedule tests on clones; inspect the test log for the actual device. The App Switcher test uses normalized screen coordinates and an app-card accessibility label, so validate it across the selected devices and OS versions.

## GitHub Actions

The iOS UI tests workflow runs on pushes, pull requests, and manual dispatch from the Actions tab. It selects an available iPhone simulator on GitHub's Xcode 27 runner, downloads and installs the pinned WDIO v2.2.0 simulator release, and runs the All plan serially. The runner image and available simulator versions can change.

After a run, download the `ios-ui-test-results` artifact from the workflow summary and open its `.xcresult` bundle in Xcode. The artifact is uploaded even when tests fail, if a result bundle was produced. The App Switcher test has shown intermittent text-entry failures.

## Run a specific test

Run a single method by specifying its target, class, and method:

```bash
xcodebuild test \
  -project WDIODemoAutomation.xcodeproj \
  -scheme WDIODemoAutomation \
  -testPlan All \
  -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>' \
  -parallel-testing-enabled NO \
  -only-testing:WDIODemoAutomationUITests/WarmResumeTests/testFormsStateSurvivesAppSwitcher
```

To run a whole class, omit the method: `-only-testing:WDIODemoAutomationUITests/WarmResumeTests`. The selected simulator must have the WDIO demo app installed.

Find the values needed for the command with:

- Simulator ID: `xcrun simctl list devices available`
- Scheme and targets: `xcodebuild -list -project WDIODemoAutomation.xcodeproj`
- Test plans: `xcodebuild -showTestPlans -project WDIODemoAutomation.xcodeproj -scheme WDIODemoAutomation`
- Test classes and methods: use Xcode's Test navigator or inspect `WDIODemoAutomationUITests/Tests`.

The tests cover login, signup, Home/resume, cold relaunch, and returning through the iOS App Switcher. Failure attachments include a screenshot and UI hierarchy. The credentials are demo values; do not use production secrets.
