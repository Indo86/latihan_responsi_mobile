import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../api/restaurant_api.dart';
import '../models/restaurant_detail.dart';
import '../services/favorite_service.dart';
import 'detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<RestaurantDetail>> _futureFavs;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _futureFavs = () async {
      final ids = await FavoriteService.getFavorites();
      final futures = ids.map((id) => RestaurantApi().fetchRestaurantDetail(id));
      return await Future.wait(futures);
    }();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RestaurantDetail>>(
      future: _futureFavs,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final list = snap.data!;
        if (list.isEmpty) {
          return const Center(child: Text('Belum ada favorit'));
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (c, i) {
            final r = list[i];
            return ListTile(
              leading: Hero(
                tag: r.id,
                child: CachedNetworkImage(
                  imageUrl: r.pictureUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(r.name),
              subtitle: Text(r.city),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(id: r.id)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
