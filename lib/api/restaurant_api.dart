import 'dart:convert';
import '../network/network_service.dart';
import '../models/restaurant_list.dart';
import '../models/restaurant_detail.dart';

class RestaurantApi {
  static const _base = 'https://restaurant-api.dicoding.dev';

  final _net = NetworkService();

  /// List Restaurant :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}
  Future<List<Restaurant>> fetchRestaurantList() async {
    final uri = Uri.parse('$_base/list');
    final res = await _net.getRequest(uri);
    return RestaurantListResponse.fromJson(json.decode(res.body)).restaurants;
  }

  /// Detail Restaurant :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}
  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final uri = Uri.parse('$_base/detail/$id');
    final res = await _net.getRequest(uri);
    return RestaurantDetailResponse.fromJson(json.decode(res.body)).restaurant;
  }
}
