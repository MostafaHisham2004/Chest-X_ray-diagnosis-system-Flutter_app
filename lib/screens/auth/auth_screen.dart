import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'admin/admin_main.dart';
import 'doctor/doctor_main.dart';
import 'patient/patient_main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final auth = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    if (!_isSignIn && _nameController.text.trim().isEmpty) {
      _showMessage('Please enter your full name.');
      return;
    }

    if (!_isSignIn && password.length < 8) {
      _showMessage('Password must be at least 8 characters.');
      return;
    }

    if (!_isSignIn && password != _confirmPassController.text) {
      _showMessage('Passwords do not match.');
      return;
    }

    final ok = _isSignIn
        ? await auth.login(email: email, password: password)
        : await auth.signup(
            name: _nameController.text.trim(),
            email: email,
            password: password,
          );

    if (!mounted) return;

    if (!ok) {
      _showMessage(auth.errorMessage ?? 'Authentication failed.');
      return;
    }

    final destination = auth.role == 'admin'
        ? const AdminMainScreen()
        : auth.role == 'doctor'
            ? const DoctorMainScreen()
            : const PatientMainScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient (Light Mode Only)
          if (!isDark)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE0F7FA),
                      Colors.white,
                      Color(0xFFE0F7FA)
                    ],
                  ),
                ),
              ),
            ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text('AI',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(height: 20),
                      Text('MediScan AI',
                          style: GoogleFonts.dmSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: theme.textTheme.headlineLarge?.color,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        'Advanced AI X-ray Diagnosis',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Auth Card
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(24),
                          border:
                              theme.cardTheme.shape is RoundedRectangleBorder
                                  ? Border.fromBorderSide((theme.cardTheme.shape
                                          as RoundedRectangleBorder)
                                      .side)
                                  : null,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          children: [
                            // Custom Tab Switcher
                            Container(
                              height: 48,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _TabButton(
                                    label: 'Sign In',
                                    isActive: _isSignIn,
                                    onTap: () =>
                                        setState(() => _isSignIn = true),
                                  ),
                                  _TabButton(
                                    label: 'Sign Up',
                                    isActive: !_isSignIn,
                                    onTap: () =>
                                        setState(() => _isSignIn = false),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            if (!_isSignIn) ...[
                              _FormField(
                                label: 'Full Name',
                                controller: _nameController,
                                hint: 'John Doe',
                                icon: Icons.person_outline,
                                theme: theme,
                              ),
                              const SizedBox(height: 18),
                            ],

                            _FormField(
                              label: 'Email Address',
                              controller: _emailController,
                              hint: 'example@email.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              theme: theme,
                            ),
                            const SizedBox(height: 18),

                            _PasswordField(
                              label: 'Password',
                              controller: _passwordController,
                              hint: '********',
                              obscure: _obscurePassword,
                              onToggle: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              theme: theme,
                            ),

                            if (!_isSignIn) ...[
                              const SizedBox(height: 18),
                              _PasswordField(
                                label: 'Confirm Password',
                                controller: _confirmPassController,
                                hint: '********',
                                obscure: _obscureConfirm,
                                onToggle: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                                theme: theme,
                              ),
                            ],

                            const SizedBox(height: 32),

                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed:
                                        auth.isLoading ? null : _handleAuth,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: auth.isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            _isSignIn
                                                ? 'Sign In'
                                                : 'Get Started',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppTheme.success,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text('System Status: Online',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? theme.cardTheme.color : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? AppTheme.primary
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              )),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final ThemeData theme;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.theme,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final ThemeData theme;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color,
            )),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
