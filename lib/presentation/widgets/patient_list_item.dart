import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/patient.dart';

class PatientListItem extends StatelessWidget {
  final Patient patient;
  final int index;
  final VoidCallback? onTap;

  const PatientListItem({
    super.key,
    required this.patient,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final treatmentName = patient.patientDetails.isNotEmpty
        ? patient.patientDetails.first.treatmentName
        : 'No treatment specified';

    final formattedDate = DateFormat('dd/MM/yyyy').format(patient.dateNdTime);
    final branchName = patient.branch.name;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with index and name
            Row(
              children: [
                Text(
                  '${index + 1}.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Treatment name
            Text(
              treatmentName,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            // Date and branch info
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.orange[600],
                ),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.orange[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    branchName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // View booking details button
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  const Text(
                    'View Booking details',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
