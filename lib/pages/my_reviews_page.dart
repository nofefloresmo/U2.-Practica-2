import 'package:flutter/material.dart';
import 'package:dam_u2_p2_lettertecbox/models/reviews_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  List<Review> userReviews = [];

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  Future<void> loadReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reviewsString = prefs.getStringList("reviews") ?? [];
    setState(() {
      userReviews = reviewsString.map((e) => Review.fromJson(e)).toList();
    });
  }

  Future<void> saveReviews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> reviewsString =
          userReviews.map((review) => review.toJson()).toList();
      await prefs.setStringList("reviews", reviewsString);
      print("Reseñas guardadas correctamente");
    } catch (e) {
      print("Error al guardar las reseñas: $e");
    }
  }

  void deleteReview(int index) {
    saveReviews();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reseña eliminada correctamente",
            style: TextStyle(
                color: Colors.greenAccent[700], fontWeight: FontWeight.bold)),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.grey[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reseñas de Películas'),
      ),
      body: userReviews.isEmpty
          ? const Center(
              child: Text('No hay reseñas aún.'),
            )
          : ListView.builder(
              itemCount: userReviews.length,
              itemBuilder: (context, index) {
                final review = userReviews[index];
                return Dismissible(
                  key: Key(userReviews[index].toJson()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) {
                    deleteReview(index);
                  },
                  child: ListTile(
                    title: Text(review.movie.name),
                    subtitle: Text(review.reviewText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (starIndex) {
                          return Icon(
                            starIndex < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
