import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_widgets.dart';
import 'otp_verify_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleInit() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final maskedEmail = await authProvider.forgotPasswordInit(
        _identifierController.text.trim(),
      );

      if (maskedEmail != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerifyScreen(
              email: _identifierController.text.trim(),
              isForForgotPassword: true,
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Request failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Forgot Password',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Enter your identifier below to receive an OTP',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: _identifierController,
                    label: 'Email or Username',
                    icon: Icons.person_outline,
                    validator: (v) => v!.isEmpty ? 'Identifier required' : null,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Send OTP',
                    isLoading: authProvider.isLoading,
                    onPressed: _handleInit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
