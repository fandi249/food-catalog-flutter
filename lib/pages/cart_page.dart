import 'package:flutter/material.dart';
import '../data/cart_service.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void increaseQty(int index) {
    setState(() {
      CartService.items[index].qty++;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (CartService.items[index].qty > 1) {
        CartService.items[index].qty--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      CartService.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keranjang 🛒")),

      body: CartService.items.isEmpty
          ? Center(child: Text("Keranjang masih kosong 😢"))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: CartService.items.length,
              itemBuilder: (context, index) {
                final item = CartService.items[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // 📦 Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text("Rp ${item.price}"),

                              if (item.note.isNotEmpty)
                                Text(
                                  "📝 ${item.note}",
                                  style: TextStyle(color: Colors.grey),
                                ),

                              SizedBox(height: 8),

                              // ➕➖ QTY CONTROL
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () => decreaseQty(index),
                                  ),
                                  Text("${item.qty}"),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () => increaseQty(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 💰 TOTAL + DELETE
                        Column(
                          children: [
                            Text(
                              "Rp ${item.total}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // 🔻 FOOTER CHECKOUT
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
                "Total: Rp ${CartService.totalPrice}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                CartService.clear();
                setState(() {});

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Pesanan dikirim 🚀")));
              },
              child: Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
