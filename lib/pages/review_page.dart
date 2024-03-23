import 'package:flutter/material.dart';
import '../models/movies_model.dart';
import '../models/reviews_model.dart';
import '../widgets/login_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> plataformas = [
  "Netflix~https://www.netflix.com~assets/icons/netflix.png",
  "Prime Video~https://www.primevideo.com~assets/icons/prime_video.png",
  "Disney+~https://www.disneyplus.com~assets/icons/disney_plus.png",
  "Max~https://www.hbomax.com~assets/icons/max.png"
];

class ReviewPage extends StatefulWidget {
  final Movie movie;

  // Constructor que requiere un objeto de tipo Movie
  const ReviewPage({super.key, required this.movie});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final LoginWidget login = LoginWidget();
  double _currentRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  late Review _review;

  @override
  void initState() {
    super.initState();
    final Movie movie = widget.movie;
    _review = Review(movie: movie, rating: 0, reviewText: "");
  }

  void saveReviewList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reviews = prefs.getStringList("reviews") ?? [];
    prefs.remove("reviews");
    reviews.add(_review.toJson());
    prefs.setStringList("reviews", reviews);
    print(reviews);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 210,
              child: Text(
                widget.movie.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            login.getLogo(20),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Cómo calificas?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.white.withOpacity(0.8),
                shadows: [
                  Shadow(
                    color: login.getNeonColor(),
                    blurRadius: 48,
                  ),
                  Shadow(
                    color: login.getNeonColor().withOpacity(0.5),
                    blurRadius: 58,
                  ),
                ],
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _currentRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Tu Review',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Colors.white.withOpacity(0.05),
                filled: true,
                hintText: "Escribe aquí tus pensamientos sobre la peli...",
                hintStyle: const TextStyle(
                  color: Colors.white10,
                ),
                labelText: " Review",
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF252525),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF03A9F4),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFB00020),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFB00020),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 200,
                height: 55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      login.getStartingColor(),
                      login.getNeonColor(),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (_reviewController.text != "") {
                        setState(() {
                          _review = Review(
                            movie: widget.movie,
                            rating: _currentRating.toInt(),
                            reviewText: _reviewController.text,
                          );
                        });
                        Navigator.pop(context);
                        saveReviewList();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Review enviada con éxito'),
                          backgroundColor: Colors.white30,
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Escribe tu review'),
                          backgroundColor: Colors.white30,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Enviar Review',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Puedes ver de nuevo en',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: plataformas.length,
                itemBuilder: (context, index) {
                  var plataforma = plataformas[index];
                  return Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white10,
                        leading: Image.asset(plataforma.split("~")[2]),
                        title: Text(plataforma.split("~")[0]),
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
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
