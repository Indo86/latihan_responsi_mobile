class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'],
      message: json['message'],
      restaurant: RestaurantDetail.fromJson(json['restaurant']),
    );
  }
}

class RestaurantDetail {
  final String id, name, description, pictureId, city, address;
  final double rating;
  final List<Category> categories;
  final Menu menus;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  String get pictureUrl =>
      'https://restaurant-api.dicoding.dev/images/small/$pictureId';

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
      menus: Menu.fromJson(json['menus']),
      customerReviews: (json['customerReviews'] as List)
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}

class Category {
  final String name;
  Category({required this.name});
  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name']);
}

class Menu {
  final List<MenuItem> foods, drinks;
  Menu({required this.foods, required this.drinks});
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        foods: (json['foods'] as List)
            .map((e) => MenuItem.fromJson(e))
            .toList(),
        drinks: (json['drinks'] as List)
            .map((e) => MenuItem.fromJson(e))
            .toList(),
      );
}

class MenuItem {
  final String name;
  MenuItem({required this.name});
  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      MenuItem(name: json['name']);
}

class CustomerReview {
  final String name, review, date;
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });
  factory CustomerReview.fromJson(Map<String, dynamic> json) =>
      CustomerReview(
        name: json['name'],
        review: json['review'],
        date: json['date'],
      );
}
