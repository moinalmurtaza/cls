# 📱 Smart Attendance & Student Management System

A modern, AI-ready mobile application built with **Flutter** to streamline classroom attendance and student records. The system utilizes face recognition concepts to automate the attendance process and maintain accurate semester logs.

## ✨ Features

### 👨‍🏫 Teacher Module
- **Live Attendance Camera:** Instantly scan the classroom to capture multiple student faces in a single frame. Recognized students are automatically marked present and added to the semester's final attendance logs.
- **Student Verification Center:** Professors can review, approve, or reject "Update Information" requests from students (such as face data refresh or contact changes).
- **Secure Authentication:** Dedicated login and registration flows for academic staff.
- **Records Dashboard:** Easy access to administrative logs and class statistics.

### 👨‍🎓 Student Module
- **Biometric Registration:** Students securely register by providing their Face Data and University Roll/ID numbers.
- **Dynamic Dashboard:** Real-time visibility into personal attendance statistics and current status.
- **Request Information Update:** Submit active requests to update face data (using the device camera) or profile information, which enters a pending state until verified by a teacher.

### 🎨 UI / UX Highlights
- **Premium Aesthetics:** A cohesive dark theme accented with vibrant, modern gradients (e.g., Purple & Teal).
- **Smooth Navigation:** Animated splash screens, clean TabBars for segmenting user roles, and glassmorphism elements.
- **Native Hardware Integration:** Built-in support targeting the native `image_picker` API to reliably capture face data across platforms.

---

## 📂 Project Structure

```text
lib/
├── main.dart                          # Application entry point & Routing setup
├── theme/
│   └── app_theme.dart                 # Core Design System, Colors, and Typography
├── screens/
│   ├── splash_screen.dart             # Animated initial splash
│   ├── auth/
│   │   ├── login_screen.dart          # Unified Login Interface
│   │   └── register_screen.dart       # Split Registration (Teacher / Student)
│   ├── student/
│   │   ├── student_dashboard.dart     # Student Stats & Actions
│   │   └── update_info_screen.dart    # Request data modification
│   └── teacher/
│       ├── teacher_dashboard.dart     # Teacher shortcuts & Overviews
│       ├── attendance_camera_screen.dart # Live View for Face detection attendance
│       └── verify_updates_screen.dart # Approval center for student requests
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version recommended)
- Android Studio / Xcode for emulators and building.
- A physical Android / iOS device OR an emulator with a functional camera configured.

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/shamantashafa/cls.git
cd cls
```

2. **Fetch Dependencies**
```bash
flutter pub get
```

3. **Run the Application**
```bash
flutter run
```

*Note: Since this app requires native camera capabilities (`image_picker`), ensure that your simulator has access to a simulated or actual webcam. On Windows testing, if the primary camera query fails, it gracefully falls back to a gallery picture selector.*

---

## 🔐 Permissions Configured
- **Android:** `<uses-permission android:name="android.permission.CAMERA"/>`
- **iOS:** `NSCameraUsageDescription` is enabled in `Info.plist` for secure facial data uploads.
