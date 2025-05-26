import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../api/restaurant_api.dart';
import '../models/restaurant_detail.dart';
import '../services/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<RestaurantDetail> _detail;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _detail = RestaurantApi().fetchRestaurantDetail(widget.id);
    _loadFav();
  }

  void _loadFav() async {
    final fav = await FavoriteService.isFavorite(widget.id);
    setState(() => _isFav = fav);
  }

  void _toggleFav() async {
    await FavoriteService.toggleFavorite(widget.id);
    setState(() => _isFav = !_isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RestaurantDetail>(
        future: _detail,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final r = snap.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                leading: const BackButton(color: Colors.white),
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFav,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(r.name,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                  background: Hero(
                    tag: r.id,
                    child: CachedNetworkImage(
                      imageUrl: r.pictureUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(child: Text(r.address)),
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(r.rating.toString()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Description', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(r.description),
                      if (r.categories.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('Categories', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: r.categories.map((c) => Chip(label: Text(c.name))).toList(),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text('Menus', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      _menuSection('Foods', r.menus.foods),
                      const SizedBox(height: 8),
                      _menuSection('Drinks', r.menus.drinks),
                      const SizedBox(height: 16),
                      Text('Customer Reviews', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Column(
                        children: r.customerReviews.map((rev) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rev.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(rev.review),
                                  const SizedBox(height: 4),
                                  Text(rev.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _menuSection(String title, List<MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => Chip(label: Text(items[i].name)),
          ),
        ),
      ],
    );
  }
}
