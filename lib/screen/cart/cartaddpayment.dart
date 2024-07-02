import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/partial.dart';
import 'cart_provider.dart';
import 'complete.dart';

class Cartaddpayment extends StatefulWidget {
  final String shippinglocationid;
  final String ispreorder;

  const Cartaddpayment({
    required this.shippinglocationid,
    required this.ispreorder,
    super.key,
  });

  @override
  State<Cartaddpayment> createState() => _CartaddpaymentState();
}

class _CartaddpaymentState extends State<Cartaddpayment> {
  late final WebViewController _controller;
  late CartChangeProvider _cartChangeProvider;
  late bool isLoading = false;
  late Member _member;
  late double _subtotal;
  late String _orderid = "";

  @override
  void initState() {
    super.initState();

    checkislogin();
  }

  Future<void> checkislogin() async {
    setState(() {
      isLoading = true;
    });

    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    _subtotal = _cartChangeProvider.getSubTotalPrice();

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
              isLoading = false;
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
            'https://vetrinamiahk-frontend.azurewebsites.net/paymentms/addpayment'),
        headers: {
          "memberid": _member.memberid,
        },
      );

    _controller = controller;
  }

  Future<bool> addprocess(String paymentmethodid) async {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const LoadingCircle(),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);

    CartData cartdata = CartData(
      items: _cartChangeProvider.carts,
      subtotal: _subtotal,
    );

    HttpService httpService = HttpService();
    Response response = await httpService.postpaymentintent(
      cartdata.toJson(),
      _member.memberid,
      paymentmethodid,
      widget.shippinglocationid,
      "B",
      widget.ispreorder,
    );

    var data = json.decode(response.toString());
    OrderResponse or = OrderResponse.fromMap(data["data"]);

    if (data["statusCode"] == 200) {
      overlayEntry.remove();
      setState(() {
        _orderid = or.orderid;
      });

      return true;
    } else {
      overlayEntry.remove();
      setState(() {
        _orderid = or.orderid;
      });

      return false;
    }
  }

  void _onButtonPressed(String paymentmethodid) async {
    bool result = await addprocess(paymentmethodid);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(
            orderid: _orderid,
            result: result,
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(
            Icons.close_outlined,
          ),
        ),
        title: Text(
          lang.S.of(context).commonAddPayment,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const LoadingCircle()
          : WebViewWidget(controller: _controller),
    );
  }
}
