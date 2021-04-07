import 'package:new_project/Model/Product.dart';

class PA {
  static final PA ourInstance = new PA();

  static PA getInstance() {
    return ourInstance;
  }

  Product selectedProduct;

  PA() {
    selectedProduct = null;
  }
}
