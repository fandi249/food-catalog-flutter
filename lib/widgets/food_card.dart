import 'package:flutter/material.dart';
import '../models/food.dart';

class FoodCard extends StatefulWidget {
  final Food food;
  final VoidCallback? onTap;

  const FoodCard({super.key, required this.food, this.onTap});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 🔥 ini penting
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),

      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => isHover = true),
        onTapUp: (_) => setState(() => isHover = false),

        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),

          // 🔥 efek zoom saat hover
          transform: isHover
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),

          child: Card(
            elevation: isHover ? 12 : 3, // bayangan naik
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(widget.food.imageUrl, height: 100),
                ),
                SizedBox(height: 10),
                Text(
                  widget.food.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Rp ${widget.food.price}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
