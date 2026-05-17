import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/admin_badge.dart';
import '../../../widgets/shared_widgets.dart';
import '../../../widgets/theme_switcher.dart';
import '../auth_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final profileUser = auth.user;

    final txtSec = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final displayName = profileUser?.name ?? 'Doctor';
    final displayEmail = profileUser?.email ?? '';
    final initials = profileUser?.initials ?? 'DR';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const SessionAppTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Profile', style: GoogleFonts.dmSans(
                fontSize: 26, 
                fontWeight: FontWeight.w800, 
                color: theme.textTheme.headlineLarge?.color
            )),
            const SizedBox(height: 4),
            Text('View and manage your professional information',
                style: GoogleFonts.dmSans(fontSize: 14, color: txtSec)),
            const SizedBox(height: 20),

            // ── Profile Card ───────────────────────────────────────────────
            SectionCard(
              title: '',
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primary,
                    child: Text(initials, style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  UserNameWithBadge(
                    name: displayName,
                    isAdmin: auth.isAdmin,
                    isLoading: auth.isLoading,
                    nameStyle: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(displayEmail,
                      style: GoogleFonts.dmSans(fontSize: 14, color: txtSec)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DarkBadge(label: 'Doctor', 
                          bg: theme.colorScheme.surfaceContainerHighest, 
                          fg: theme.textTheme.bodyLarge?.color ?? Colors.white),
                      const SizedBox(width: 8),
                      AdminBadge(isAdmin: auth.isAdmin, isLoading: auth.isLoading),
                      const SizedBox(width: 8),
                      const _DarkBadge(label: 'Active',
                          bg: AppTheme.statGreenBg, fg: AppTheme.statGreenLabel),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Professional Information ───────────────────────────────────
            SectionCard(
              title: 'Professional Information',
              description: 'Your professional credentials and details',
              child: const Column(children: [
                _InfoTile(icon: Icons.medical_services_outlined, label: 'Specialty',
                    value: 'Radiology'),
                SizedBox(height: 8),
                _InfoTile(icon: Icons.badge_outlined, label: 'License Number',
                    value: 'MD-12345'),
                SizedBox(height: 8),
                _InfoTile(icon: Icons.work_history_outlined, label: 'Years of Experience',
                    value: '12 Years'),
                SizedBox(height: 8),
                _InfoTile(icon: Icons.local_hospital_outlined, label: 'Hospital',
                    value: 'City General Hospital'),
                SizedBox(height: 8),
                _InfoTile(icon: Icons.phone_outlined, label: 'Phone',
                    value: '+1 (555) 987-6543'),
                SizedBox(height: 8),
                _InfoTile(icon: Icons.email_outlined, label: 'Email',
                    value: 'doctor@gmail.com'),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Performance Overview ───────
            const SectionCard(
              title: 'Performance Overview',
              description: 'Your activity statistics',
              child: Column(children: [
                Row(children: [
                  Expanded(child: _FigmaStatBlock(
                      label: 'Patients Treated', value: '234',
                      bg: AppTheme.statBlueBg, valueFg: AppTheme.statBlueFg,
                      labelFg: AppTheme.statBlueLabel)),
                  SizedBox(width: 12),
                  Expanded(child: _FigmaStatBlock(
                      label: 'X-rays Analyzed', value: '456',
                      bg: AppTheme.statGreenBg, valueFg: AppTheme.statGreenFg,
                      labelFg: AppTheme.statGreenLabel)),
                ]),
                SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _FigmaStatBlock(
                      label: 'Reports Generated', value: '389',
                      bg: AppTheme.statPurpleBg, valueFg: AppTheme.statPurpleFg,
                      labelFg: AppTheme.statPurpleLabel)),
                  SizedBox(width: 12),
                  Expanded(child: _FigmaStatBlock(
                      label: 'AI Consultations', value: '567',
                      bg: AppTheme.statOrangeBg, valueFg: AppTheme.statOrangeFg,
                      labelFg: AppTheme.statOrangeLabel)),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Recent Activity ────────────────────────────────────────────
            const SectionCard(
              title: 'Recent Activity',
              description: 'Your recent actions and updates',
              child: Column(children: [
                _ActivityItem(title: 'Patient diagnosed', subtitle: 'Pneumonia case reviewed',
                    date: '2025-10-18'),
                _ActivityItem(title: 'X-ray uploaded', subtitle: 'Chest X-ray for patient #1245',
                    date: '2025-10-17'),
                _ActivityItem(title: 'Report generated', subtitle: 'AI analysis completed',
                    date: '2025-10-16'),
                _ActivityItem(title: 'Consultation completed', subtitle: 'Video call with patient',
                    date: '2025-10-15', showDivider: false),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Appearance ────────────────────────────────────────────────
            const SectionCard(
              title: 'Appearance',
              description: 'Choose your preferred theme',
              child: ThemeSwitcher(),
            ),
            const SizedBox(height: 16),

            // ── Settings ──────────────────────────────────────────────────
            SectionCard(
              title: 'Settings',
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Column(children: [
                const SettingToggleRow(title: 'Email Notifications', subtitle: 'Receive notifications via email'),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'Push Notifications', subtitle: 'Receive push notifications'),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'Patient Alerts', subtitle: 'Get notified about patient updates'),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'AI Report Alerts', subtitle: 'Get notified when AI analysis completes'),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'Auto-save Reports', subtitle: 'Automatically save your work', initialValue: false),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Sign Out ──────────────────────────────────────────────────
            SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
                icon: const Icon(Icons.logout, size: 18, color: Colors.red),
                label: Text('Sign Out',
                    style: GoogleFonts.dmSans(color: Colors.red, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Info tile
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest, 
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.dmSans(
              fontSize: 14, 
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary
          )),
          Text(value, style: GoogleFonts.dmSans(
              fontSize: 16, 
              fontWeight: FontWeight.w600, 
              color: theme.textTheme.bodyLarge?.color
          )),
        ]),
      ]),
    );
  }
}

// Figma 2×2 colored stat block
class _FigmaStatBlock extends StatelessWidget {
  final String label, value;
  final Color bg, valueFg, labelFg;

  const _FigmaStatBlock({required this.label, required this.value,
    required this.bg, required this.valueFg, required this.labelFg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: labelFg)),
      const SizedBox(height: 6),
      Text(value, style: GoogleFonts.dmSans(
          fontSize: 24, fontWeight: FontWeight.w800, color: valueFg)),
    ]),
  );
}

// Activity row
class _ActivityItem extends StatelessWidget {
  final String title, subtitle, date;
  final bool showDivider;

  const _ActivityItem({
    required this.title, required this.subtitle, required this.date,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final txtSec = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                  color: AppTheme.primary, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.dmSans(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: theme.textTheme.bodyLarge?.color
            )),
            Text(subtitle, style: GoogleFonts.dmSans(fontSize: 14, color: txtSec)),
          ])),
          Text(date, style: GoogleFonts.dmSans(fontSize: 14, color: txtSec)),
        ]),
      ),
      if (showDivider) Divider(height: 1, color: theme.dividerTheme.color),
    ]);
  }
}

// Dark-style badge
class _DarkBadge extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _DarkBadge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
    child: Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
  );
}