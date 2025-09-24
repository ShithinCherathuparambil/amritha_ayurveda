import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/treatment.dart';

class TreatmentSelectionWidget extends StatefulWidget {
  final List<Treatment> treatments;
  final List<Treatment> selectedTreatments;
  final List<int> maleCounts;
  final List<int> femaleCounts;
  final Function(List<Treatment>, List<int>, List<int>) onTreatmentSelectionChanged;

  const TreatmentSelectionWidget({
    super.key,
    required this.treatments,
    required this.selectedTreatments,
    required this.maleCounts,
    required this.femaleCounts,
    required this.onTreatmentSelectionChanged,
  });

  @override
  State<TreatmentSelectionWidget> createState() => _TreatmentSelectionWidgetState();
}

class _TreatmentSelectionWidgetState extends State<TreatmentSelectionWidget> {
  late List<Treatment> _selectedTreatments;
  late List<int> _maleCounts;
  late List<int> _femaleCounts;

  @override
  void initState() {
    super.initState();
    _selectedTreatments = List.from(widget.selectedTreatments);
    _maleCounts = List.from(widget.maleCounts);
    _femaleCounts = List.from(widget.femaleCounts);
  }

  void _addTreatment(Treatment treatment) {
    setState(() {
      _selectedTreatments.add(treatment);
      _maleCounts.add(0);
      _femaleCounts.add(0);
    });
    _notifyChange();
  }

  void _removeTreatment(int index) {
    setState(() {
      _selectedTreatments.removeAt(index);
      _maleCounts.removeAt(index);
      _femaleCounts.removeAt(index);
    });
    _notifyChange();
  }

  void _updateMaleCount(int index, int count) {
    setState(() {
      if (index < _maleCounts.length) {
        _maleCounts[index] = count;
      }
    });
    _notifyChange();
  }

  void _updateFemaleCount(int index, int count) {
    setState(() {
      if (index < _femaleCounts.length) {
        _femaleCounts[index] = count;
      }
    });
    _notifyChange();
  }

  void _notifyChange() {
    widget.onTreatmentSelectionChanged(_selectedTreatments, _maleCounts, _femaleCounts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add Treatment Button
        InkWell(
          onTap: () => _showTreatmentSelectionDialog(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryGreen),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.pureWhite,
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: AppTheme.primaryGreen),
                SizedBox(width: 8),
                Text(
                  'Add Treatments',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Selected Treatments List
        if (_selectedTreatments.isNotEmpty) ...[
          const Text(
            'Selected Treatments:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedTreatments.length,
            itemBuilder: (context, index) {
              final treatment = _selectedTreatments[index];
              final maleCount = index < _maleCounts.length ? _maleCounts[index] : 0;
              final femaleCount = index < _femaleCounts.length ? _femaleCounts[index] : 0;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treatment.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '₹${treatment.price} • ${treatment.duration}',
                                  style: const TextStyle(
                                    color: AppTheme.darkGray,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.errorRed),
                            onPressed: () => _removeTreatment(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Male',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: maleCount > 0 
                                          ? () => _updateMaleCount(index, maleCount - 1)
                                          : null,
                                    ),
                                    Text(
                                      maleCount.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => _updateMaleCount(index, maleCount + 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Female',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: femaleCount > 0 
                                          ? () => _updateFemaleCount(index, femaleCount - 1)
                                          : null,
                                    ),
                                    Text(
                                      femaleCount.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => _updateFemaleCount(index, femaleCount + 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _showTreatmentSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Treatments'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: widget.treatments.length,
              itemBuilder: (context, index) {
                final treatment = widget.treatments[index];
                final isSelected = _selectedTreatments.any((t) => t.id == treatment.id);
                
                return ListTile(
                  title: Text(treatment.name),
                  subtitle: Text('₹${treatment.price} • ${treatment.duration}'),
                  trailing: isSelected 
                      ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                      : null,
                  onTap: isSelected 
                      ? null
                      : () {
                          _addTreatment(treatment);
                          Navigator.pop(context);
                        },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
