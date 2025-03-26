import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_view/screens/login.dart';
import 'package:web_view/utils/helpers.dart';
import 'package:web_view/widgets/restart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  loadEnvAndRunApp();
}

Future<void> loadEnvAndRunApp() async {
  await dotenv.load(fileName: ".env");
  runApp(const RestartWidget(child: MaterialApp(home: WebViewExample())));
}

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

const String kLocalExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>

<h1>Local demo page</h1>
<p>
  This is an example page used to demonstrate how to load a local file or HTML
  string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
  webview</a> plugin.
</p>

</body>
</html>
''';

const String kTransparentBackgroundPage = '''
  <!DOCTYPE html>
  <html>
  <head>
    <title>Transparent background test</title>
  </head>
  <style type="text/css">
    body { background: transparent; margin: 0; padding: 0; }
    #container { position: relative; margin: 0; padding: 0; width: 100vw; height: 100vh; }
    #shape { background: red; width: 200px; height: 200px; margin: 0; padding: 0; position: absolute; top: calc(50% - 100px); left: calc(50% - 100px); }
    p { text-align: center; }
  </style>
  <body>
    <div id="container">
      <p>Transparent background test</p>
      <div id="shape"></div>
    </div>
  </body>
  </html>
''';

const String kLogExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body onload="console.log('Logging that the page is loading.')">

<h1>Local demo page</h1>
<p>
  This page is used to test the forwarding of console logs to Dart.
</p>

<style>
    .btn-group button {
      padding: 24px; 24px;
      display: block;
      width: 25%;
      margin: 5px 0px 0px 0px;
    }
</style>

<div class="btn-group">
    <button onclick="console.error('This is an error message.')">Error</button>
    <button onclick="console.warn('This is a warning message.')">Warning</button>
    <button onclick="console.info('This is a info message.')">Info</button>
    <button onclick="console.debug('This is a debug message.')">Debug</button>
    <button onclick="console.log('This is a log message.')">Log</button>
</div>

</body>
</html>
''';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _loginLoader = false;

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
    // _initializeController();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? referenceAuthId = prefs.getString('referenceAuthId');
    String? mobile = prefs.getString('mobile');

    if (referenceAuthId != null && mobile != null) {
      await fetchUrlAndLoadWebView(referenceAuthId, mobile);
    } else {
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  Future<WebViewController> loadPageView(String redirectUrl) async {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    if (redirectUrl.isNotEmpty) {
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('blocking navigation to ${request.url}');
                return NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
            onHttpError: (HttpResponseError error) {
              debugPrint(
                  'Error occurred on page: ${error.response?.statusCode}');
            },
            onUrlChange: (UrlChange change) {
              debugPrint('url change to ${change.url}');
            },
            onHttpAuthRequest: (HttpAuthRequest request) {
              // openDialog(request); // Uncomment and implement if needed
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse(redirectUrl));
    }

    if (kIsWeb || !Platform.isMacOS) {
      // controller.setBackgroundColor(const Color(0x80000000));
    }

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    return controller; // Always return the controller
  }

  fetchUrlAndLoadWebView(
    String referenceAuthId,
    String mobile,
  ) async {
    if (referenceAuthId.isEmpty || mobile.isEmpty) {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Please fill all fields'),
            titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _loginLoader = true;
    });

    String username = dotenv.env['USERNAME'] ?? "";
    String password = dotenv.env['PASSWORD'] ?? "";
    String apiKey = dotenv.env['API_KEY'] ?? "";
    String correlationId = generateCorrelationId();
    // generate base64 string using username and password
    final basicAuth = generateBase64Auth(username, password);

    final Uri apiUrl = Uri.parse(
        "https://newgenpartnerapi.heph.in/iam-pos/api/v1/user/auth/partner");

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          // 'x-correlation-id': '1709628185257',
          'x-correlation-id': correlationId,
          'Authorization': 'Basic $basicAuth',
        },
        body: jsonEncode({
          "referenceAuthId": referenceAuthId,
          "mobile": int.parse(mobile),
        }),
      );

      if (response.statusCode == 200) {
        final String? oneTimeToken = response.headers['one-time-token'];
        if (oneTimeToken != null) {
          final String redirectUrl =
              "https://insuranzee.heph.in/ott-pos/login?one-time-token=$oneTimeToken";
          try {
            // save login creds in local storage
            await saveAuthData(referenceAuthId, mobile);

            final controller = await loadPageView(redirectUrl);
            setState(() {
              _controller = controller;
              _loginLoader = false;
              _isLoggedIn = true;
            });
          } catch (e) {
            debugPrint("Failed to initialize WebView: $e");
            setState(() {
              _loginLoader = false; // Handle error case
              _isLoggedIn = false;
            });
          }
        } else {
          debugPrint("No redirect URL found in headers.");
        }
      } else {
        debugPrint("Failed to fetch URL: ${response.statusCode}");
        debugPrint("Error fetching URL: ${response.body}");
        setState(() {
          _isLoading = false;
          _isLoggedIn = false;
          _loginLoader = false;
        });
        return showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error logging you in, Please try again'),
              titleTextStyle:
                  const TextStyle(fontSize: 16, color: Colors.black),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      debugPrint("Error fetching URL: $e");
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
        _loginLoader = false;
      });
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error logging you in, Please try again.'),
            titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> saveAuthData(
    String referenceAuthId,
    String mobile,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('referenceAuthId', referenceAuthId);
    await prefs.setString('mobile', mobile);
  }

  Future<void> clearAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('referenceAuthId');
    await prefs.remove('mobile');
    debugPrint("Auth data cleared successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: _isLoggedIn
          ? AppBar(
              title: const Text('Newgen'),
              actions: <Widget>[
                NavigationControls(webViewController: _controller),
                SampleMenu(webViewController: _controller),
              ],
            )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isLoggedIn
              ? WebViewWidget(controller: _controller)
              : LoginPage(
                  onSubmit: fetchUrlAndLoadWebView, loader: _loginLoader),
      // floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () async {
        final String? url = await _controller.currentUrl();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorited $url')),
          );
        }
      },
      child: const Icon(Icons.favorite),
    );
  }

  Future<void> openDialog(HttpAuthRequest httpRequest) async {
    final TextEditingController usernameTextController =
        TextEditingController();
    final TextEditingController passwordTextController =
        TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  autofocus: true,
                  controller: usernameTextController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: passwordTextController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Explicitly cancel the request on iOS as the OS does not emit new
            // requests when a previous request is pending.
            TextButton(
              onPressed: () {
                httpRequest.onCancel();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                httpRequest.onProceed(
                  WebViewCredential(
                    user: usernameTextController.text,
                    password: passwordTextController.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
  logExample,
  basicAuthentication,
  logout
}

class SampleMenu extends StatelessWidget {
  SampleMenu({
    super.key,
    required this.webViewController,
  });

  final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.showUserAgent:
            _onShowUserAgent();
          case MenuOptions.listCookies:
            _onListCookies(context);
          case MenuOptions.clearCookies:
            _onClearCookies(context);
          case MenuOptions.addToCache:
            _onAddToCache(context);
          case MenuOptions.listCache:
            _onListCache();
          case MenuOptions.clearCache:
            _onClearCache(context);
          case MenuOptions.navigationDelegate:
            _onNavigationDelegateExample();
          case MenuOptions.doPostRequest:
            _onDoPostRequest();
          case MenuOptions.loadLocalFile:
            _onLoadLocalFileExample();
          case MenuOptions.loadFlutterAsset:
            _onLoadFlutterAssetExample();
          case MenuOptions.loadHtmlString:
            _onLoadHtmlStringExample();
          case MenuOptions.transparentBackground:
            _onTransparentBackground();
          case MenuOptions.setCookie:
            _onSetCookie();
          case MenuOptions.logExample:
            _onLogExample();
          case MenuOptions.basicAuthentication:
            _promptForUrl(context);
          case MenuOptions.logout:
            _logoutUser(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.showUserAgent,
        //   child: Text('Show user agent'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.listCookies,
        //   child: Text('List cookies'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.clearCookies,
        //   child: Text('Clear cookies'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.addToCache,
        //   child: Text('Add to cache'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.listCache,
        //   child: Text('List cache'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.clearCache,
        //   child: Text('Clear cache'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.navigationDelegate,
        //   child: Text('Navigation Delegate example'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.doPostRequest,
        //   child: Text('Post Request'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.loadHtmlString,
        //   child: Text('Load HTML string'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.loadLocalFile,
        //   child: Text('Load local file'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.loadFlutterAsset,
        //   child: Text('Load Flutter Asset'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   key: ValueKey<String>('ShowTransparentBackgroundExample'),
        //   value: MenuOptions.transparentBackground,
        //   child: Text('Transparent background example'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.setCookie,
        //   child: Text('Set cookie'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.logExample,
        //   child: Text('Log example'),
        // ),
        // const PopupMenuItem<MenuOptions>(
        //   value: MenuOptions.basicAuthentication,
        //   child: Text('Basic Authentication Example'),
        // ),
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.logout,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout,
                    color: Colors.white, size: 20), // Optional Icon
                SizedBox(width: 8), // Space between icon and text
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onShowUserAgent() {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    return webViewController.runJavaScript(
      'Toaster.postMessage("User Agent: " + navigator.userAgent);',
    );
  }

  Future<void> _onListCookies(BuildContext context) async {
    final String cookies = await webViewController
        .runJavaScriptReturningResult('document.cookie') as String;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Cookies:'),
            _getCookieList(cookies),
          ],
        ),
      ));
    }
  }

  Future<void> _onAddToCache(BuildContext context) async {
    await webViewController.runJavaScript(
      'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added a test entry to cache.'),
      ));
    }
  }

  Future<void> _onListCache() {
    return webViewController.runJavaScript('caches.keys()'
        // ignore: missing_whitespace_between_adjacent_strings
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(BuildContext context) async {
    await webViewController.clearCache();
    await webViewController.clearLocalStorage();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cache cleared.'),
      ));
    }
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  Future<void> _onNavigationDelegateExample() {
    final String contentBase64 = base64Encode(
      const Utf8Encoder().convert(kNavigationExamplePage),
    );
    return webViewController.loadRequest(
      Uri.parse('data:text/html;base64,$contentBase64'),
    );
  }

  Future<void> _onSetCookie() async {
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'httpbin.org',
        path: '/anything',
      ),
    );
    await webViewController.loadRequest(Uri.parse(
      'https://httpbin.org/anything',
    ));
  }

  Future<void> _onDoPostRequest() {
    return webViewController.loadRequest(
      Uri.parse('https://httpbin.org/post'),
      method: LoadRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
  }

  Future<void> _onLoadLocalFileExample() async {
    final String pathToIndex = await _prepareLocalFile();
    await webViewController.loadFile(pathToIndex);
  }

  Future<void> _onLoadFlutterAssetExample() {
    return webViewController.loadFlutterAsset('assets/www/index.html');
  }

  Future<void> _onLoadHtmlStringExample() {
    return webViewController.loadHtmlString(kLocalExamplePage);
  }

  Future<void> _onTransparentBackground() {
    return webViewController.loadHtmlString(kTransparentBackgroundPage);
  }

  Widget _getCookieList(String cookies) {
    if (cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }

  static Future<String> _prepareLocalFile() async {
    final String tmpDir = (await getTemporaryDirectory()).path;
    final File indexFile = File(
        <String>{tmpDir, 'www', 'index.html'}.join(Platform.pathSeparator));

    await indexFile.create(recursive: true);
    await indexFile.writeAsString(kLocalExamplePage);

    return indexFile.path;
  }

  Future<void> _onLogExample() {
    webViewController
        .setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
      debugPrint(
          '== JS == ${consoleMessage.level.name}: ${consoleMessage.message}');
    });

    return webViewController.loadHtmlString(kLogExamplePage);
  }

  Future<void> _promptForUrl(BuildContext context) {
    final TextEditingController urlTextController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input URL to visit'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'URL'),
            autofocus: true,
            controller: urlTextController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (urlTextController.text.isNotEmpty) {
                  final Uri? uri = Uri.tryParse(urlTextController.text);
                  if (uri != null && uri.scheme.isNotEmpty) {
                    webViewController.loadRequest(uri);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Visit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutUser(BuildContext context) {
    Future<void> clearAuthData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('referenceAuthId');
      await prefs.remove('mobile');
      debugPrint("Auth data cleared successfully.");
    }

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await clearAuthData();
                RestartWidget.restartApp(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}
