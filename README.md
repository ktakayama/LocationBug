# Location Bug

Fixed this bug on iOS 17 beta 6 :tada:

## Problem Description:

When using Xcode15-beta4 and iOS17beta3, there is an issue that only occurs on a physical device (in this case, iPhone 11 Pro was used for testing) and not in the simulator. When EKEvent holds the following EKStructuredLocation values and EKEventViewController is displayed, it appears briefly and then the screen closes instantly.

```swift
let structureLocation = EKStructuredLocation(title: "Apple Store, Union Square 300 Post St, San Francisco, CA  94108, United States")
structureLocation.geoLocation = CLLocation(latitude: 37.78874470, longitude: -122.40715290)
structureLocation.radius = 70.587316
```

## Steps to Reproduce:

1. Run this project on a physical device
2. Tap the button labeled "broken event"
3. Notice that the EKEventViewController displays briefly before instantly closing

Additionally, a button labelled "normal event" in the same project does not reproduce the issue and displays the EKEventViewController as expected.

## Expected Results:

When the EKEventViewController is opened, it should remain open, allowing the user to interact with the event details.

## Actual Results:

The EKEventViewController displays briefly and then closes instantly.

## Screen Recording:

https://github.com/ktakayama/LocationBug/assets/42468/a0197373-becc-4d91-844b-7ced513100e4

