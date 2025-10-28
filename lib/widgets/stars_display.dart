import 'package:flutter/material.dart';

class StarsDisplay extends StatelessWidget {
  final int stars;
  final double size;
  final bool showCircle;

  const StarsDisplay({
    Key? key,
    required this.stars,
    this.size = 20,
    this.showCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stars == 0) return const SizedBox.shrink();

    return Container(
      padding: showCircle ? const EdgeInsets.all(8) : EdgeInsets.zero,
      decoration: showCircle
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          bool isFilled = index < stars;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.05),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    isFilled ? Icons.star : Icons.star_border,
                    color: isFilled ? Colors.amber : Colors.white.withOpacity(0.4),
                    size: size,
                    shadows: isFilled
                        ? [
                            Shadow(
                              color: Colors.amber.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

// Büyük yıldız gösterimi (Victory ekranı için)
class BigStarsDisplay extends StatelessWidget {
  final int stars;

  const BigStarsDisplay({
    Key? key,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          bool isFilled = index < stars;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 500 + (index * 150)),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Transform.rotate(
                    angle: (1 - value) * 3.14 * 2,
                    child: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: isFilled ? Colors.amber : Colors.grey.shade300,
                      size: 50,
                      shadows: isFilled
                          ? [
                              Shadow(
                                color: Colors.amber.withOpacity(0.6),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}