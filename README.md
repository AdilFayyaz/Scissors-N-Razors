# Scissors-N-Razors
A Flutter based application that allows Customers to book appointments at Salons, and allows Salon owners to review the bookings, manage their expenses, and employees.

## Tools and Technologies 
1. Flutter Framework
2. Android Studio
3. Firebase Firestore 
4. ElasticSearch


######   For Firebase  ######
1. In the app\build.gradle file write- apply plugin: 'com.google.gms.google-services'   at the end of the file
2. In the android\build.gradle file write- classpath 'com.google.gms:google-services:4.3.5' in the dependencies block
3. Add the following dependencies in the pubspec.yaml file: cloud_firestore: ^1.0.4 and firebase_core: ^1.0.3
