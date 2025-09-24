import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/treatment_provider.dart';
import '../../../core/theme/app_theme.dart';

/// Home screen showing treatments and user dashboard
class HomeScreen extends StatefulWidget {
  static const route = '/home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final treatmentProvider = context.read<TreatmentProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGray,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppTheme.pureWhite,
        title: const Text('Amritha Ayurveda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {}
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outlined),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppTheme.errorRed),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(color: AppTheme.errorRed),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(children: []),
    );
  }

  Widget _buildWelcomeSection(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.pureWhite.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Guest',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ready to continue your wellness journey?',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.pureWhite.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.headingSmall.copyWith(color: AppTheme.darkGreen),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.calendar_today,
                title: 'Book Appointment',
                subtitle: 'Schedule your session',
                onTap: () {
                  // TODO: Navigate to booking
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking feature coming soon!'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.spa,
                title: 'Browse Treatments',
                subtitle: 'Explore our services',
                onTap: () {
                  // TODO: Navigate to treatments
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Treatments page coming soon!'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryGreen, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.darkGray.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedTreatments(TreatmentProvider treatmentProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Treatments',
              style: AppTheme.headingSmall.copyWith(color: AppTheme.darkGreen),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all treatments
              },
              child: Text(
                'View All',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
