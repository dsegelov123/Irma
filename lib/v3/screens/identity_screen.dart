import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_text_field.dart';
import 'goals_screen.dart';
import '../widgets/irma_buttons.dart';

class IrmaIdentityScreen extends StatefulWidget {
  const IrmaIdentityScreen({super.key});

  @override
  State<IrmaIdentityScreen> createState() => _IrmaIdentityScreenState();
}

class _IrmaIdentityScreenState extends State<IrmaIdentityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      extendBodyBehindAppBar: true,
      appBar: const IrmaNavigationBar(
        title: "About You",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's get to know you",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This help us personalize your insights and cycle predictions.",
              style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
            ),
            const SizedBox(height: 40),

            // NAME INPUT
            IrmaTextField(
              label: "Preferred Name",
              hint: "How should we call you?",
              controller: _nameController,
            ),
            
            const SizedBox(height: 24),

            // DOB INPUT
            IrmaTextField(
              label: "Date of Birth",
              hint: "DD / MM / YYYY",
              controller: _dobController,
              keyboardType: TextInputType.datetime,
            ),

            const SizedBox(height: 48),

            IrmaPrimaryButton(
              label: "Continue",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IrmaGoalsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
