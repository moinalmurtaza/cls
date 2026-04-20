# 📱 Smart Attendance & Student Management System

A modern, AI-integrated mobile application built with **Flutter** to streamline classroom attendance and student records. The system utilizes face recognition concepts and a robust **Firebase** backend to automate attendance and maintain secure student profiles.

## ✨ Features

### 👨‍🎓 Student Module
- **Biometric Registration**: Securely register using **Firebase Authentication**. Students capture their face data using a custom in-app camera system.
- **Dynamic Dashboard**: Real-time visibility into attendance statistics, pulled directly from **Cloud Firestore**.
- **Profile Image Management**: Students can update their profile picture at any time. Images are securely hosted on **Firebase Cloud Storage**.
- **Live Camera Capture**: A custom camera interface with a live viewfinder, face positioning guide, and front/back toggle.

### 👨‍🏫 Teacher Module (Planned/In Progress)
- **Live Attendance Camera**: Instantly scan the classroom to capture multiple student faces. Recognized students are automatically marked present.
- **Student Verification Center**: Review and approve student information update requests.
- **Secure Authentication**: Dedicated staff login flows.

### 🎨 UI / UX Highlights
- **Premium Aesthetics**: Sleek dark theme with modern glassmorphism elements and vibrant teal/purple accents.
- **Live Viewfinder**: Custom camera experience [CameraCaptureScreen] providing a high-quality, professional face data capture flow.
- **Reactive UI**: State automatically updates across the app when profile data or images change.

---

## 📂 Project Structure

```text
lib/
├── main.dart                          # App entry, Routing & AuthWrapper
├── theme/
│   └── app_theme.dart                 # Design System & Material 3 implementation
├── screens/
│   ├── splash_screen.dart             # Animated initial splash
│   ├── common/
│   │   └── camera_capture_screen.dart # Custom Live Camera + Preview System
│   ├── auth/
│   │   ├── login_screen.dart          # Firebase Login Interface
│   │   └── register_screen.dart       # Firebase Account Creation
│   └── student/
│       └── student_dashboard.dart     # Firestore-driven Stats & Profile updates
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli) (required for backend configuration)
- Node.js (for Firebase tools)

### Installation & Backend Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/shamantashafa/cls.git
   cd cls
   ```

2. **Initialize Firebase**
   This project uses `flutterfire` to manage configuration. You must link it to your own Firebase project:
   ```bash
   # Login to Firebase
   firebase login

   # Activate the CLI
   dart pub global activate flutterfire_cli

   # Configure the app
   flutterfire configure
   ```

3. **Enable Services**
   In your Firebase Console, ensure the following are enabled:
   - **Authentication**: Email/Password provider.
   - **Firestore Database**: Start in test mode.
   - **Cloud Storage**: Start in test mode.

4. **Run the App**
   ```bash
   flutter pub get
   flutter run
   ```

---

## 🔐 Configuration & Permissions
- **Android**: Camera permissions are pre-configured in `AndroidManifest.xml`. Ensure `minSdkVersion` is set to **23** in `android/app/build.gradle`.
- **Windows**: Webcam support is enabled via the `camera` plugin. Ensure your system privacy settings allow camera access for desktop apps.
- **Firebase**: The project includes a dummy `firebase_options.dart`. **You must run `flutterfire configure`** to generate your unique cloud API keys.

---

## 📦 Dependencies
- `firebase_auth`, `cloud_firestore`, `firebase_storage` for backend services.
- `camera` and `path_provider` for the custom capture system.
- `shared_preferences` for session persistence.
