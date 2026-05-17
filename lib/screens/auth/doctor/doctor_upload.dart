import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

class DoctorUploadScreen extends StatefulWidget {
  const DoctorUploadScreen({super.key});

  @override
  State<DoctorUploadScreen> createState() => _DoctorUploadScreenState();
}

class _DoctorUploadScreenState extends State<DoctorUploadScreen> {
  bool _fileSelected = false;
  bool _isAnalyzing = false;
  String? _selectedPatient;

  final _patients = ['John Smith', 'Sarah Johnson', 'Michael Brown', 'Emily Davis', 'Robert Wilson'];

  void _simulateAnalysis() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isAnalyzing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final txtSec = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const SessionAppTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload X-ray', style: GoogleFonts.dmSans(
              fontSize: 26, 
              fontWeight: FontWeight.w800,
              color: theme.textTheme.headlineLarge?.color,
            )),
            const SizedBox(height: 4),
            Text('Upload for AI analysis', style: GoogleFonts.dmSans(
              fontSize: 14, 
              color: txtSec,
            )),
            const SizedBox(height: 20),
            
            SectionCard(
              title: 'Upload Image',
              description: 'Drag and drop or click to select',
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!_fileSelected) ...[
                    UploadDropzone(onTap: () => setState(() => _fileSelected = true)),
                  ] else ...[
                    const _SelectedFilePreview(),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => setState(() => _fileSelected = false),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Remove'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Patient selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Patient', style: GoogleFonts.dmSans(
                        fontSize: 13, 
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.titleMedium?.color,
                      )),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPatient,
                            isExpanded: true,
                            dropdownColor: theme.cardTheme.color,
                            hint: Text('Select a patient', style: GoogleFonts.dmSans(
                              color: txtSec, 
                              fontSize: 14
                            )),
                            style: GoogleFonts.dmSans(
                              fontSize: 14, 
                              color: theme.textTheme.bodyLarge?.color
                            ),
                            items: _patients.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                            onChanged: (v) => setState(() => _selectedPatient = v),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _fileSelected ? _simulateAnalysis : null,
                      icon: _isAnalyzing
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.upload, size: 18),
                      label: Text(_isAnalyzing ? 'Analyzing...' : 'Upload X-ray',
                          style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  if (_isAnalyzing) ...[
                    const SizedBox(height: 16),
                    const _AnalysisProgress(),
                  ],
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

class _SelectedFilePreview extends StatelessWidget {
  const _SelectedFilePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.image, size: 48, color: Colors.white30),
          Positioned(
            top: 12, right: 12,
            child: DiagnosisBadge(label: 'chest_xray.jpg', type: BadgeType.info),
          ),
        ],
      ),
    );
  }
}

class _AnalysisProgress extends StatelessWidget {
  const _AnalysisProgress();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Analysis in Progress', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
              Text('This may take a moment...', style: GoogleFonts.dmSans(
                fontSize: 11, 
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary
              )),
            ],
          )),
        ],
      ),
    );
  }
}