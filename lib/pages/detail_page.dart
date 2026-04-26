import 'package:flutter/material.dart';
import '../models/food.dart';
import '../data/cart_service.dart';
import '../models/cart_model.dart';
import '../widgets/floating_cart.dart';
import 'cart_page.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatefulWidget {
  final Food food;

  DetailPage({super.key, required this.food});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int qty = 1;
  final GlobalKey imageKey = GlobalKey();
  final GlobalKey cartKey = GlobalKey();
  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    void animateToCart() {
      final overlay = Overlay.of(context);

      final RenderBox imageBox =
          imageKey.currentContext!.findRenderObject() as RenderBox;
      final RenderBox cartBox =
          cartKey.currentContext!.findRenderObject() as RenderBox;

      final start = imageBox.localToGlobal(Offset.zero);
      final end = cartBox.localToGlobal(Offset.zero);

      late OverlayEntry entry;

      double top = start.dy;
      double left = start.dx;

      entry = OverlayEntry(
        builder: (context) => Positioned(
          top: top,
          left: left,
          child: Icon(Icons.fastfood, color: Colors.orange, size: 30),
        ),
      );

      overlay.insert(entry);

      Future.delayed(Duration(milliseconds: 10), () {
        entry.markNeedsBuild();

        final duration = Duration(milliseconds: 600);
        final frames = 30;
        final dx = (end.dx - start.dx) / frames;
        final dy = (end.dy - start.dy) / frames;

        int i = 0;

        Future.doWhile(() async {
          await Future.delayed(duration ~/ frames);

          top += dy;
          left += dx;

          entry.markNeedsBuild();

          i++;
          return i < frames;
        }).then((_) {
          entry.remove();
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        actions: [
          Stack(
            children: [
              IconButton(
                key: cartKey,
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  );
                },
              ),

              if (CartService.items.isNotEmpty)
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      "${CartService.items.length}",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // 👇 BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ HERO IMAGE
            ClipRRect(
              key: imageKey,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Image.asset(
                food.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🍛 NAMA
                  Text(
                    food.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 6),

                  // ⭐ RATING
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      SizedBox(width: 4),
                      Text("4.7 (120 review)"),
                    ],
                  ),

                  SizedBox(height: 10),

                  // 💰 HARGA
                  Text(
                    "Rp ${food.price}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  // 📄 DESKRIPSI
                  Text(
                    "Deskripsi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(food.description),

                  SizedBox(height: 20),

                  // 📝 NOTE
                  Text(
                    "Catatan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "Contoh: tidak pedas",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ➕➖ QTY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Jumlah",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (qty > 1) setState(() => qty--);
                            },
                          ),
                          Text("$qty", style: TextStyle(fontSize: 16)),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => qty++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 100), // biar nggak ketutup bottom bar
                ],
              ),
            ),
          ],
        ),
      ),

      // 👇 FOOTER ORDER
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Rp ${food.price * qty}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact(); // 🔥 getar

                animateToCart(); // animasi berjalan

                CartService.addItem(
                  CartItem(
                    name: food.name,
                    price: food.price,
                    qty: qty,
                    note: noteController.text,
                  ),
                );

                showFloatingCart(context);
              },
              child: Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }
}
