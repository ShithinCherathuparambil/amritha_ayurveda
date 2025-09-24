import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../data/datasources/patient_datasource.dart';
import '../../../../domain/entities/treatment.dart';
import '../../../../domain/entities/patient.dart';

class PDFGenerator {
  static Future<void> generatePatientPDF(
    BuildContext context,
    PatientRegistrationRequest request,
    Branch branch,
    List<Treatment> selectedTreatments,
    List<int> maleCounts,
    List<int> femaleCounts,
  ) async {
    try {
      final pdf = pw.Document();

      // Add page to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildPDFContent(
              request,
              branch,
              selectedTreatments,
              maleCounts,
              femaleCounts,
            );
          },
        ),
      );

      // Show print preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Patient_Registration_${request.name.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      // Show error to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  static pw.Widget _buildPDFContent(
    PatientRegistrationRequest request,
    Branch branch,
    List<Treatment> selectedTreatments,
    List<int> maleCounts,
    List<int> femaleCounts,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.green,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'AMRITHA AYURVEDA',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Patient Registration Details',
                style: pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Patient Information
        _buildSection('Patient Information', [
          _buildInfoRow('Name:', request.name),
          _buildInfoRow('Phone:', request.phone),
          _buildInfoRow('Address:', request.address),
          _buildInfoRow('Executive:', request.executive),
        ]),
        
        pw.SizedBox(height: 16),
        
        // Branch Information
        _buildSection('Branch Information', [
          _buildInfoRow('Branch:', branch.name),
          _buildInfoRow('Location:', branch.location),
          _buildInfoRow('Phone:', branch.phone),
          _buildInfoRow('Address:', branch.address),
        ]),
        
        pw.SizedBox(height: 16),
        
        // Treatment Details
        _buildTreatmentSection(selectedTreatments, maleCounts, femaleCounts),
        
        pw.SizedBox(height: 16),
        
        // Payment Information
        _buildSection('Payment Information', [
          _buildInfoRow('Total Amount:', '₹${request.totalAmount.toStringAsFixed(2)}'),
          _buildInfoRow('Discount Amount:', '₹${request.discountAmount.toStringAsFixed(2)}'),
          _buildInfoRow('Advance Amount:', '₹${request.advanceAmount.toStringAsFixed(2)}'),
          _buildInfoRow('Balance Amount:', '₹${request.balanceAmount.toStringAsFixed(2)}'),
          _buildInfoRow('Payment Method:', request.payment),
        ]),
        
        pw.SizedBox(height: 16),
        
        // Appointment Information
        _buildSection('Appointment Information', [
          _buildInfoRow('Date & Time:', request.dateNdTime),
        ]),
        
        pw.Spacer(),
        
        // Footer
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'Thank you for choosing Amritha Ayurveda',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'For any queries, please contact your branch',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTreatmentSection(
    List<Treatment> treatments,
    List<int> maleCounts,
    List<int> femaleCounts,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Treatment Details',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 12),
          
          // Treatment table header
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(flex: 3, child: pw.Text('Treatment', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Expanded(flex: 1, child: pw.Text('Male', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Expanded(flex: 1, child: pw.Text('Female', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Expanded(flex: 1, child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Expanded(flex: 1, child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              ],
            ),
          ),
          
          // Treatment rows
          ...List.generate(treatments.length, (index) {
            final treatment = treatments[index];
            final maleCount = index < maleCounts.length ? maleCounts[index] : 0;
            final femaleCount = index < femaleCounts.length ? femaleCounts[index] : 0;
            final totalCount = maleCount + femaleCount;
            final totalPrice = treatment.priceAsDouble * totalCount;
            
            return pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(flex: 3, child: pw.Text(treatment.name)),
                  pw.Expanded(flex: 1, child: pw.Text(maleCount.toString())),
                  pw.Expanded(flex: 1, child: pw.Text(femaleCount.toString())),
                  pw.Expanded(flex: 1, child: pw.Text('₹${treatment.price}')),
                  pw.Expanded(flex: 1, child: pw.Text('₹${totalPrice.toStringAsFixed(2)}')),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
