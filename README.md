# Acupoint
![Acupointscreenshot-08](https://github.com/banelin8814/Acupoint/assets/67232808/b683f93c-a8f5-4c8b-98ac-983141c7f5e0)

Acupoint is an AR project that projects acupuncture points on the face and hands in real-time, enabling easy acupoint location and browsing.

## Features

- Utilizes ARSCNFaceGeometry (ARKit) for facial recognition, obtaining facial topology and accurately placing acupoints on a 3D face.
- Uses VNHumanHandPoseObservation (Vision) with AVFoundation for hand recognition, identifying hand posture and features, and marking acupoint locations.
- Implements SwiftData for offline storage of frequently used acupoints.
- Implements Google Sign-In and Sign in with Apple for user authentication.
- Utilizes Firebase Firestore for storing personal acupoint information.
- Utilizes Crashlytics to proactively track, analyze, and resolve app crashes and errors.
- Includes Unit Tests to verify the accuracy of the acupuncture point localization algorithm.

## Technologies Used

- ARKit
- Vision
- AVFoundation
- SwiftData
- Google Sign-In
- Sign in with Apple
- Firebase Firestore
- Crashlytics
- Unit Tests
- MVC Architecture

## Getting Started

1. Clone the repository.
2. Install the required dependencies.
3. Run the project in Xcode.
4. Explore the AR experience and locate acupoints on your face and hands.

## Contributing

We welcome contributions to enhance the Acupoint project. If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

