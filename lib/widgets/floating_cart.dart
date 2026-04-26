import 'package:flutter/material.dart';
import '../pages/cart_page.dart';

void showFloatingCart(BuildContext context) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  "Ditambahkan ke keranjang",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              TextButton(
                onPressed: () {
                  entry.remove();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  );
                },
                child: Text("Lihat", style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // auto hilang
  Future.delayed(Duration(seconds: 2), () {
    if (entry.mounted) entry.remove();
  });
}
