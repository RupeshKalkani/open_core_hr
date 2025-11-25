import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  final String loadingText;

  const CustomLoadingWidget({
    super.key,
    this.loadingText = "Loading attendance status, please wait...",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Circular Progress Indicator
            SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 20),

            // Loading Text
            Text(
              loadingText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),

            // Animated Dots for Additional Flair
            const SizedBox(height: 10),
            Text('This may take sometime.'),
          ],
        ),
      ),
    );
  }

  // Animated Dot Builder
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + (index * 200)),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
