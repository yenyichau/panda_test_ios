import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  final String urlLink;
  const HomePage({super.key, required this.urlLink});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double left = 0.0;
  double top = 0.0;
  bool _isLoading = true;
  int _selectedIndex = 0;
  bool _isBottomBarVisible = true;
  double bottomBarHeight = 50;
  double floatingSize = 50;
  double paddingBottom = 120;
  String? _latestUrl;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        left = MediaQuery.sizeOf(context).width - floatingSize - 20;
        top =
            MediaQuery.sizeOf(context).height - bottomBarHeight - paddingBottom;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // content
                webview(),

                // bottom bar
                bottomBar(),

                // floating
                floatingItem(constraints),

                // Loading
                loading(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget loading() {
    if (!_isLoading) {
      return Container();
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget webview() {
    return Positioned.fill(
      bottom: _isBottomBarVisible ? bottomBarHeight : 0,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.urlLink),
          headers: {"User-Agent": "Mozilla/5.0"},
        ),
        onLoadStop: (controller, url) {
          setState(() {
            _isLoading = false;
            _latestUrl ??= url?.toString();
          });
        },
        onLoadStart: (controller, url) {
          setState(() {
            _isLoading = true;
          });
        },
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onReceivedError: (controller, request, error) {
          log("Error loading page: ${error.description}");
        },
        onPermissionRequest: (controller, permissionRequest) async {
          return PermissionResponse(
              resources: permissionRequest.resources,
              action: PermissionResponseAction.GRANT);
        },
      ),
    );
  }

  Widget floatingItem(BoxConstraints constraints) {
    final maxTopPosition =
        constraints.maxHeight - bottomBarHeight - paddingBottom;
    final maxLeftPosition = constraints.maxWidth - floatingSize;
    left = left.clamp(0, maxLeftPosition);
    top = top.clamp(0, maxTopPosition);

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: _handleImageClick,
        onPanUpdate: (details) {
          setState(() {
            setState(() {
              final newLeft =
                  (left + details.delta.dx).clamp(0, maxLeftPosition);
              final newTop = (top + details.delta.dy).clamp(0, maxTopPosition);
              left = newLeft.toDouble();
              top = newTop.toDouble();
            });
          });
        },
        child: Container(
          width: floatingSize,
          height: floatingSize,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(28, 40, 54, 1),
            border: Border.all(
              color: Colors.transparent,
              width: 6,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/icon_home.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return AnimatedPositioned(
      duration:
          const Duration(milliseconds: 0), // Add smooth animation duration
      bottom: _isBottomBarVisible
          ? 0
          : -bottomBarHeight, // Hides the bottom bar smoothly
      left: 0,
      right: 0,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.home, size: 24)),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.arrow_back, size: 24)),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.arrow_forward, size: 24)),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.refresh, size: 24)),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        if (_latestUrl != null) {
          _webViewController.loadUrl(
              urlRequest: URLRequest(url: WebUri(_latestUrl!)));
        }
      } else if (index == 1) {
        _webViewController.goBack();
      } else if (index == 2) {
        _webViewController.goForward();
      } else if (index == 3) {
        _webViewController.reload();
      }
    });
  }

  void _handleImageClick() {
    setState(() {
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }
}
