import 'package:flutter/material.dart';
import 'package:dam_u2_p2_lettertecbox/widgets/login_widget.dart';
import '../models/movies_model.dart';
import 'my_reviews_page.dart';
import 'movie_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginWidget login = LoginWidget();
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    Movie.loadMovies().then((movies) {
      setState(() {
        _movies = movies;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/banners/BTTF.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/banners/DH.jpg"),
                  ),
                ),
              ),
              itemDrawer(0, Icons.home, "Inicio"),
              itemDrawer(1, Icons.rate_review, "Mis reseñas"),
              itemDrawer(2, Icons.logout, "Cerrar sesión"),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pelíclas",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              login.getLogo(20),
            ],
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            moviesByGenreLV(login, "popular", _movies),
            moviesByGenreLV(login, "Action", getMoviesByGenre("Action")),
            moviesByGenreLV(login, "Thriller", getMoviesByGenre("Thriller")),
            moviesByGenreLV(login, "Comedy", getMoviesByGenre("Comedy")),
            moviesByGenreLV(login, "Crime", getMoviesByGenre("Crime")),
            moviesByGenreLV(login, "Drama", getMoviesByGenre("Drama")),
            moviesByGenreLV(login, "Horror", getMoviesByGenre("Horror")),
            moviesByGenreLV(login, "Sci-Fi", getMoviesByGenre("Sci-Fi")),
            moviesByGenreLV(login, "Romance", getMoviesByGenre("Romance")),
            moviesByGenreLV(login, "Adventure", getMoviesByGenre("Adventure")),
            moviesByGenreLV(login, "Fantasy", getMoviesByGenre("Fantasy")),
            moviesByGenreLV(login, "Music", getMoviesByGenre("Music")),
            moviesByGenreLV(login, "Family", getMoviesByGenre("Family")),
          ],
        ));
  }

  List<Movie> getMoviesByGenre(String genre) {
    return _movies.where((movie) => movie.genre.contains(genre)).toList();
  }

  itemDrawer(int index, IconData home, String label) {
    return ListTile(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pop(context);
            break;
          case 1:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyReviewsPage()));
            break;
          case 2:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
            break;
        }
      },
      title: Row(
        children: [
          Expanded(
              child: Icon(
            home,
            color: (index == 2) ? Colors.redAccent : login.getNeonColor(),
            size: 30,
            shadows: [
              Shadow(
                color: (index == 2) ? Colors.redAccent : login.getNeonColor(),
                blurRadius: 18,
              ),
              Shadow(
                color: (index == 2)
                    ? Colors.redAccent
                    : login.getNeonColor().withOpacity(0.5),
                blurRadius: 28,
              ),
            ],
          )),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: (index == 2) ? Colors.redAccent : login.getNeonColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color:
                        (index == 2) ? Colors.redAccent : login.getNeonColor(),
                    blurRadius: 18,
                  ),
                  Shadow(
                    color: (index == 2)
                        ? Colors.redAccent
                        : login.getNeonColor().withOpacity(0.5),
                    blurRadius: 28,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget moviesByGenreLV(LoginWidget login, String genre, List<Movie> movies) {
  final Map<String, Color> genresByColor = {
    "Action": Colors.redAccent,
    "Comedy": Colors.greenAccent,
    "Drama": Colors.blueAccent,
    "Horror": Colors.purpleAccent,
    "Sci-Fi": Colors.orangeAccent,
    "Adventure": Colors.yellowAccent,
    "Fantasy": Colors.pinkAccent,
    "Family": Colors.tealAccent,
    "Thriller": Colors.amberAccent,
    "Crime": Colors.deepOrangeAccent,
    "Music": Colors.limeAccent,
    "Romance": Colors.indigoAccent,
  };

  final bool isPopular = genre == "popular";

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          genre,
          style: TextStyle(
            fontFamily: "NeonTubes",
            fontSize: isPopular ? 40 : 30,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.7),
            shadows: [
              Shadow(
                color: isPopular ? login.getNeonColor() : genresByColor[genre]!,
                blurRadius: 18,
              ),
              Shadow(
                color: isPopular
                    ? login.getNeonColor()
                    : genresByColor[genre]!.withOpacity(0.5),
                blurRadius: 28,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      SizedBox(
        height: isPopular ? 330 : 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isPopular ? 180 : 130,
                  alignment: Alignment.center,
                  child: Text(movies[index].name,
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: isPopular
                                ? login.getNeonColor()
                                : genresByColor[genre]!,
                            blurRadius: 18,
                          ),
                          Shadow(
                            color: isPopular
                                ? login.getNeonColor()
                                : genresByColor[genre]!.withOpacity(0.5),
                            blurRadius: 28,
                          ),
                        ],
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MoviePage(movie: movies[index])));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: isPopular ? 300 : 200,
                    width: isPopular ? 190 : 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/posters/${movies[index].moviePosterPath}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ],
  );
}
