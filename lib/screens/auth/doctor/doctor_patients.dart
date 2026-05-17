import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

final _patients = [
  {'id': 'P001', 'name': 'John Smith', 'age': '45', 'diagnosis': 'Pneumonia', 'date': '2025-10-15', 'status': 'completed'},
  {'id': 'P002', 'name': 'Sarah Johnson', 'age': '38', 'diagnosis': 'Normal', 'date': '2025-10-14', 'status': 'completed'},
  {'id': 'P003', 'name': 'Michael Brown', 'age': '52', 'diagnosis': 'Tuberculosis', 'date': '2025-10-13', 'status': 'reviewing'},
  {'id': 'P004', 'name': 'Emily Davis', 'age': '29', 'diagnosis': 'Pending Analysis', 'date': '2025-10-17', 'status': 'pending'},
  {'id': 'P005', 'name': 'Robert Wilson', 'age': '61', 'diagnosis': 'Pneumonia', 'date': '2025-10-12', 'status': 'completed'},
];

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  String _search = '';

  List<Map<String, String>> get _filtered => _patients
      .where((p) => p['name']!.toLowerCase().contains(_search.toLowerCase()) ||
      p['id']!.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Border cardBorder = Border.all(
      color: isDark ? AppTheme.darkBorderColor : AppTheme.borderColor,
      width: 1.18,
    );
    final shape = theme.cardTheme.shape;
    if (shape is RoundedRectangleBorder) {
      cardBorder = Border.fromBorderSide(shape.side);
    }
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const SessionAppTopBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Patient Management', style: GoogleFonts.dmSans(
                  fontSize: 24, fontWeight: FontWeight.w800,
                  color: theme.textTheme.headlineMedium?.color,
                )),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddPatient(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text('Add Patient', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: cardBorder,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('All Patients', style: GoogleFonts.dmSans(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.w700,
                                    color: theme.textTheme.titleLarge?.color,
                                  )),
                                  Text('Complete list of registered patients', style: GoogleFonts.dmSans(
                                    fontSize: 12, 
                                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: TextField(
                                onChanged: (v) => setState(() => _search = v),
                                style: GoogleFonts.dmSans(fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: 'Search patients...',
                                  prefixIcon: Icon(Icons.search, size: 18),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: isDark ? AppTheme.darkBackground : AppTheme.background,
                    child: Row(
                      children: [
                        _TableHeader('ID', flex: 1),
                        _TableHeader('Name', flex: 2),
                        _TableHeader('Age', flex: 1),
                        _TableHeader('Diagnosis', flex: 2),
                        _TableHeader('Status', flex: 2),
                        const _TableHeader('', flex: 1),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Patients list
                  ..._filtered.map((patient) => Column(
                    children: [
                      _PatientRow(
                        patient: patient,
                        onView: () => _showPatientDetail(context, patient),
                      ),
                      const Divider(height: 1),
                    ],
                  )),
                  if (_filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text('No patients found', style: GoogleFonts.dmSans(color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPatient(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add New Patient', style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Add Patient', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPatientDetail(BuildContext context, Map<String, String> patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final sheetTheme = Theme.of(sheetContext);
        final isDark = sheetTheme.brightness == Brightness.dark;
        
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          builder: (_, scrollCtrl) => SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Patient Details', style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetContext)),
                  ],
                ),
                Text('Complete medical record and history', style: GoogleFonts.dmSans(fontSize: 13, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
                const SizedBox(height: 20),
                // Detail grid
                Row(
                  children: [
                    _DetailField(label: 'Patient ID', value: patient['id']!),
                    const SizedBox(width: 16),
                    _DetailField(label: 'Full Name', value: patient['name']!),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _DetailField(label: 'Age', value: '${patient['age']} years'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status', style: GoogleFonts.dmSans(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
                          const SizedBox(height: 4),
                          DiagnosisBadge(label: patient['status']!, type: diagnosisToType(patient['status']!)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkBackground : AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.history, size: 18, color: AppTheme.primary),
                        const SizedBox(width: 8),
                        Text('Diagnostic History', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 12),
                      _HistoryItem(diagnosis: patient['diagnosis']!, date: patient['date']!, description: 'AI-assisted chest X-ray analysis'),
                      const Divider(height: 16),
                      const _HistoryItem(diagnosis: 'Annual Checkup', date: '2025-09-10', description: 'Routine examination - Normal'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.description_outlined, size: 16),
                        label: const Text('View Full Report'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today_outlined, size: 16),
                        label: const Text('Schedule'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  final int flex;
  const _TableHeader(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      flex: flex,
      child: Text(text, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
      )),
    );
  }
}

class _PatientRow extends StatelessWidget {
  final Map<String, String> patient;
  final VoidCallback onView;

  const _PatientRow({required this.patient, required this.onView});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(patient['id']!, style: GoogleFonts.dmSans(fontSize: 13, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary))),
          Expanded(flex: 2, child: Text(patient['name']!, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color))),
          Expanded(flex: 1, child: Text(patient['age']!, style: GoogleFonts.dmSans(fontSize: 13, color: theme.textTheme.bodyMedium?.color))),
          Expanded(flex: 2, child: Text(patient['diagnosis']!, style: GoogleFonts.dmSans(fontSize: 13, color: theme.textTheme.bodyMedium?.color))),
          Expanded(flex: 2, child: DiagnosisBadge(label: patient['status']!, type: diagnosisToType(patient['status']!))),
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: onView,
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              child: Text('View', style: GoogleFonts.dmSans(fontSize: 12, color: AppTheme.primary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  const _DetailField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color)),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String diagnosis;
  final String date;
  final String description;
  const _HistoryItem({required this.diagnosis, required this.date, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(diagnosis, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textTheme.titleSmall?.color)),
                  Text(date, style: GoogleFonts.dmSans(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
                ],
              ),
              const SizedBox(height: 2),
              Text(description, style: GoogleFonts.dmSans(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}