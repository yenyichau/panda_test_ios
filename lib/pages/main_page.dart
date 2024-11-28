import 'package:test_ios/imports.dart';
import 'game_page.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? urlLink;

  @override
  void initState() {
    super.initState();

    setInit();
  }

  @override
  Widget build(BuildContext context) {
    return urlLink == null
        ? loading()
        : urlLink!.isEmpty
            ? const GamePage()
            : HomePage(urlLink: urlLink!);
  }

  Widget loading() {
    return const SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> setInit() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://6703907dab8a8f892730a6d2.mockapi.io/api/v1/elementalmatch'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final bool isOn = data[0]['is_on'] ?? false;
          final String url = data[0]['url'] ?? '';

          if (isOn && await isValidUrl(url)) {
            urlLink = url;
          } else {
            urlLink = "";
          }
        }
      } else {
        urlLink = "";
      }
    } catch (e) {
      urlLink = "";
    }

    setState(() {});
  }

  Future<bool> isValidUrl(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !['http', 'https'].contains(uri.scheme)) {
        return false;
      }

      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }
}
