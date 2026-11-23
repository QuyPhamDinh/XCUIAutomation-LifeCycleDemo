# WDIO demo app iOS UI automation

This project runs native XCTest and XCUIAutomation scenarios against the separately installed WDIO demo app (`org.wdiodemoapp`). The `LifeCycleDemo` app is a placeholder host for the Xcode scheme; it is not the app under test. The scenarios are based on the feature files in the WDIO automation project.

## Setup

1. Open `WDIODemoAutomation.xcodeproj` in Xcode.
2. Open **Xcode > Open Developer Tool > Device Hub** and start a simulator running iOS 18.2 or later. Use `xcrun simctl list devices available` in Terminal to find its device ID.
3. Install the WDIO demo app's iOS simulator build on that simulator. Replace the placeholders with the selected device ID and the path to a compatible simulator `.app` bundle:

   ```bash
   xcrun simctl install '<SIMULATOR_UDID>' '/path/to/wdiodemoapp.app'
   ```

   The simulator build must support the simulator's architecture. The app is not included in this repository.

## Run tests in Xcode

Select the `WDIODemoAutomation` scheme and your simulator. In the Test navigator, run `LoginTests`, `SignupTests`, `WarmResumeTests`, or `ColdRelaunchTests`. The tests launch the WDIO app by its bundle ID.

## Run one test from Terminal

Change to the directory containing `WDIODemoAutomation.xcodeproj`. For example, use `cd` followed by the path to your local clone, or drag the clone folder into Terminal after typing `cd `.

With the selected simulator visible in Device Hub, run the login test, replacing `<SIMULATOR_UDID>` with its device ID:

```bash
xcodebuild test \
  -project WDIODemoAutomation.xcodeproj \
  -scheme WDIODemoAutomation \
  -destination 'platform=iOS Simulator,id=<SIMULATOR_UDID>' \
  -parallel-testing-enabled NO \
  -only-testing:WDIODemoAutomationUITests/LoginTests/testSuccessfulLogin
```

To run both warm-resume scenarios, replace the final argument with `-only-testing:WDIODemoAutomationUITests/WarmResumeTests`. To run a different test, replace it with the desired target, class, and method identifier.

Xcode can create simulator clones for parallel testing. The command disables parallel testing to help keep the run on the selected simulator; check the `Test suite ... started on` line to see which device actually ran the test. Device Hub visibility can vary by Xcode configuration.

## Coverage and diagnostics

The tests cover login, signup, Home/resume, cold relaunch, and returning through the iOS App Switcher. Android-only scenarios remain in the WDIO suite. The feature files describe behavior; XCTest does not execute Gherkin directly.

The App Switcher test uses a system gesture and an app-card accessibility label; it may need adjustment for other device sizes, iOS versions, or app builds. Failure attachments include a screenshot and UI hierarchy. The credentials are demo values; do not use production secrets.
