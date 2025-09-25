import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/patient.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(patient.dateNdTime);
    final formattedTime = DateFormat('hh:mm a').format(patient.dateNdTime);

    return Scaffold(
      backgroundColor: AppTheme.softGray,
      appBar: AppBar(
        backgroundColor: AppTheme.softGray,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Details',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            _buildInfoCard(
              context,
              title: 'Patient Information',
              children: [
                _buildInfoRow('Name', patient.name),
                _buildInfoRow('Phone', patient.phone),
                _buildInfoRow('Address', patient.address),
                _buildInfoRow('Executive', patient.user),
              ],
            ),
            const SizedBox(height: 16),

            // Booking Info Card
            _buildInfoCard(
              context,
              title: 'Booking Information',
              children: [
                _buildInfoRow('Date', formattedDate),
                _buildInfoRow('Time', formattedTime),
                _buildInfoRow('Branch', patient.branch.name),
                _buildInfoRow('Payment Method', patient.payment),
              ],
            ),
            const SizedBox(height: 16),

            // Treatment Info Card
            _buildInfoCard(
              context,
              title: 'Treatment Details',
              children: [
                if (patient.patientDetails.isNotEmpty)
                  ...patient.patientDetails
                      .map(
                        (detail) =>
                            _buildInfoRow('Treatment', detail.treatmentName),
                      )
                      .toList()
                else
                  _buildInfoRow('Treatment', 'No treatment specified'),
              ],
            ),
            const SizedBox(height: 16),

            // Payment Info Card
            _buildInfoCard(
              context,
              title: 'Payment Details',
              children: [
                _buildInfoRow(
                  'Total Amount',
                  '₹${patient.totalAmount.toStringAsFixed(0)}',
                ),
                _buildInfoRow(
                  'Discount Amount',
                  '₹${patient.discountAmount.toStringAsFixed(0)}',
                ),
                _buildInfoRow(
                  'Advance Amount',
                  '₹${patient.advanceAmount.toStringAsFixed(0)}',
                ),
                _buildInfoRow(
                  'Balance Amount',
                  '₹${patient.balanceAmount.toStringAsFixed(0)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.pureWhite
                    : AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                '$label:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
