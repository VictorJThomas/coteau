import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 3; // 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Couteau',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'COUTEAU',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 4,
        ),
        body: Center(
          child: _buildCurrentView(), 
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentIndex) {
      case 0:
        return const GenderView();
      case 1:
        return const AgeView();
      case 2:
        return const UniversityView();
      case 3:
        return const HomeView();
      case 4:
        return const WeatherView();
      case 5:
        return const NewsView();
      case 6:
        return AboutView(
          onTabTapped: (int index) {},
        );
      default:
        return Container();
    }
  }
}

class GenderView extends StatefulWidget {
  const GenderView({super.key});

  @override
  _GenderViewState createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  String name = '';
  String gender = '';
  Color backgroundColor = const Color.fromARGB(20, 255, 71, 1);

  Future<void> fetchGender(String name) async {
    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        gender = data['gender'];
        backgroundColor = gender == 'male'
            ? const Color.fromARGB(255, 103, 156, 199)
            : const Color.fromARGB(255, 214, 107, 143);
      });
    } else {
      setState(() {
        gender = '';
        backgroundColor = const Color.fromARGB(255, 28, 26, 26);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Introduzca un nombre',
                hintStyle: TextStyle(color: Color.fromARGB(255, 43, 44, 43)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchGender(name);
              },
              child: const Text('Descubrir'),
            ),
            const SizedBox(height: 20),
            Text(
              'Nombre: $name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Genero: $gender',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AgeView extends StatefulWidget {
  const AgeView({super.key});

  @override
  _AgeViewState createState() => _AgeViewState();
}

class _AgeViewState extends State<AgeView> {
  String name = '';
  String ageCategory = '';
  Color backgroundColor = Colors.white;

  Future<void> fetchAge(String name) async {
    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final int age = data['age'];

      setState(() {
        if (age < 18) {
          ageCategory = 'Joven';
          backgroundColor = Colors.green;
        } else if (age >= 18 && age < 50) {
          ageCategory = 'Adulto';
          backgroundColor = Colors.yellow;
        } else {
          ageCategory = 'Anciano';
          backgroundColor = Colors.red;
        }
      });
    } else {
      setState(() {
        ageCategory = '';
        backgroundColor = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Introduzca un nombre',
            hintStyle: TextStyle(color: Color.fromARGB(255, 174, 174, 174)),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            fetchAge(name);
          },
          child: const Text('Descubrir'),
        ),
        const SizedBox(height: 20),
        Text(
          'Nombre: $name',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Rango: $ageCategory',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class UniversityView extends StatefulWidget {
  const UniversityView({super.key});

  @override
  _UniversityViewState createState() => _UniversityViewState();
}

class _UniversityViewState extends State<UniversityView> {
  String country = '';
  List<University> universities = [];

  Future<void> fetchUniversities(String country) async {
    final url =
        Uri.parse('http://universities.hipolabs.com/search?country=$country');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<University> fetchedUniversities = [];

      for (var universityData in data) {
        final university = University(
          name: universityData['name'],
          domain: universityData['domains'][0],
          webPage: universityData['web_pages'][0],
        );
        fetchedUniversities.add(university);
      }

      setState(() {
        universities = fetchedUniversities;
      });
    } else {
      setState(() {
        universities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  country = value;
                });
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Introduzca un pais',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchUniversities(country);
              },
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(universities[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Domain: ${universities[index].domain}'),
                        const Text('Web Page:'),
                        GestureDetector(
                          onTap: () {
                            // Open web page
                          },
                          child: Text(
                            universities[index].webPage,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 19, 93, 154),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              'https://media.istockphoto.com/id/177436977/photo/red-wooden-toolbox-with-tools-on-white-background.jpg?s=612x612&w=0&k=20&c=Q6GBCNsA3UquAypB3HJ-Z16bg537Oe1i7-DkynnwTG4=',
              width: 350,
              height: 350,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Bienvenido',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String cityName = '';
  String countryAbbreviation = '';
  String weatherMain = '';
  String weatherDescription = '';
  String weatherIcon = '';
  double temperature = 0.0;

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Santo+Domingo,Dominican+Republic&APPID=2287f61ff3dfa5855c50d1726c3c361c');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        cityName = data['name'];
        countryAbbreviation = data['sys']['country'];
        weatherMain = data['weather'][0]['main'];
        weatherDescription = data['weather'][0]['description'];
        weatherIcon = data['weather'][0]['icon'];
        temperature = (data['main']['temp'] - 273.15); // Convert to Celsius
      });
    } else {
      setState(() {
        cityName = '';
        countryAbbreviation = '';
        weatherMain = '';
        weatherDescription = '';
        weatherIcon = '';
        temperature = 0.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clima'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    countryAbbreviation,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getCountryFlag(countryAbbreviation),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                weatherMain,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Image.network(
                getWeatherIconUrl(weatherIcon),
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 8),
              Text(
                weatherDescription,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ));
  }

  String getCountryFlag(String countryCode) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    final firstChar = countryCode.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = countryCode.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/w/$iconCode.png';
  }
}

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  List<NewsItem> newsItems = [];

  Future<void> fetchNews() async {
    final url = Uri.parse('https://elnuevodiario.com.do/wp-json/wp/v2/posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<NewsItem> fetchedNewsItems = [];

      for (var newsData in data) {
        final title = newsData['yoast_head_json']['title'];
        final description = newsData['yoast_head_json']['og_description'];
        final url = newsData['yoast_head_json']['og_url'];
        final imageUrl = newsData['yoast_head_json']['og_image'][0]['url'];

        final newsItem = NewsItem(
          title: title,
          description: description,
          url: url,
          imageUrl: imageUrl,
        );

        fetchedNewsItems.add(newsItem);
      }

      setState(() {
        newsItems = fetchedNewsItems;
      });
    } else {
      setState(() {
        newsItems = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void openNewsURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final newsItem = newsItems[index];

          return Card(
            child: ListTile(
              leading: Image.network(newsItem.imageUrl),
              title: Text(newsItem.title),
              subtitle: Text(newsItem.description),
              onTap: () {
                openNewsURL(newsItem.url);
              },
            ),
          );
        },
      ),
    );
  }
}

class AboutView extends StatefulWidget {
  final Function(int) onTabTapped;

  const AboutView({super.key, required this.onTabTapped});

  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String username = '';
  String fullName = '';
  String email = '';
  String avatarUrl = '';
  List<String> repositories = [];

  Future<void> fetchGitHubProfile() async {
    const username = 'VictorJThomas'; // Reemplaza con tu nombre de usuario de GitHub
    final url = Uri.parse('https://api.github.com/users/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        this.username = data['login'];
        fullName = data['name'];
        email = data['email'] ?? 'N/A';
        avatarUrl = data['avatar_url'];
      });

      await fetchGitHubRepositories(username);
    } else {
      setState(() {
        this.username = '';
        fullName = '';
        email = '';
        avatarUrl = '';
        repositories = [];
      });
    }
  }

  Future<void> fetchGitHubRepositories(String username) async {
    final url = Uri.parse('https://api.github.com/users/$username/repos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        repositories = data
            .where((repo) =>
                repo['name'] != null) // Filtrar repositorios sin nombre
            .map((repo) =>
                repo['name'] as String) // Asignar nombre del repositorio
            .toList();
      });
    } else {
      setState(() {
        repositories = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGitHubProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Acerca de'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(height: 16),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.message_outlined),
                  const SizedBox(width: 8),
                  Text(email),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Repositorios',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (repositories.isNotEmpty)
                Column(
                  children: repositories
                      .map(
                        (repo) => ListTile(
                          leading: const Icon(Icons.code_sharp),
                          title: Text(repo),
                        ),
                      )
                      .toList(),
                )
              else
                const Text(
                  'No repositories found.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
            ],
          ),
        )));
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 14, 74, 28),
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2, color: Colors.green),
          label: 'Genero',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today, color: Colors.green),
          label: 'Edad',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined, color: Colors.green),
          label: 'Universidades',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled,
              color: Color.fromARGB(255, 22, 67, 30), size: 40),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny, color: Colors.green),
          label: 'Clima',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined, color: Colors.green),
          label: 'Noticias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info, color: Colors.green),
          label: 'Acerca de',
        ),
      ],
      selectedItemColor: Color.fromARGB(255, 1, 22, 8),
    );
  }
}

class University {
  final String name;
  final String domain;
  final String webPage;

  University({
    required this.name,
    required this.domain,
    required this.webPage,
  });
}

class NewsItem {
  final String title;
  final String description;
  final String url;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
  });
}