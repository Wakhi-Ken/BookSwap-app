## BookSwap App

<img width="445" height="863" alt="image" src="https://github.com/user-attachments/assets/44283dec-2828-477b-9b33-bd2835ca7ae1" />

A Flutter app for exchanging books. Users can browse books, post their own, make swap offers, and track swap statuses.

Features

Sign in with Google or anonymously

Post, edit, delete books with optional cover images

Browse listings of available books

Make swap offers and track status (Pending, Accepted, Rejected)

Real-time updates with Firestore streams

## Getting Started
Requirements

Flutter SDK

Android Studio or VS Code

Firebase account

Setup

Clone the repo:

git clone https://github.com/Wakhi-Ken/BookSwap-app.git
cd book_swap_app


Install dependencies:

flutter pub get


Configure Firebase:

Add Android/iOS apps in Firebase Console

Place google-services.json (Android) / GoogleService-Info.plist (iOS) in the project

Enable Firestore, Firebase Storage, and Google Sign-In

Set Firestore rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

Run the App
flutter run

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
