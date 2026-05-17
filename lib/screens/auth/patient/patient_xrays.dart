import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

class PatientXraysScreen extends StatelessWidget {
  const PatientXraysScreen({super.key});

  final List<Map<String, dynamic>> _xrays = const [
    {
      'title': 'Chest X-ray',
      'date': 'October 15, 2025',
      'diagnosis': 'Pneumonia',
      'status': 'completed',
      'confidence': '93%',
    },
    {
      'title': 'Chest X-ray',
      'date': 'July 10, 2025',
      'diagnosis': 'Normal',
      'status': 'completed',
      'confidence': '98%',
    },
    {
      'title': 'Chest X-ray',
      'date': 'March 22, 2025',
      'diagnosis': 'Normal',
      'status': 'completed',
      'confidence': '97%',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.background,
      appBar: const SessionAppTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My X-rays', style: GoogleFonts.dmSans(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Your X-ray history and AI analysis results',
                style: GoogleFonts.dmSans(fontSize: 14, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
            const SizedBox(height: 20),
            SectionCard(
              title: 'X-ray History',
              description: '${_xrays.length} scans total',
              child: Column(
                children: _xrays.asMap().entries.map((entry) {
                  final i = entry.key;
                  final xray = entry.value;
                  return Column(
                    children: [
                      if (i > 0) const Divider(height: 20),
                      _XrayRow(xray: xray),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _XrayRow extends StatelessWidget {
  final Map<String, dynamic> xray;
  const _XrayRow({required this.xray});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.image, size: 28, color: Colors.white30),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(xray['title'],
                      style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  DiagnosisBadge(
                    label: xray['diagnosis'],
                    type: diagnosisToType(xray['diagnosis']),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(xray['date'],
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.verified_outlined, size: 14, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text('AI Confidence: ${xray['confidence']}',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppTheme.primary)),
                ],
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
          child: Text('View', style: GoogleFonts.dmSans(fontSize: 12, color: AppTheme.primary)),
        ),
      ],
    );
  }
}