# WDIO demo app iOS UI automation

This project runs XCTest and XCUIAutomation against the separately installed WDIO demo app (`org.wdiodemoapp`). The `LifeCycleDemo` app is a placeholder host, not the app under test.

## Setup

1. Open `WDIODemoAutomation.xcodeproj` in Xcode and choose an available iOS simulator (iOS 18.2 or later).
2. Boot the simulator and install a compatible WDIO demo simulator build. The app is not included in this repository.

   ```bash
   xcrun simctl list devices available
   xcrun simctl boot '<SIMULATOR_UDID>'
   xcrun simctl bootstatus '<SIMULATOR_UDID>' -b
   xcrun simctl install '<SIMULATOR_UDID>' '/path/to/wdiodemoapp.app'
   ```

   Skip the boot command if the simulator is already running. Install the app on every simulator used for testing.

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

Parallel testing defaults to `NO` so the run stays on the prepared simulator. To experiment, run `make test PARALLEL=YES` after confirming the WDIO app is available on Xcode's simulator clones and that the tests remain isolated. Xcode can schedule tests on clones; inspect the test log for the actual device. The App Switcher test uses normalized screen coordinates and an app-card accessibility label, so validate it across the selected devices and OS versions.

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
