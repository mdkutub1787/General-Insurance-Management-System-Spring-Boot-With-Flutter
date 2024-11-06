import 'package:flutter/material.dart';
import 'package:general_insurance_management/page/Head_Office.dart';
import 'package:general_insurance_management/page/Local_Office.dart';
import 'package:general_insurance_management/page/User.dart';
import 'package:general_insurance_management/page/registration.dart';
import 'package:general_insurance_management/service/Auth_Service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final storage = FlutterSecureStorage();
  final AuthService authService = AuthService();
  bool isLoading = false; // Loading state

  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true); // Set loading to true

    try {
      final response = await authService.login(email.text, password.text);

      // Successful login, role-based navigation
      final role = await authService.getUserRole(); // Get role from AuthService

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HeadOffice()),
        );
      } else if (role == 'LocalOffice') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalOffice(
              officeName: 'Kushtia',
              address: '123 Main St, Cityville',
              contactNumber: '01763001787',
              workingHours: 'Mon-Fri, 9 AM - 5 PM',
            ),
          ),
        );
      } else if (role == 'USER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => User()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    } finally {
      setState(() => isLoading = false); // Reset loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo,
                  Colors.pinkAccent,
                  Colors.blueAccent,
                  Colors.purpleAccent,
                  Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login Form',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      _buildTextField(email, 'Email', Icons.email),
                      SizedBox(height: 20),
                      _buildTextField(password, 'Password', Icons.lock, obscureText: true),
                      SizedBox(height: 20),
                      _buildLoginButton(context),
                      SizedBox(height: 10),
                      _buildRegistrationButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white, size: 20),
          filled: true,
          fillColor: Colors.white24,
          labelStyle: TextStyle(color: Colors.white, fontSize: 16),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        obscureText: obscureText,
        style: TextStyle(color: Colors.white, fontSize: 14),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => login(context),
        child: Text(
          isLoading ? "Loading..." : "Login",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellowAccent,
          minimumSize: Size(120, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10,
          shadowColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Registration()),
          );
        },
        child: Text(
          'Create an Account',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: TextButton.styleFrom(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }
}
