import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;

    final apiKey = 'e35a1ba7a08597e26bcd38f926559685';
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                contentPadding: EdgeInsets.all(10),
              ),
              onSubmitted: _searchMovies,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchMovies(_searchController.text);
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            _searchResults.isEmpty
                ? Center(child: Text('No results found'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = _searchResults[index];
                        return ListTile(
                          leading: movie['poster_path'] != null
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                                  fit: BoxFit.cover,
                                )
                              : null,
                          title: Text(movie['title']),
                          subtitle: Text(movie['overview'] ?? 'No overview'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(
                                  movie: movie,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  final dynamic movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                width: 200,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              movie['overview'] ?? 'No overview available',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
