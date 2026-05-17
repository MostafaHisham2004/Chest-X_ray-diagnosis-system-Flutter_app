import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/admin_badge.dart';
import '../../../widgets/shared_widgets.dart';
import '../../../widgets/theme_switcher.dart';
import '../auth_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
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
    final displayName = profileUser?.name ?? 'Patient';
    final displayEmail = profileUser?.email ?? '';
    final initials = profileUser?.initials ?? 'PT';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const SessionAppTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Profile', style: GoogleFonts.dmSans(
                fontSize: 26, fontWeight: FontWeight.w800, color: theme.textTheme.headlineLarge?.color)),
            const SizedBox(height: 4),
            Text('View and manage your personal information',
                style: GoogleFonts.dmSans(fontSize: 14, color: txtSec)),
            const SizedBox(height: 20),

            // ── Profile Card ───────────────────────────────────────────────
            SectionCard(
              title: '',
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                  child: Text(initials, style: GoogleFonts.dmSans(
                      fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                ),
                const SizedBox(height: 16),
                UserNameWithBadge(
                  name: displayName,
                  isAdmin: auth.isAdmin,
                  isLoading: auth.isLoading,
                  nameStyle: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(displayEmail.toUpperCase(),
                    style: GoogleFonts.dmSans(fontSize: 13, color: txtSec)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Badge(label: 'Patient',
                        bg: isDark ? theme.colorScheme.surfaceContainerHighest : AppTheme.badgeBlue,
                        fg: isDark ? AppTheme.darkTextPrimary : AppTheme.badgeBlueFg),
                    const SizedBox(width: 8),
                    AdminBadge(isAdmin: auth.isAdmin, isLoading: auth.isLoading),
                    const SizedBox(width: 8),
                    const _Badge(label: 'Active',
                        bg: AppTheme.statGreenBg, fg: AppTheme.statGreenLabel),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Edit Profile'),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Personal Information ───────────────────────────────────────
            SectionCard(
              title: 'Personal Information',
              description: 'Your personal and medical details',
              child: Column(children: [
                const _InfoTile(icon: Icons.bloodtype_outlined, iconColor: Color(0xFFEF5350),
                    label: 'Blood Type', value: 'O+'),
                const SizedBox(height: 8),
                const _InfoTile(icon: Icons.cake_outlined, iconColor: AppTheme.warning,
                    label: 'Date of Birth', value: 'January 15, 1990'),
                const SizedBox(height: 8),
                const _InfoTile(icon: Icons.location_on_outlined, iconColor: AppTheme.primary,
                    label: 'Location', value: 'New York, USA'),
                const SizedBox(height: 8),
                const _InfoTile(icon: Icons.phone_outlined, iconColor: AppTheme.success,
                    label: 'Phone', value: '+1 (555) 123-4567'),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Medical Summary ────────────────────────────────────────────
            SectionCard(
              title: 'Medical Summary',
              description: 'Overview of your medical data',
              padding: EdgeInsets.zero,
              child: Column(children: [
                _StatRow(label: 'Total X-rays', value: '12',
                    divider: theme.dividerTheme.color!),
                Divider(height: 1, color: theme.dividerTheme.color),
                _StatRow(label: 'Reports Received', value: '8',
                    divider: theme.dividerTheme.color!),
                Divider(height: 1, color: theme.dividerTheme.color),
                _StatRow(label: 'AI Consultations', value: '15',
                    divider: theme.dividerTheme.color!),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Recent Activity ────────────────────────────────────────────
            SectionCard(
              title: 'Recent Activity',
              description: 'Your recent actions and updates',
              child: Column(children: [
                _ActivityItem(title: 'X-ray uploaded', subtitle: 'Chest X-ray',
                    date: '2025-10-15', color: AppTheme.primary),
                Divider(height: 16, color: theme.dividerTheme.color),
                _ActivityItem(title: 'Report received', subtitle: 'AI Analysis Complete',
                    date: '2025-10-10', color: AppTheme.success),
                Divider(height: 16, color: theme.dividerTheme.color),
                _ActivityItem(title: 'Appointment scheduled', subtitle: 'Follow-up consultation',
                    date: '2025-10-05', color: AppTheme.warning),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Appearance ────────────────────────────────────────────────
            SectionCard(
              title: 'Appearance',
              description: 'Choose your preferred theme',
              child: const ThemeSwitcher(),
            ),
            const SizedBox(height: 16),

            // ── Settings ──────────────────────────────────────────────────
            SectionCard(
              title: 'Settings',
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: Column(children: [
                const SettingToggleRow(title: 'Email Notifications',
                    subtitle: 'Receive notifications via email'),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'Push Notifications',
                    subtitle: 'Receive push notifications', initialValue: false),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'X-ray Report Alerts',
                    subtitle: 'Get notified when reports are ready'),
                Divider(height: 1, color: theme.dividerTheme.color),
                const SettingToggleRow(title: 'Appointment Reminders',
                    subtitle: 'Get reminders for upcoming appointments'),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Security ──────────────────────────────────────────────────
            SectionCard(
              title: 'Security',
              description: 'Manage your security preferences',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SettingToggleRow(title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security', initialValue: false),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Text('Update Password', style: GoogleFonts.dmSans(
                    fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color)),
                const SizedBox(height: 12),
                const TextField(obscureText: true, 
                    decoration: InputDecoration(hintText: 'Enter current password',
                        prefixIcon: Icon(Icons.lock_outline, size: 18))),
                const SizedBox(height: 10),
                const TextField(obscureText: true,
                    decoration: InputDecoration(hintText: 'Enter new password',
                        prefixIcon: Icon(Icons.lock_outline, size: 18))),
                const SizedBox(height: 10),
                const TextField(obscureText: true,
                    decoration: InputDecoration(hintText: 'Confirm new password',
                        prefixIcon: Icon(Icons.lock_outline, size: 18))),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, height: 44,
                    child: ElevatedButton(onPressed: () {},
                        child: const Text('Update Password'))),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Data & Privacy ────────────────────────────────────────────
            SectionCard(
              title: 'Data & Privacy',
              description: 'Manage your data and privacy settings',
              child: Column(children: [
                _ActionButton(icon: Icons.download_outlined, label: 'Download My Data', onTap: () {}),
                const SizedBox(height: 8),
                _ActionButton(icon: Icons.policy_outlined, label: 'Privacy Policy', onTap: () {}),
                const SizedBox(height: 8),
                _ActionButton(icon: Icons.article_outlined, label: 'Terms of Service', onTap: () {}),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Help & Support ────────────────────────────────────────────
            SectionCard(
              title: 'Help & Support',
              description: 'Get help and contact support',
              child: Column(children: [
                _ActionButton(icon: Icons.headset_mic_outlined, label: 'Contact Support', onTap: () {}),
                const SizedBox(height: 8),
                _ActionButton(icon: Icons.help_outline, label: 'FAQ', onTap: () {}),
                const SizedBox(height: 12),
                Center(child: Text('App Version 1.0.0',
                    style: GoogleFonts.dmSans(fontSize: 12, color: txtSec))),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Save / Cancel ─────────────────────────────────────────────
            Row(children: [
              Expanded(child: SizedBox(height: 48,
                  child: ElevatedButton(onPressed: () {},
                      child: const Text('Save Changes')))),
              const SizedBox(width: 12),
              Expanded(child: SizedBox(height: 48,
                  child: OutlinedButton(onPressed: () {},
                      child: const Text('Cancel')))),
            ]),
            const SizedBox(height: 12),

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
                label: Text('Sign Out', style: GoogleFonts.dmSans(
                    color: Colors.red, fontWeight: FontWeight.w600)),
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value;

  const _InfoTile({required this.icon, required this.iconColor,
    required this.label, required this.value});

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
              color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: GoogleFonts.dmSans(
              fontSize: 12, 
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary
          )),
          Text(value, style: GoogleFonts.dmSans(
              fontSize: 15, 
              fontWeight: FontWeight.w600, 
              color: theme.textTheme.bodyLarge?.color
          )),
        ]),
      ]),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label, value;
  final Color divider;
  const _StatRow({required this.label, required this.value, required this.divider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.dmSans(
            fontSize: 14, 
            color: theme.brightness == Brightness.dark ? AppTheme.darkTextSecondary : AppTheme.textSecondary
        )),
        Text(value, style: GoogleFonts.dmSans(
            fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primary)),
      ]),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title, subtitle, date;
  final Color color;
  const _ActivityItem({required this.title, required this.subtitle, required this.date,
    required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final txtSec = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return Row(children: [
      Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.dmSans(
            fontSize: 14, 
            fontWeight: FontWeight.w600, 
            color: theme.textTheme.bodyLarge?.color
        )),
        Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: txtSec)),
      ])),
      Text(date, style: GoogleFonts.dmSans(fontSize: 12, color: txtSec)),
    ]);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: SizedBox(
      width: double.infinity, height: 44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.dmSans(fontWeight: FontWeight.w500)),
        style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft),
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
    child: Text(label, style: GoogleFonts.dmSans(
        fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
  );
}