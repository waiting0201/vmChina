import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'cart_provider.dart';
import 'complete.dart';

class Payment extends StatefulWidget {
  final String shippinglocationid;
  const Payment({
    required this.shippinglocationid,
    super.key,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final WebViewController _controller;
  late CartChangeProvider _cartChangeProvider;
  late Member _member;
  late double _subtotal;
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkislogin();
  }

  Future<void> checkislogin() async {
    setState(() {
      _isLoading = true;
    });

    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    _subtotal = _cartChangeProvider.getSubTotalPrice();

    CartData cartdata = CartData(
      items: _cartChangeProvider.carts,
      subtotal: _subtotal,
    );

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..clearCache()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
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
            setState(() {
              _isLoading = false;
            });
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
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Paymentresponse',
        onMessageReceived: (JavaScriptMessage message) {
          _onButtonPressed(message.message);
        },
      )
      ..loadRequest(
        Uri.parse(
            'https://vetrinamiahk-frontend.azurewebsites.net/paymentms/mobilecnpayment'),
        headers: {
          "memberid": _member.memberid,
          "platform": "ios",
          "shippinglocationid": widget.shippinglocationid,
          "shippingtype": "B",
          "ispreorder": "n",
          "carts": cartdata.toJson(),
        },
      );

    _controller = controller;
  }

  void _onButtonPressed(String orderid) async {
    //bool result = await addprocess(paymentmethodid);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(
            orderid: orderid,
            result: true,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).paymentTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingCircle()
          : WebViewWidget(controller: _controller),
    );
  }
}
