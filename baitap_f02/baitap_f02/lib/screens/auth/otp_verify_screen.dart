import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_widgets.dart';
import '../home_screen.dart';
import 'reset_password_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final bool isForForgotPassword;

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.isForForgotPassword,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpController = TextEditingController();

  Future<void> _handleVerify() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (widget.isForForgotPassword) {
      final resetToken = await authProvider.verifyForgotPasswordOtp(
        widget.email,
        _otpController.text,
      );

      if (resetToken != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              identifier: widget.email,
              resetToken: resetToken,
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Verification failed')),
        );
      }
    } else {
      final success = await authProvider.verifyOtp(
        widget.email,
        _otpController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Verification failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
    );

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Verify OTP',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'A 6-digit code has been sent to ${widget.email}',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                    onCompleted: (pin) => _handleVerify(),
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'Verify',
                  isLoading: authProvider.isLoading,
                  onPressed: _handleVerify,
                ),
                const SizedBox(height: 30),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Implement Resend logic if needed
                    },
                    child: const Text('Resend Code'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
