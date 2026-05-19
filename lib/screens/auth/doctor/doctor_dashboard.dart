import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final user = context.watch<AuthProvider>().user;
    final name =
        (user?.name.trim().isNotEmpty ?? false) ? user!.name.trim() : 'Doctor';
    final greetingName =
        name.toLowerCase().startsWith('dr') ? name : 'Dr. $name';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const SessionAppTopBar(onProfileTap: null),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
              maxWidth: 1000), // Professional centering on large screens
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text('Dashboard',
                    style: GoogleFonts.dmSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: theme.textTheme.headlineLarge?.color,
                    )),
                const SizedBox(height: 4),
                Text('Welcome back, $greetingName.',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    )),
                const SizedBox(height: 20),

                // Stats grid - Responsive Column Count
                LayoutBuilder(builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth > 600 ? 1.6 : 1.4,
                    children: const [
                      StatCard(
                          title: 'Total Analyses',
                          value: '1,284',
                          icon: Icons.analytics_outlined),
                      StatCard(
                          title: 'Active Patients',
                          value: '248',
                          icon: Icons.people_outline,
                          iconColor: Color(0xFF7B61FF)),
                      StatCard(
                          title: 'Pending',
                          value: '7',
                          icon: Icons.pending_outlined,
                          iconColor: AppTheme.warning),
                      StatCard(
                          title: 'Accuracy',
                          value: '95.2%',
                          icon: Icons.verified_outlined,
                          iconColor: AppTheme.success),
                    ],
                  );
                }),

                const SizedBox(height: 20),

                // Content Grid for Charts and Lists
                if (screenWidth > 800)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _RecentDiagnosesSection(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _DiseaseDistributionSection(),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _RecentDiagnosesSection(),
                      const SizedBox(height: 16),
                      _DiseaseDistributionSection(),
                    ],
                  ),

                const SizedBox(height: 16),

                // Model Accuracy Trend (Always full width in its container)
                const SectionCard(
                  title: 'Model Accuracy Trend',
                  description: 'AI model performance',
                  child: SizedBox(height: 200, child: _AccuracyChart()),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentDiagnosesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'Recent Diagnoses',
      description: 'Latest AI-powered analysis',
      child: Column(
        children: [
          _DiagnosisRow(
              initials: 'JS',
              name: 'John Smith',
              date: '2025-10-15',
              diagnosis: 'Pneumonia'),
          Divider(height: 20),
          _DiagnosisRow(
              initials: 'MB',
              name: 'Michael Brown',
              date: '2025-10-13',
              diagnosis: 'Tuberculosis'),
          Divider(height: 20),
          _DiagnosisRow(
              initials: 'SJ',
              name: 'Sarah Johnson',
              date: '2025-10-14',
              diagnosis: 'Normal'),
        ],
      ),
    );
  }
}

class _DiseaseDistributionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Disease Distribution',
      description: 'Last 30 days',
      child: Column(
        children: [
          SizedBox(height: 180, child: _DiseaseChart()),
          const SizedBox(height: 16),
          const LegendItem(
              color: AppTheme.primary, label: 'Normal', percentage: '45%'),
          const SizedBox(height: 8),
          const LegendItem(
              color: Color(0xFFEF5350), label: 'Pneumonia', percentage: '30%'),
          const SizedBox(height: 8),
          const LegendItem(
              color: Color(0xFFFFB74D),
              label: 'Tuberculosis',
              percentage: '15%'),
          const SizedBox(height: 8),
          const LegendItem(
              color: Color(0xFF90CAF9), label: 'Other', percentage: '10%'),
        ],
      ),
    );
  }
}

class _DiagnosisRow extends StatelessWidget {
  final String initials;
  final String name;
  final String date;
  final String diagnosis;

  const _DiagnosisRow({
    required this.initials,
    required this.name,
    required this.date,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        PatientAvatar(initials: initials),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color)),
              Text(date,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  )),
            ],
          ),
        ),
        DiagnosisBadge(label: diagnosis, type: diagnosisToType(diagnosis)),
      ],
    );
  }
}

class _DiseaseChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
              value: 45,
              color: AppTheme.primary,
              radius: 60,
              title: '',
              showTitle: false),
          PieChartSectionData(
              value: 30,
              color: const Color(0xFFEF5350),
              radius: 60,
              title: '',
              showTitle: false),
          PieChartSectionData(
              value: 15,
              color: const Color(0xFFFFB74D),
              radius: 60,
              title: '',
              showTitle: false),
          PieChartSectionData(
              value: 10,
              color: const Color(0xFF90CAF9),
              radius: 60,
              title: '',
              showTitle: false),
        ],
        centerSpaceRadius: 40,
        sectionsSpace: 3,
      ),
    );
  }
}

class _AccuracyChart extends StatelessWidget {
  const _AccuracyChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gridColor = isDark ? AppTheme.darkBorderColor : AppTheme.borderColor;
    final textColor =
        isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: gridColor,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: textColor,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                const months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
                if (v.toInt() >= 0 && v.toInt() < months.length) {
                  return Text(
                    months[v.toInt()],
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: textColor,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 4,
        minY: 80,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 85),
              FlSpot(1, 89),
              FlSpot(2, 93),
              FlSpot(3, 97),
              FlSpot(4, 95.2),
            ],
            isCurved: true,
            color: AppTheme.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 5,
                color: theme.cardTheme.color ?? Colors.white,
                strokeColor: AppTheme.primary,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }
}
