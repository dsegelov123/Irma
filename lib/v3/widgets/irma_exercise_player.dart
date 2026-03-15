import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';
import '../theme/irma_theme.dart';
import '../screens/irma_congratulations_screen.dart';

class IrmaExercisePlayer extends StatefulWidget {
  final String programTitle;
  
  const IrmaExercisePlayer({super.key, required this.programTitle});

  @override
  State<IrmaExercisePlayer> createState() => _IrmaExercisePlayerState();
}

class _IrmaExercisePlayerState extends State<IrmaExercisePlayer> {
  int _countdown = 3;
  bool _isPlaying = false;
  double _progress = 0.0;
  Timer? _countdownTimer;
  Timer? _audioTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _countdown = 0;
          timer.cancel();
          _startExercise();
        }
      });
    });
  }

  void _startExercise() {
    setState(() => _isPlaying = true);
    _audioTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.005; // Simulate progress
        } else {
          timer.cancel();
          _onComplete();
        }
      });
    });
  }

  void _onComplete() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IrmaCongratulationsScreen(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 322, // Gospel Question Modal Width
          height: 282, // Gospel Question Modal Height
          padding: const EdgeInsets.only(top: 32, right: 36, bottom: 32, left: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.info_circle5, color: IrmaTheme.menstrual, size: 48),
              const SizedBox(height: 16),
              Text(
                "Wait!",
                style: IrmaTheme.outfit.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: IrmaTheme.textMain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Only a few minutes left - Keep it up!",
                textAlign: TextAlign.center,
                style: IrmaTheme.inter.copyWith(
                  fontSize: 14,
                  color: IrmaTheme.textSub,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Continue"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Exit", style: TextStyle(color: IrmaTheme.textSub)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _audioTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: IrmaTheme.pureWhite,
        body: Stack(
          children: [
            // EXERCISE INTERFACE
            if (_countdown == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.programTitle,
                      style: IrmaTheme.outfit.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: IrmaTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // PROGRESS RING/CIRCLE
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 8,
                            backgroundColor: IrmaTheme.borderLight,
                            valueColor: const AlwaysStoppedAnimation(IrmaTheme.menstrual),
                          ),
                        ),
                        const Icon(Iconsax.music5, size: 64, color: IrmaTheme.menstrual),
                      ],
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      "Listen to the instructions...",
                      style: TextStyle(fontSize: 18, color: IrmaTheme.textSub),
                    ),
                    const SizedBox(height: 40),
                    // CONTROLS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.backward_10_seconds, size: 32),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 32),
                        GestureDetector(
                          onTap: () => setState(() => _isPlaying = !_isPlaying),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              gradient: IrmaTheme.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isPlaying ? Iconsax.pause5 : Iconsax.play5,
                              color: IrmaTheme.pureWhite,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        IconButton(
                          icon: const Icon(Iconsax.forward_10_seconds, size: 32),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // 3-2-1 COUNTDOWN OVERLAY
            if (_countdown > 0)
              Container(
                color: IrmaTheme.menstrual.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _countdown.toString(),
                        style: IrmaTheme.outfit.copyWith(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: IrmaTheme.pureWhite,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Get Ready",
                        style: IrmaTheme.outfit.copyWith(
                          fontSize: 32,
                          color: IrmaTheme.pureWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // CLOSE BUTTON
            Positioned(
              top: 60,
              right: 24,
              child: IconButton(
                icon: Icon(
                  Iconsax.close_circle, 
                  color: _countdown > 0 ? IrmaTheme.pureWhite : IrmaTheme.textSub,
                  size: 32,
                ),
                onPressed: () async {
                  if (await _onWillPop()) Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
