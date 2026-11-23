# WDIO demo app UI tests

These native XCTest/XCUIAutomation tests exercise the iOS scenarios from the
`appium-wdio/tests/features` files. They target the separately installed WDIO
demo app (`org.wdiodemoapp`), not the LifeCycleDemo app.

## Setup and execution

1. Install the WDIO demo app simulator build on the simulator selected in Xcode,
   for example using `xcrun simctl install booted /absolute/path/to/wdiodemoapp.app`.
   A simulator build and a matching simulator architecture are required.
2. Select an iOS simulator running iOS 18.2 or later, compatible with the
   LifeCycleDemo scheme's deployment target.
3. Run `LoginTests`, `SignupTests`, `WarmResumeTests`, and `ColdRelaunchTests`
   from Xcode's test navigator. The scheme's own app remains the host project;
   the tests launch the installed WDIO app by bundle ID.

## Run one test and watch it in Device Hub

1. In Xcode, choose **Xcode > Open Developer Tool > Device Hub**.
2. Expand the sidebar, select **Simulators**, and choose the iPhone 16 Pro
   running iOS 18.2. Keep its screen visible during the run.
3. In Terminal, move to the directory containing `LifeCycleDemo.xcodeproj`:

   ```bash
   cd /Users/phamdinhquy/Documents/mobile-automation/LifeCycleDemo
   ```

4. Run a single test. This example selects the simulator used during initial
   verification and disables parallel testing to avoid running on a clone:

   ```bash
   xcodebuild test \
     -project LifeCycleDemo.xcodeproj \
     -scheme LifeCycleDemo \
     -destination 'platform=iOS Simulator,id=237FF669-E067-4DDB-84E0-FD1E62486389' \
     -parallel-testing-enabled NO \
     -only-testing:LifeCycleDemoUITests/LoginTests/testSuccessfulLogin
   ```

Simulator IDs are specific to the local machine. Use `xcrun simctl list devices
available` to find another ID and replace the destination value. Make sure the
WDIO demo app is installed on the selected simulator.

To run both warm-resume scenarios, replace the last argument with
`-only-testing:LifeCycleDemoUITests/WarmResumeTests`. In the Terminal output,
check the `Test suite ... started on` line to see which device ran the test.
If it says `Clone 1 of iPhone 16 Pro`, Xcode ran a clone rather than the original
simulator shown in Device Hub; confirm that parallel testing is disabled.
Device Hub visibility with this command has not yet been verified.

The native tests cover login, signup, Home/resume, cold relaunch, and returning
through the iOS App Switcher. Android-only scenarios remain in the WDIO suite.
The feature files describe behavior; XCTest does not execute Gherkin directly.

The app switcher uses a system gesture and an app-card accessibility label and
may need adjustment for other device sizes, OS versions, or app builds. The
failure attachment contains a screenshot and UI hierarchy. Tests use the demo
credentials already present in the WDIO project; do not use production secrets.
