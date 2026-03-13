import 'package:flutter/material.dart';

enum KawaiiMood {
  calm, happy, anxious, depressed, confused, sad, guilty, sleepy, thinking
}

enum KawaiiFunction {
  periods, mucus, ovulation, looming
}

class KawaiiAsset extends StatelessWidget {
  final KawaiiMood? mood;
  final KawaiiFunction? function;
  final double size;

  const KawaiiAsset.mood(this.mood, {super.key, this.size = 40}) : function = null;
  const KawaiiAsset.function(this.function, {super.key, this.size = 40}) : mood = null;

  @override
  Widget build(BuildContext context) {
    if (mood != null) {
      return _buildMood();
    } else {
      return _buildFunction();
    }
  }

  Widget _buildMood() {
    final index = mood!.index;
    final row = index ~/ 3;
    final col = index % 3;

    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: size * 3,
          maxHeight: size * 3,
          alignment: Alignment(
            -1.0 + (col * 1.0), 
            -1.0 + (row * 1.0),
          ),
          child: Image.asset(
            'assets/images/mood_sheet.png',
            width: size * 3,
            height: size * 3,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildFunction() {
    final index = function!.index;
    final row = index ~/ 2;
    final col = index % 2;

    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: size * 2,
          maxHeight: size * 2,
          alignment: Alignment(
            -1.0 + (col * 2.0), 
            -1.0 + (row * 2.0),
          ),
          child: Image.asset(
            'assets/images/function_icons.png',
            width: size * 2,
            height: size * 2,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
