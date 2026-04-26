import '../models/cart_model.dart';

class CartService {
  static List<CartItem> items = [];

  static void addItem(CartItem item) {
    int index = items.indexWhere((e) => e.name == item.name);

    if (index != -1) {
      items[index].qty += item.qty;
    } else {
      items.add(item);
    }
  }

  static int get totalPrice {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  static void clear() {
    items.clear();
  }
}
