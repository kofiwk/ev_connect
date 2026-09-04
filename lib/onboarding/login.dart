import 'package:ev_connect/components/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),

              // This image has no horizontal padding.
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/Rectangle 7.png',
                  height: 311,
                  fit: BoxFit.contain,
                ),
              ),

              // Everything below the image has side padding.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Text(
                      'Enter your number',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '🇬🇭',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+233',
                                style: GoogleFonts.poppins(fontSize: 10),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 16),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '55055xxxxx',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE5E5E5),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF338A08),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Colors.black26),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'OR',
                            style: GoogleFonts.poppins(fontSize: 8),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Colors.black26),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _SocialButton(
                      icon: Icons.apple,
                      label: 'Continue with Apple',
                      onPressed: () {},
                    ),

                    const SizedBox(height: 9),

                    _SocialButton(
                      icon: Icons.g_mobiledata,
                      iconColor: Colors.red,
                      label: 'Continue with Google',
                      onPressed: () {},
                    ),

                    const SizedBox(height: 9),

                    _SocialButton(
                      icon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      label: 'Continue with Facebook',
                      onPressed: () {},
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'By signing in, you agree to our Terms & Conditions, '
                      'acknowledge\nthat you have read our Privacy Policy, '
                      'and agree to receive\noccasional promotional content '
                      'to enhance your experience.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 5.5,
                        height: 1.35,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor = Colors.black,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 31,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 22),
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}