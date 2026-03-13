import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../widgets/kawaii_asset.dart';

class SymptomsScreen extends ConsumerStatefulWidget {
  const SymptomsScreen({super.key});

  @override
  ConsumerState<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends ConsumerState<SymptomsScreen> {
  String? _selectedFlow;
  final List<String> _selectedMoods = [];
  final List<String> _selectedSymptoms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Symptoms', style: TextStyle(fontFamily: 'Lufga', fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Are You Feeling\nToday?',
              style: TextStyle(
                fontFamily: 'Lufga',
                fontSize: 28,
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // Menstrual Flow Section
            _buildSectionTitle('Menstrual Flow'),
            _buildFlowSelector(),
            const SizedBox(height: 32),

            // Mood Section
            _buildSectionTitle('Mood'),
            _buildCharacterGrid(
              ['Calm', 'Happy', 'Anxious', 'Depressed', 'Confused', 'Sad', 'Guilty', 'Sleepy'],
              _selectedMoods,
              isMood: true,
            ),
            const SizedBox(height: 32),

            // Symptoms Section
            _buildSectionTitle('Symptoms'),
            _buildCharacterGrid(
              ['Everything is Fine', 'Cramps', 'Acne', 'Headache', 'Nausea', 'Cravings'],
              _selectedSymptoms,
            ),
            
            const SizedBox(height: 32),
            _buildSectionTitle('Sex'),
            // Placeholder for sex toggle
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.surfaceWash,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFlowSelector() {
    final flows = ['Light', 'Medium', 'Heavy'];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F5),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: flows.map((flow) {
          final isSelected = _selectedFlow == flow;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFlow = flow),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected 
                    ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop, 
                      size: 16, 
                      color: isSelected ? AppColors.primary : Colors.pink.withOpacity(0.3)
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flow,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.textPrimary : Colors.pink.withOpacity(0.4),
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                    ]
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCharacterGrid(List<String> items, List<String> selection, {bool isMood = false}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selection.contains(item);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selection.remove(item);
              } else {
                selection.add(item);
              }
            });
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFBE9E7) : const Color(0xFFF7F6F6),
                    borderRadius: BorderRadius.circular(24),
                    border: isSelected ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5) : null,
                  ),
                  child: Center(
                    child: isMood 
                      ? KawaiiAsset.mood(
                          _getMoodEnum(item), 
                          size: 48,
                        )
                      : KawaiiAsset.mood( // Using mood sheet for symptoms too if they match, or function icons
                          _getSymptomEnum(item),
                          size: 48,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  KawaiiMood _getMoodEnum(String item) {
    switch (item) {
      case 'Calm': return KawaiiMood.calm;
      case 'Happy': return KawaiiMood.happy;
      case 'Anxious': return KawaiiMood.anxious;
      case 'Depressed': return KawaiiMood.depressed;
      case 'Confused': return KawaiiMood.confused;
      case 'Sad': return KawaiiMood.sad;
      case 'Guilty': return KawaiiMood.guilty;
      case 'Sleepy': return KawaiiMood.sleepy;
      default: return KawaiiMood.calm;
    }
  }

  KawaiiMood _getSymptomEnum(String item) {
    // Mapping symptom labels to existing mood assets for now to maintain Kawaii style
    switch (item) {
      case 'Everything is Fine': return KawaiiMood.calm;
      case 'Cramps': return KawaiiMood.sad;
      case 'Acne': return KawaiiMood.anxious;
      case 'Headache': return KawaiiMood.sad;
      case 'Nausea': return KawaiiMood.depressed;
      case 'Cravings': return KawaiiMood.happy;
      default: return KawaiiMood.calm;
    }
  }
}
