import 'dart:convert'; // For handling JSON encoding/decoding
import 'dart:io'; // For managing HTTP headers

import 'package:global_configuration/global_configuration.dart'; // Accessing global API configuration
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // Persistent storage for session data

import '../models/user.dart'; // Importing the User model

User currentUser = new User(); // Variable to store the current user session

// Function to log in the user by sending a POST request
Future<User> login(User user) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}login'; // Fetching the login endpoint dynamically
  final client = http.Client(); // Creating the HTTP client

  // Sending the login request with user data
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'}, // Ensuring the request is sent as JSON
    body: json.encode(user.toMap()), // Serializing the user data to JSON
  );

  if (response.statusCode == 200) {
    // If successful, store user data and update the session
    setCurrentUser(response.body); // Save the user session data locally
    currentUser = User.fromJSON(json.decode(response.body)['data']); // Update the current user data
  }

  return currentUser; // Return the user object
}

// Function to log out the user, clearing session data
Future<void> logout() async {
  currentUser = new User(); // Reset the current user
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Access persistent storage
  await prefs.remove('current_user'); // Remove stored session data
}

// Save the current user to persistent storage
void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['data'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'current_user', json.encode(json.decode(jsonString)['data'])); // Store user data as JSON
  }
}

// Retrieve the current user from persistent storage
Future<User?> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('current_user')) {
    currentUser =
        User.fromJSON(json.decode(prefs.get('current_user').toString())); // Parse stored user data
  }
  return currentUser;
}
