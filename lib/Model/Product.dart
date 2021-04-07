class Product {
  String id;
  String name;
  String color;
  String storage;
  String thumbnail;
  String ram;
  num rating;
  String description;
  bool favourite;
  String waranty;
  List images;
  String brand;
  String price;

  Product(
      String id,
      String name,
      String col,
      String thumbnail,
      String store,
      String ram,
      num rate,
      String des,
      bool fav,
      String waran,
      List images,
      String brand,
      String price) {
    this.id = id;
    this.name = name;
    this.color = col;
    this.thumbnail = thumbnail;
    this.storage = store;
    this.ram = ram;
    this.rating = rate;
    this.description = des;
    this.favourite = fav;
    this.waranty = waran;
    this.images = images;
    this.brand = brand;
    this.price = price;
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        color = json["color"],
        thumbnail = json["thumbnail"],
        storage = json["storage"],
        ram = json["ram"],
        rating = json["rating"],
        description = json["description"],
        favourite = json["favourite"],
        waranty = json["waranty"],
        images = json["images"],
        brand = json["brand"],
        price = json["price"];

  Map toJson() {
    return {
      "id":id,
      "name": name,
      "color": color,
      "thumbnail": thumbnail,
      "storage": storage,
      "ram": ram,
      "rating": rating,
      "description": description,
      "favourite": favourite,
      "waranty": waranty,
      "images": images,
      "brand": brand,
      "price": price,
    };
  }
}
