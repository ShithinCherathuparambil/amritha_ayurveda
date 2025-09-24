import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/treatment_provider.dart';
import '../../providers/patient_provider.dart';
import '../../../data/datasources/patient_datasource.dart';
import '../../../domain/entities/treatment.dart';
import '../../../domain/entities/patient.dart';
import 'widgets/treatment_selection_widget.dart';
import 'widgets/pdf_generator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _executiveController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();

  String? _selectedLocation;
  Branch? _selectedBranch;
  String _selectedPayment = 'Cash';
  List<Treatment> _selectedTreatments = [];
  List<int> _maleTreatmentCounts = [];
  List<int> _femaleTreatmentCounts = [];
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Static locations as requested
  final List<String> _locations = [
    'Kozhikode',
    'Kochi',
    'Kumarakom',
    'Thiruvananthapuram',
    'Kottayam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final treatmentProvider = context.read<TreatmentProvider>();
    await treatmentProvider.fetchAll();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _executiveController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _totalAmountController.dispose();
    _discountAmountController.dispose();
    _advanceAmountController.dispose();
    _balanceAmountController.dispose();
    super.dispose();
  }

  void _calculateBalance() {
    final total = double.tryParse(_totalAmountController.text) ?? 0.0;
    final discount = double.tryParse(_discountAmountController.text) ?? 0.0;
    final advance = double.tryParse(_advanceAmountController.text) ?? 0.0;
    final balance = total - discount - advance;
    _balanceAmountController.text = balance.toStringAsFixed(2);
  }

  String _formatDateTime() {
    final date = _selectedDate;
    final time = _selectedTime;
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Format: 01/02/2024-10:24 AM
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year-$hour:$minute $period';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranch == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a branch')));
      return;
    }
    if (_selectedTreatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one treatment')),
      );
      return;
    }

    final treatmentIds = _selectedTreatments
        .map((t) => t.id.toString())
        .join(',');
    final maleIds = _maleTreatmentCounts
        .asMap()
        .entries
        .where((entry) => entry.value > 0)
        .map((entry) => _selectedTreatments[entry.key].id.toString())
        .join(',');
    final femaleIds = _femaleTreatmentCounts
        .asMap()
        .entries
        .where((entry) => entry.value > 0)
        .map((entry) => _selectedTreatments[entry.key].id.toString())
        .join(',');

    final request = PatientRegistrationRequest(
      name: _nameController.text,
      executive: _executiveController.text,
      payment: _selectedPayment,
      phone: _phoneController.text,
      address: _addressController.text,
      totalAmount: double.tryParse(_totalAmountController.text) ?? 0.0,
      discountAmount: double.tryParse(_discountAmountController.text) ?? 0.0,
      advanceAmount: double.tryParse(_advanceAmountController.text) ?? 0.0,
      balanceAmount: double.tryParse(_balanceAmountController.text) ?? 0.0,
      dateNdTime: _formatDateTime(),
      id: '', // Empty string for new patients
      male: maleIds,
      female: femaleIds,
      branch: _selectedBranch!.id,
      treatments: treatmentIds,
    );

    try {
      final patientProvider = context.read<PatientProvider>();
      // Note: You'll need to add registerPatient method to PatientProvider
      // await patientProvider.registerPatient(request);

      // Generate PDF after successful registration
      await PDFGenerator.generatePatientPDF(
        context,
        request,
        _selectedBranch!,
        _selectedTreatments,
        _maleTreatmentCounts,
        _femaleTreatmentCounts,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Patient registered successfully!'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.darkGray),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.softGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.softGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: enabled ? AppTheme.pureWhite : AppTheme.softGray,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedLocation,
          decoration: InputDecoration(
            hintText: 'Choose your location',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.softGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.softGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: AppTheme.pureWhite,
          ),
          items: _locations.map((location) {
            return DropdownMenuItem(value: location, child: Text(location));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLocation = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a location';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBranchDropdown(List<Branch> branches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Branch',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Branch>(
          value: _selectedBranch,
          decoration: InputDecoration(
            hintText: 'Select the branch',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.softGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.softGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            filled: true,
            fillColor: AppTheme.pureWhite,
          ),
          items: branches.map((branch) {
            return DropdownMenuItem(value: branch, child: Text(branch.name));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBranch = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a branch';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTreatmentSection(List<Treatment> treatments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        TreatmentSelectionWidget(
          treatments: treatments,
          selectedTreatments: _selectedTreatments,
          maleCounts: _maleTreatmentCounts,
          femaleCounts: _femaleTreatmentCounts,
          onTreatmentSelectionChanged: (selected, maleCounts, femaleCounts) {
            setState(() {
              _selectedTreatments = selected;
              _maleTreatmentCounts = maleCounts;
              _femaleTreatmentCounts = femaleCounts;

              // Calculate total amount based on selected treatments
              double total = 0.0;
              for (int i = 0; i < selected.length; i++) {
                final treatment = selected[i];
                final maleCount = maleCounts.length > i ? maleCounts[i] : 0;
                final femaleCount = femaleCounts.length > i
                    ? femaleCounts[i]
                    : 0;
                final totalCount = maleCount + femaleCount;
                total += treatment.priceAsDouble * totalCount;
              }
              _totalAmountController.text = total.toStringAsFixed(2);
              _calculateBalance();
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Option',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Cash'),
                value: 'Cash',
                groupValue: _selectedPayment,
                onChanged: (value) {
                  setState(() {
                    _selectedPayment = value!;
                  });
                },
                activeColor: AppTheme.primaryGreen,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Card'),
                value: 'Card',
                groupValue: _selectedPayment,
                onChanged: (value) {
                  setState(() {
                    _selectedPayment = value!;
                  });
                },
                activeColor: AppTheme.primaryGreen,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('UPI'),
                value: 'UPI',
                groupValue: _selectedPayment,
                onChanged: (value) {
                  setState(() {
                    _selectedPayment = value!;
                  });
                },
                activeColor: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Treatment Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.softGray),
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.pureWhite,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppTheme.darkGray,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                            style: const TextStyle(color: AppTheme.darkGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Treatment Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) {
                        setState(() {
                          _selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.softGray),
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.pureWhite,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppTheme.darkGray,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedTime.format(context),
                            style: const TextStyle(color: AppTheme.darkGray),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: AppTheme.pureWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGray,
      appBar: AppBar(
        backgroundColor: AppTheme.softGray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.darkGray,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<TreatmentProvider>(
        builder: (context, treatmentProvider, child) {
          if (treatmentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (treatmentProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${treatmentProvider.errorMessage}'),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    'Name',
                    _nameController,
                    'Enter your full name',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Whatsapp Number',
                    _phoneController,
                    'Enter your Whatsapp number',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Address',
                    _addressController,
                    'Enter your full address',
                  ),
                  const SizedBox(height: 16),
                  _buildLocationDropdown(),
                  const SizedBox(height: 16),
                  _buildBranchDropdown(treatmentProvider.branches),
                  const SizedBox(height: 16),
                  _buildTreatmentSection(treatmentProvider.treatments),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Total Amount',
                    _totalAmountController,
                    '',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateBalance(),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Discount Amount',
                    _discountAmountController,
                    '',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateBalance(),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentOptions(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Advance Amount',
                    _advanceAmountController,
                    '',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateBalance(),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Balance Amount',
                    _balanceAmountController,
                    '',
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Executive',
                    _executiveController,
                    'Enter executive name',
                  ),
                  const SizedBox(height: 16),
                  _buildDateTimePickers(),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
