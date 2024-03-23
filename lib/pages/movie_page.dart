import 'package:flutter/material.dart';
import 'package:dam_u2_p2_lettertecbox/models/movies_model.dart';
import 'home_page.dart';
import '../widgets/login_widget.dart';
import '../pages/review_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;

  // Constructor que requiere un objeto de tipo Movie
  const MoviePage({super.key, required this.movie});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Future<void> deleteReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("1: ${prefs.getStringList("reviews")}");
    prefs.remove("reviews");
    print("2: ${prefs.getStringList("reviews")}");
  }

  final LoginWidget login = LoginWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[Colors.transparent, Colors.black],
                  stops: [0, 1],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                "assets/banners/${widget.movie.movieBannerPath}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 220,
                      child: Text.rich(
                        TextSpan(
                          text: "${widget.movie.name}\n",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                          children: [
                            const TextSpan(
                              text: "\nDIRIGIDO POR \n",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w200),
                            ),
                            TextSpan(
                              text: widget.movie.director,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "\n\n${widget.movie.year.toString()}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            TextSpan(
                              text: " - ${widget.movie.genre.toUpperCase()}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 200,
                      width: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/posters/${widget.movie.moviePosterPath}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.movie.description,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      iconSize: 70,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReviewPage(movie: widget.movie),
                          ),
                        );
                      },
                      color: login.getNeonColor(),
                      icon: const Icon(Icons.rate_review),
                    ),
                    IconButton(
                      iconSize: 70,
                      onPressed: () {
                        deleteReviews();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("En progreso..."),
                              content: const Text(
                                  "Este apartado se trabajará en próximas versiones.\nGracias por su comprensión."),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("ok"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      color: login.getStartingColor(),
                      icon: const Icon(Icons.bookmark),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        child: const Icon(
          Icons.home,
          size: 40,
        ),
      ),
    );
  }
}
