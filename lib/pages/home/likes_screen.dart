import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikesPage extends StatefulWidget {
  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<String> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteMovies();
  }

  Future<void> loadFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteMovies = prefs.getStringList('favorite_movies') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Movies')),
      body: _favoriteMovies.isEmpty
          ? Center(child: Text('No favorite movies yet'))
          : ListView.builder(
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                final movieTitle = _favoriteMovies[index];
                return ListTile(
                  title: Text(movieTitle),
                  onTap: () {
                    // Implement navigation to movie detail or remove from favorites
                  },
                );
              },
            ),
    );
  }
}
