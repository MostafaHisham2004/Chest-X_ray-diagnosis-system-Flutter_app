import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthProvider>().user;
    final firstName = (user?.name.trim().isNotEmpty ?? false)
        ? user!.name.trim().split(RegExp(r'\s+')).first
        : 'Patient';
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.background,
      appBar: const SessionAppTopBar(onProfileTap: null),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primary, Color(0xFF00838F)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back, $firstName!',
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            )),
                        const SizedBox(height: 6),
                        Text("Here's your latest health summary.",
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.85),
                            )),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 14, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text('Last checkup: Oct 15, 2025',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: Colors.white70,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.health_and_safety_outlined,
                        size: 28, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Summary stats
            Row(
              children: [
                Expanded(
                    child: StatCard(
                        title: 'X-rays',
                        value: '8',
                        icon: Icons.image_outlined)),
                const SizedBox(width: 12),
                Expanded(
                    child: StatCard(
                        title: 'Next',
                        value: 'Nov 15',
                        icon: Icons.event_outlined)),
                const SizedBox(width: 12),
                Expanded(
                    child: StatCard(
                        title: 'Status',
                        value: 'Treatment',
                        icon: Icons.medical_services_outlined,
                        iconColor: AppTheme.warning)),
              ],
            ),
            const SizedBox(height: 16),
            // Latest AI Findings
            SectionCard(
              title: 'Latest AI Findings',
              description: 'Your recent X-ray analysis',
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.image,
                            size: 36, color: Colors.white30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Chest X-ray',
                                    style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(width: 8),
                                const DiagnosisBadge(
                                    label: 'Reviewing',
                                    type: BadgeType.reviewing),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Analyzed on October 15, 2025',
                                style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppTheme.darkTextSecondary
                                        : AppTheme.textSecondary)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkBackground
                                    : AppTheme.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline,
                                      size: 16, color: AppTheme.primary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'AI detected mild infection in the left lung region with 93% confidence',
                                      style: GoogleFonts.dmSans(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppTheme.darkTextSecondary
                                              : AppTheme.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: Text('View Full Report',
                          style:
                              GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Health Recommendations
            SectionCard(
              title: 'Health Recommendations',
              description: 'Tips for recovery',
              child: Column(
                children: [
                  _RecommendationCard(
                    icon: Icons.bedtime_outlined,
                    color: const Color(0xFF7B61FF),
                    title: 'Rest & Recovery',
                    description:
                        'Get plenty of rest and avoid strenuous activities.',
                  ),
                  const SizedBox(height: 12),
                  _RecommendationCard(
                    icon: Icons.water_drop_outlined,
                    color: AppTheme.primary,
                    title: 'Stay Hydrated',
                    description:
                        'Drink plenty of water and fluids to help thin mucus.',
                  ),
                  const SizedBox(height: 12),
                  _RecommendationCard(
                    icon: Icons.local_pharmacy_outlined,
                    color: AppTheme.success,
                    title: 'Follow-up Care',
                    description:
                        'Take prescribed medications and attend all follow-up appointments.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_outlined, size: 16),
                      label: Text('Ask AI About My Condition',
                          style:
                              GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _RecommendationCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.dmSans(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                Text(description,
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
