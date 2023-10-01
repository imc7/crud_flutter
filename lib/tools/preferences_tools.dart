// Get data from preferences
import 'package:shared_preferences/shared_preferences.dart';

// Save
Future<void> saveIntoPreferences(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
// Try writting data
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}

// Get
Future<SharedPreferences> getFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs;
}

// Get
Future<void> removePreferences() async {
  final prefs = await SharedPreferences.getInstance();
  // Remove data for the 'counter' key.
  await prefs.remove('email');
  await prefs.remove('password');
}
