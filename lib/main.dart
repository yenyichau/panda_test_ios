import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_ios/game_page.dart';
import 'package:test_ios/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? urlLink;

  @override
  void initState() {
    super.initState();

    setInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: urlLink == null
          ? loading()
          : urlLink!.isEmpty
              ? const GamePage()
              : HomePage(urlLink: urlLink!),
      // home: urlLink != null ? HomePage(urlLink: urlLink!) : const SizedBox(),
    );
  }

  Widget loading() {
    return const SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
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
