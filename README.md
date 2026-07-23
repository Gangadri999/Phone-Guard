# 📱 Phone Guard
### AI-Based Classroom Phone Misuse Detection & Monitoring System

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter">
  <img src="https://img.shields.io/badge/Firebase-Firestore-orange?logo=firebase">
  <img src="https://img.shields.io/badge/Platform-Android-green?logo=android">
  <img src="https://img.shields.io/badge/Status-Completed-success">
  <img src="https://img.shields.io/badge/License-MIT-blue">
</p>

---

## 📖 Overview

Phone Guard is a Flutter and Firebase based smart classroom monitoring system developed to reduce smartphone misuse during lectures. The application allows teachers to remotely enable **Teaching Mode**, monitor students in real time, receive cheating alerts, and view classroom analytics.

The system provides a modern digital solution for maintaining classroom discipline while respecting user privacy by avoiding camera or microphone monitoring.

---

# 🚀 Features

✅ Teacher Login

✅ Student Login

✅ Firebase Authentication

✅ Role-Based Access

✅ Real-Time Teaching Mode

✅ Student Dashboard

✅ Teacher Dashboard

✅ Live Student List

✅ Live Alerts

✅ Analytics Dashboard

✅ App Minimize Detection

✅ Manual Teaching Mode Exit Detection

✅ Firestore Cloud Database

✅ Real-Time Synchronization

---

# 📸 Application Screenshots

| Screen | Screenshot |
|---------|------------|
| Home Page | *(Add Screenshot)* |
| Role Selection | *(Add Screenshot)* |
| Student Registration | *(Add Screenshot)* |
| Teacher Registration | *(Add Screenshot)* |
| Student Dashboard | *(Add Screenshot)* |
| Teacher Dashboard | *(Add Screenshot)* |
| Student List | *(Add Screenshot)* |
| Live Alerts | *(Add Screenshot)* |
| Analytics Dashboard | *(Add Screenshot)* |

---

# 🏗 System Architecture

> Replace this section with your generated System Architecture image.

```
Teacher App
      │
      ▼
 Firebase Firestore
      ▲
      │
Student App
```

---

# 📊 Block Diagram

> Replace this section with your generated Block Diagram image.

```
Teacher
   │
Teaching Mode ON
   │
Firebase
   │
Student Dashboard
   │
Student Activity
   │
Alert Generation
   │
Teacher Dashboard
```

---

# 🎥 Demo Video

📺 YouTube Demo

Add your YouTube video here after uploading.

Example:

https://youtu.be/your-video-link

---

# 🛠 Technologies Used

## Frontend

- Flutter
- Dart

## Backend

- Firebase Authentication
- Cloud Firestore

## Development Tools

- Android Studio
- Visual Studio Code
- Git
- GitHub

---

# 📂 Project Structure

```
lib/
│
├── auth/
│
├── screens/
│     ├── login_page.dart
│     ├── teacher_dashboard.dart
│     ├── student_dashboard.dart
│     ├── analytics_page.dart
│     ├── live_alerts_page.dart
│     └── student_list_page.dart
│
├── widgets/
│
├── services/
│
└── main.dart
```

---

# ⚙ Installation

## Clone Repository

```bash
git clone https://github.com/Gangadri999/Phone-Guard.git
```

Move into project folder

```bash
cd Phone-Guard
```

Install Packages

```bash
flutter pub get
```

Run Project

```bash
flutter run
```

---

# 🔥 Working Flow

1. Teacher logs into the application.

2. Student logs into the application.

3. Teacher enables Teaching Mode.

4. Student dashboard automatically switches to Teaching Mode.

5. If the student minimizes the application or manually exits Teaching Mode:

- Alert generated
- Saved in Firestore
- Displayed instantly on Teacher Dashboard

6. Teacher monitors all students in real time.

---

# 📊 Database Collections

```
users/

students/

alerts/

class_controls/
```

---

# 🔮 Future Enhancements

- AI Cheating Prediction

- Camera Based Monitoring

- Face Detection

- Microphone Detection

- GPS Tracking

- Strong Kiosk Mode

- Attendance Integration

- LMS Integration

---

# 👨‍💻 Author

**Gangadri Kandukuri**

Computer Science Engineering Student

AI • Flutter • Firebase • IoT • Full Stack Development

GitHub:
https://github.com/Gangadri999

LinkedIn:
(Add LinkedIn URL)

---

# 🤝 Contributing

Contributions, issues and feature requests are welcome.

Feel free to fork this repository and submit a Pull Request.

---

# 📄 License

This project is licensed under the MIT License.

---

## ⭐ If you like this project, don't forget to Star this repository!
