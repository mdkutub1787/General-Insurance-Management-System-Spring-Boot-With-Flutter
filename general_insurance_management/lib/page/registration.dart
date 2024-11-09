import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:general_insurance_management/page/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<Registration> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController dob = TextEditingController();

  String selectedGender = 'Male';
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        _showSnackBar('Passwords do not match!', Colors.red);
        return;
      }

      setState(() {
        _isLoading = true; // Start loading
      });

      String uDob = DateFormat('yyyy-MM-dd').format(selectedDate!);
      final response = await _sendDataToBackend(
        name.text,
        email.text,
        password.text,
        cell.text,
        address.text,
        selectedGender,
        uDob,
      );

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar('Registration successful!', Colors.green);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else if (response.statusCode == 409) {
        _showSnackBar('User already exists!', Colors.red);
      } else {
        _showSnackBar('Registration failed with status: ${response.statusCode}',
            Colors.red);
      }
    }
  }

  Future<http.Response> _sendDataToBackend(
      String name,
      String email,
      String password,
      String cell,
      String address,
      String gender,
      String dob) async {
    const String url =
        'http://localhost:8080/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'cell': cell,
        'address': address,
        'gender': gender,
        'dob': dob,
      }),
    );
    return response;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            // Add hover effect
          });
        },
        onExit: (_) {
          setState(() {
            // Remove hover effect
          });
        },
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
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    // Add hover effect
                  });
                },
                onExit: (_) {
                  setState(() {
                    // Remove hover effect
                  });
                },
                child: RadioListTile<String>(
                  title: Text('Male', style: TextStyle(color: Colors.white)),
                  value: 'Male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  activeColor: Colors.yellow,
                ),
              ),
            ),
            Expanded(
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    // Add hover effect
                  });
                },
                onExit: (_) {
                  setState(() {
                    // Remove hover effect
                  });
                },
                child: RadioListTile<String>(
                  title: Text('Female', style: TextStyle(color: Colors.white)),
                  value: 'Female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  activeColor: Colors.yellow,
                ),
              ),
            ),
            Expanded(
              child: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    // Add hover effect
                  });
                },
                onExit: (_) {
                  setState(() {
                    // Remove hover effect
                  });
                },
                child: RadioListTile<String>(
                  title: Text('Other', style: TextStyle(color: Colors.white)),
                  value: 'Other',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  activeColor: Colors.yellow,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            // Add hover effect
          });
        },
        onExit: (_) {
          setState(() {
            // Remove hover effect
          });
        },
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          child: Text(
            'Already have an account? Login',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: TextButton.styleFrom(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.4),
          ),
        ),
      ),
    );
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
                  Colors.pinkAccent,
                  Colors.indigo,
                  Colors.purpleAccent,
                  Colors.blueAccent,
                  Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Registration Form',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lato().fontFamily,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(name, 'Full Name', Icons.person),
                    SizedBox(height: 20),
                    _buildTextField(email, 'Email', Icons.email),
                    SizedBox(height: 20),
                    _buildTextField(password, 'Password', Icons.lock,
                        obscureText: true),
                    SizedBox(height: 20),
                    _buildTextField(
                        confirmPassword, 'Confirm Password', Icons.lock,
                        obscureText: true),
                    SizedBox(height: 20),
                    _buildTextField(cell, 'Cell Number', Icons.phone),
                    SizedBox(height: 20),
                    _buildTextField(
                        address, 'Address', Icons.maps_home_work_rounded),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: dob,
                      decoration: InputDecoration(
                        labelText: "Date of Birth",
                        prefixIcon: Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white24,
                        labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                        isDense: true,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                            dob.text = DateFormat('yyyy-MM-dd')
                                .format(selectedDate!);
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    _buildGenderSelection(),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : ElevatedButton(
                      onPressed: _register,
                      child: Text('Register', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    _buildRegistrationButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
