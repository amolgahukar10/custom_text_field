import 'package:flutter/material.dart';
import 'package:custome_border_text_field/custome_border_text_field.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Custom Text Field'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _multilineController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registration Form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Name Field
              BorderTextField(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
                onChanged: (value) => print('Name changed: $value'),
                isMandatory: true,
                isLabelRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              BorderTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                onChanged: (value) => print('Email changed: $value'),
                inputType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
                isMandatory: true,
                isLabelRequired: true,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // Phone Field
              BorderTextField(
                labelText: 'Phone Number',
                hintText: 'Enter 10-digit phone number',
                controller: _phoneController,
                onChanged: (value) => print('Phone changed: $value'),
                inputType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                isMandatory: true,
                isLabelRequired: true,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),

              // Password Field
              BorderTextField(
                labelText: 'Password',
                hintText: 'Enter password',
                controller: _passwordController,
                onChanged: (value) => print('Password changed'),
                obscureText: true,
                sufixIcon: const Icon(Icons.visibility),
                isMandatory: true,
                isLabelRequired: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              BorderTextField(
                labelText: 'Confirm Password',
                hintText: 'Re-enter password',
                controller: _confirmPasswordController,
                onChanged: (value) => print('Confirm password changed'),
                obscureText: true,
                sufixIcon: const Icon(Icons.visibility),
                isMandatory: true,
                isLabelRequired: true,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 16),

              // Multiline Text Field
              BorderTextField(
                labelText: 'Description',
                hintText: 'Enter your bio or additional information',
                controller: _multilineController,
                onChanged: (value) => print('Description changed: $value'),
                maxLine: 5,
                inputType: TextInputType.multiline,
                filled: true,
                fillColor: Colors.grey[100],
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'Description cannot exceed 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _multilineController.dispose();
    super.dispose();
  }
}
