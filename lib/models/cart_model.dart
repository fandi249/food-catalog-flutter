class CartItem {
  final String name;
  final int price;
  int qty;
  String note;

  CartItem({
    required this.name,
    required this.price,
    required this.qty,
    required this.note,
  });

  int get total => price * qty;
}
