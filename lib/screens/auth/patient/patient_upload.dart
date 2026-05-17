import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

class PatientUploadScreen extends StatefulWidget {
  const PatientUploadScreen({super.key});

  @override
  State<PatientUploadScreen> createState() => _PatientUploadScreenState();
}

class _PatientUploadScreenState extends State<PatientUploadScreen> {
  bool _fileSelected = false;
  bool _isSubmitting = false;
  final _symptomsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _symptomsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('X-ray submitted for review! You\'ll receive results in 24-48 hours.', style: GoogleFonts.dmSans()),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

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
            Text('Upload X-ray', style: GoogleFonts.dmSans(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Share your X-ray images with your doctor', style: GoogleFonts.dmSans(fontSize: 14, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
            const SizedBox(height: 20),
            // Upload card
            SectionCard(
              title: 'Upload Image',
              description: 'Drag and drop or click to select your X-ray',
              child: Column(
                children: [
                  if (!_fileSelected)
                    UploadDropzone(onTap: () => setState(() => _fileSelected = true))
                  else
                    Column(
                      children: [
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A2E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.image, size: 48, color: Colors.white30),
                              Positioned(top: 12, right: 12,
                                  child: DiagnosisBadge(label: 'xray_chest.jpg', type: BadgeType.success)),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => setState(() => _fileSelected = false),
                          icon: const Icon(Icons.close, size: 14),
                          label: const Text('Remove file'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Additional Info
            SectionCard(
              title: 'Additional Information',
              description: 'Help your doctor understand your condition',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Symptoms (Optional)', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _symptomsCtrl,
                    style: GoogleFonts.dmSans(fontSize: 14),
                    decoration: const InputDecoration(hintText: 'e.g., Chest pain, difficulty breathing'),
                  ),
                  const SizedBox(height: 16),
                  Text('Additional Notes (Optional)', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    style: GoogleFonts.dmSans(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Any other information that might be helpful for your doctor...',
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _fileSelected ? _submit : null,
                      icon: _isSubmitting
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_outlined, size: 18),
                      label: Text(_isSubmitting ? 'Submitting...' : 'Submit for Review',
                          style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // What happens next
            SectionCard(
              title: 'What happens next?',
              child: Column(
                children: [
                  _StepItem(number: '1', title: 'AI Analysis', description: 'Your X-ray will be analyzed by our AI system to detect any potential issues.'),
                  const Divider(height: 20),
                  _StepItem(number: '2', title: 'Doctor Review', description: 'A qualified doctor will review the AI results and provide their assessment.'),
                  const Divider(height: 20),
                  _StepItem(number: '3', title: 'Get Results', description: "You'll receive a detailed report with diagnosis and recommendations."),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_outlined, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text('Typical review time: 24-48 hours', style: GoogleFonts.dmSans(fontSize: 13, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Guidelines
            SectionCard(
              title: 'Important Guidelines',
              child: Column(
                children: [
                  _GuidelineRow('Ensure the X-ray image is clear and properly oriented.'),
                  const SizedBox(height: 8),
                  _GuidelineRow('Include all relevant symptoms and medical history.'),
                  const SizedBox(height: 8),
                  _GuidelineRow('This is not a substitute for emergency medical care.'),
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

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepItem({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28, height: 28,
          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(number, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(description, style: GoogleFonts.dmSans(fontSize: 13, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuidelineRow extends StatelessWidget {
  final String text;
  const _GuidelineRow(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.success),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: GoogleFonts.dmSans(fontSize: 13, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary, height: 1.4))),
      ],
    );
  }
}