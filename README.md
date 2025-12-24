Boozin Fitness App 🏃‍♂️
A Flutter-based fitness tracking application that monitors your daily steps and calories burned using Health Connect on Android.

https://drive.google.com/file/d/14Ht0n1deNlyRBQOoC7Wwg324yz4mulGH/view?usp=sharing

✨ Features
Step Tracking – Monitor daily steps with progress visualization


https://github.com/user-attachments/assets/adbde56f-9cf8-46ae-a8bb-28277a7ccf26


Calorie Monitoring – Track active calories burned

Goal Setting – Set personalized fitness goals

Health Connect Integration – Syncs with Google's Health Connect platform

Real-time Updates – Automatic data synchronization

Dark/Light Theme – Beautiful UI with theme support

📲 Installation
Prerequisites
Flutter SDK (3.19.0+)

Dart SDK (3.3+)

Android device with Health Connect installed

Setup Steps
Install Health Connect from Google Play Store

Clone & Run:

bash
git clone
cd boozin_fitness_app
flutter pub get
flutter run
Grant Permissions when prompted:

System Activity Recognition

Health Connect data access

🛠️ Tech Stack
Framework: Flutter

State Management: GetX

Health Integration: Health Connect API

Architecture: MVVM with Clean Architecture principles

📱 App Flow
First Launch: Checks permissions → Requests access if needed

Permission Granted: Automatically fetches and displays health data

Daily Use: Shows steps/calories with progress toward goals

Refresh: Pull down to sync latest data

🔧 Key Packages
health – Health Connect integration

permission_handler – Permission management

get_storage – Local storage

flutter_animate – Smooth animations

🚀 Getting Started
dart
// Example: Fetch health data
final data = await healthService.fetchTodayData();
// Returns: {steps: 5243, caloriesBurned: 287, lastUpdated: ...}
📈 Goals & Tracking
Default Goals: 15,000 steps / 1,000 calories per day

Progress Visualization: Circular progress indicators

Real Updates: Data updates automatically via Health Connect


📄 License
MIT License - see LICENSE file for details
