import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile_flutter/providers/auth_provider.dart';
import 'package:mobile_flutter/providers/leave_provider.dart';
import 'package:mobile_flutter/widgets/custom_button.dart';
import 'package:mobile_flutter/widgets/custom_text_field.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  String _selectedType = 'annual';
  bool _isLoading = false;

  final List<String> _leaveTypes = [
    'annual',
    'sick',
    'unpaid',
    'other'
  ];

  final Map<String, String> _leaveTypeLabels = {
    'annual': 'Annual Leave',
    'sick': 'Sick Leave',
    'unpaid': 'Unpaid Leave',
    'other': 'Other',
  };

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Jika end date lebih kecil dari start date, set end date ke start date + 1
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: _startDate.add(const Duration(days: 30)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  int _getLeaveDays() {
    return _endDate.difference(_startDate).inDays + 1;
  }

  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

      final success = await leaveProvider.submitLeave(
        userId: authProvider.user!.id,
        startDate: _startDate,
        endDate: _endDate,
        type: _selectedType,
        reason: _reasonController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave request submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = Provider.of<LeaveProvider>(context);
    final balance = leaveProvider.balance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Leave Balance Card
              if (balance != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Your Leave Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBalanceItem(
                              'Total',
                              balance.total.toString(),
                              Colors.blue,
                            ),
                            _buildBalanceItem(
                              'Taken',
                              balance.taken.toString(),
                              Colors.orange,
                            ),
                            _buildBalanceItem(
                              'Remaining',
                              balance.remaining.toString(),
                              Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Leave Type
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave Type *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._leaveTypes.map((type) => RadioListTile<String>(
                      title: Text(_leaveTypeLabels[type] ?? type),
                      value: type,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Date Range
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    // Start Date
                    InkWell(
                      onTap: () => _selectStartDate(context),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Date *',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd MMMM yyyy').format(_startDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    const Divider(height: 24),
                    // End Date
                    InkWell(
                      onTap: () => _selectEndDate(context),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'End Date *',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd MMMM yyyy').format(_endDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Total Days Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Days:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_getLeaveDays()} day${_getLeaveDays() > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Reason
              CustomTextField(
                controller: _reasonController,
                label: 'Reason *',
                hintText: 'Please explain the reason for your leave',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Reason is required';
                  }
                  if (value.length < 10) {
                    return 'Reason must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Warning if leave type is annual and remaining balance insufficient
              if (_selectedType == 'annual' && balance != null && balance.remaining < _getLeaveDays()) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Insufficient leave balance! You only have ${balance.remaining} days remaining.',
                          style: TextStyle(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Submit Button
              CustomButton(
                text: 'Submit Request',
                onPressed: _selectedType == 'annual' && balance != null && balance.remaining < _getLeaveDays()
                    ? null
                    : _submitLeave,
                loading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}