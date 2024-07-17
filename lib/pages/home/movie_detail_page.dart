import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMovies = prefs.getStringList('favorite_movies') ?? [];
    setState(() {
      _isFavorite = favoriteMovies.contains(widget.movie['title']);
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMovies = prefs.getStringList('favorite_movies') ?? [];

    setState(() {
      if (_isFavorite) {
        favoriteMovies.remove(widget.movie['title']);
      } else {
        favoriteMovies.add(widget.movie['title']);
      }
      _isFavorite = !_isFavorite;
    });

    await prefs.setStringList('favorite_movies', favoriteMovies);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.movie['title']} berhasil ${_isFavorite ? 'disimpan ke dalam favorit' : 'dihapus dari favorit'}.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                width: 200,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.movie['overview'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : null,
                ),
                label: Text(_isFavorite ? 'Favorited' : 'Favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
