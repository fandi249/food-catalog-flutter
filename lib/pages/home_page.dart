import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../widgets/food_card.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🍜 Food Catalog"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.orange.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: foodList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 800
                      ? 3
                      : 2,
                ),
                itemBuilder: (context, index) {
                  return FoodCard(
                    food: foodList[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(food: foodList[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // 🔻 FOOTER
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.orange.shade200,
              child: Center(child: Text("© 2026 Fandi Food App")),
            ),
          ],
        ),
      ),
    );
  }
}
