// Get data from preferences
import 'package:shared_preferences/shared_preferences.dart';

// Save
Future<bool> saveIntoPreferences(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
// Try writting data
  await prefs.setString('email', email);
  await prefs.setString('password', password);
  return true;
}

// Get
Future<SharedPreferences> getFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs;
}

// Get
Future<bool> removePreferences() async {
  final prefs = await SharedPreferences.getInstance();
  // Remove data for the 'counter' key.
  await prefs.remove('email');
  await prefs.remove('password');
  return true;
}
