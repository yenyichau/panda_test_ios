import 'dart:developer';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tap_challenge_ios/components/inkwell_wrapper.dart';

import '../imports.dart';

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
  bool _isBottomBarVisible = true;
  double floatingSize = 50.fh;
  double paddingBottom = 100.fh;
  double paddingHorizontal = 10.fw;
  double bottomBarHeight = kToolbarHeight.fh;
  String? _latestUrl;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        left = AppSize.width - floatingSize - paddingHorizontal;
        top = AppSize.height - bottomBarHeight - paddingBottom;
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
            borderRadius: BorderRadius.circular(10).r,
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
    double iconSize = 25.fh;

    return Positioned(
      bottom: _isBottomBarVisible ? 0 : -bottomBarHeight,
      left: 0,
      right: 0,
      height: bottomBarHeight,
      child: Container(
        color: Colors.black,
        child: Row(
          children: [
            // 1
            Expanded(
              child: InkWellWrapper(
                hapticEnabled: true,
                onTap: () {
                  if (_latestUrl != null) {
                    _webViewController.loadUrl(
                        urlRequest: URLRequest(url: WebUri(_latestUrl!)));
                  }
                },
                child: Icon(
                  Icons.home,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ),

            // 2
            Expanded(
              child: InkWellWrapper(
                hapticEnabled: true,
                onTap: () {
                  _webViewController.goBack();
                },
                child: Icon(
                  Icons.arrow_back,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ),

            // 3
            Expanded(
              child: InkWellWrapper(
                hapticEnabled: true,
                onTap: () {
                  _webViewController.goForward();
                },
                child: Icon(
                  Icons.arrow_forward,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ),

            // 4
            Expanded(
              child: InkWellWrapper(
                hapticEnabled: true,
                onTap: () {
                  _webViewController.reload();
                },
                child: Icon(
                  Icons.refresh,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleImageClick() {
    setState(() {
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }
}
