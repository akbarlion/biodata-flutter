# Biodata Mahasiswa Flutter Dengan Konfigurasi API Laravel

A Flutter project for a simple “biodata mahasiswa” application — a basic mobile/web app to display and manage student biodata.

## Table of Contents

- [About](#about)  
- [Features](#features)  
- [Getting Started](#getting-started)  
- [Prerequisites](#prerequisites)  
- [Installation / Setup](#installation-setup)  
- [Usage](#usage)  
- [Project Structure](#project-structure)  
- [Configuration](#configuration)  
- [Contributing](#contributing)  
- [License](#license)  
- [Acknowledgements](#acknowledgements)  

## About  
This project is a starter Flutter application that lets you display, add, edit, and delete student biodata (name, ID, program of study, etc.). It is built with Flutter and supports Android, iOS, Web, Windows, macOS, Linux.

## Features  
- Cross-platform: works on Android, iOS, Web, Windows, macOS, Linux.  
- Simple UI for listing biodata entries.  
- Add new biodata (name, student number (NIM), major/program, photo, etc).  
- Edit and delete existing entries.  
- Persist data locally (or optionally connect to backend / cloud in future).  
- Responsive layout for mobile and web.

## Getting Started  

### Prerequisites  
- [Flutter SDK](https://docs.flutter.dev) installed and configured.  
- A compatible editor (e.g. VS Code, Android Studio).  
- Device or emulator/simulator for testing (mobile or web).  

### Installation / Setup  
```bash
# Clone the repository  
git clone https://github.com/akbarlion/biodata-flutter.git
cd biodata-flutter  

# Get dependencies  
flutter pub get  

# Run the app (example for mobile)  
flutter run  

# Run for web  
flutter run -d chrome  
