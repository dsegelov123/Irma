import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_text_field.dart';
import '../widgets/irma_buttons.dart';
import '../widgets/irma_nav_bar.dart';
import '../providers/irma_state_providers.dart';
import '../models/irma_user.dart';

class IrmaPersonalInfoScreen extends ConsumerStatefulWidget {
  const IrmaPersonalInfoScreen({super.key});

  @override
  ConsumerState<IrmaPersonalInfoScreen> createState() => _IrmaPersonalInfoScreenState();
}

class _IrmaPersonalInfoScreenState extends ConsumerState<IrmaPersonalInfoScreen> {
  late TextEditingController _nameController;
  DateTime? _selectedDob;
  List<String> _selectedGoals = [];

  final List<String> _availableGoals = [
    'Track Period',
    'Understand Symptoms',
    'Improve Mood',
    'Boost Energy',
    'Optimize Fertility',
    'General Health',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(irmaUserProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _selectedDob = user?.dob;
    _selectedGoals = List.from(user?.goals ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: IrmaTheme.menstrual,
              onPrimary: Colors.white,
              onSurface: IrmaTheme.textMain,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDob) {
      setState(() => _selectedDob = picked);
    }
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  void _saveProfile() {
    final user = ref.read(irmaUserProvider);
    final updatedUser = (user ?? IrmaUser()).copyWith(
      name: _nameController.text,
      dob: _selectedDob,
      goals: _selectedGoals,
    );
    ref.read(irmaUserProvider.notifier).updateProfile(updatedUser);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: IrmaTheme.follicular,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const IrmaNavigationBar(title: 'Personal Info', showBackButton: true),
          Padding(
            padding: const EdgeInsets.only(top: 287),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(IrmaTheme.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  IrmaTextField(
                    label: 'Full Name',
                    hint: 'Enter your name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 24),
                  
                  // Date of Birth
                  Text(
                    'Date of Birth',
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: IrmaTheme.pureWhite,
                        borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                        border: Border.all(color: IrmaTheme.borderLight, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: IrmaTheme.pureBlack.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDob == null 
                                ? 'Select Date' 
                                : DateFormat('MMMM dd, yyyy').format(_selectedDob!),
                            style: IrmaTheme.inter.copyWith(
                              color: _selectedDob == null ? IrmaTheme.textSub : IrmaTheme.textMain,
                            ),
                          ),
                          const Icon(Iconsax.calendar_1, color: IrmaTheme.textSub, size: 20),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Goals
                  Text(
                    'Your Goals',
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: _availableGoals.map((goal) {
                      final isSelected = _selectedGoals.contains(goal);
                      return GestureDetector(
                        onTap: () => _toggleGoal(goal),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? IrmaTheme.menstrual : IrmaTheme.pureWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? IrmaTheme.menstrual : IrmaTheme.borderLight,
                            ),
                          ),
                          child: Text(
                            goal,
                            style: IrmaTheme.inter.copyWith(
                              color: isSelected ? Colors.white : IrmaTheme.textMain,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Center(
                    child: IrmaPrimaryButton(
                      text: 'Save Changes',
                      onPressed: _saveProfile,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
