import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
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
  final String _shippingtype = "B";
  final String _ispreorder = "n";

  late WebViewController _controller;
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

    log(json.encode(cartdata));

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
            if (request.url.startsWith('weixin://wap/')) {
              debugPrint('blocking navigation to ${request.url}');
              launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
                webOnlyWindowName: "_self",
              );

              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('alipay://alipayclient/')) {
              debugPrint('blocking navigation to ${request.url}');
              launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
                webOnlyWindowName: "_self",
              );

              return NavigationDecision.prevent;
            }

            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            log(change.url!);
            debugPrint('url change to ${change.url}');
            if (change.url!.contains('AlipayComplete')) {
              _controller.addJavaScriptChannel(
                'Aliresponse',
                onMessageReceived: (JavaScriptMessage message) {
                  log("Ali:${message.message}");
                  _onAliButtonPressed(message.message);
                },
              );
            } else if (change.url!.contains('AsiapaySuccess') ||
                change.url!.contains('AsiapayFail') ||
                change.url!.contains('AsiapayCancel')) {
              _controller.addJavaScriptChannel(
                'WeChatresponse',
                onMessageReceived: (JavaScriptMessage message) {
                  log("WeChat:${message.message}");
                  _onWeChatButtonPressed(message.message);
                },
              );
            }
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Cardresponse',
        onMessageReceived: (JavaScriptMessage message) {
          log("Card:${message.message}");
          _onCardButtonPressed(message.message);
        },
      )
      ..loadRequest(
        Uri.parse(
            'https://www.vetrinamia.com.cn/paymentms/mobilecnpayment?memberid=${_member.memberid}&shippinglocationid=${widget.shippinglocationid}&shippingtype=$_shippingtype&ispreorder=$_ispreorder&amt=$_subtotal'),
      );

    _controller = controller;
  }

  Future<String> cardprocess(String paymentmethodid, String orderid) async {
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
    Response response = await httpService.postchinapayorderdetail(
      cartdata.toJson(),
      _member.memberid,
      orderid,
      paymentmethodid,
    );

    var data = json.decode(response.toString());

    if (data["statusCode"] == 200) {
      overlayEntry.remove();

      return 'succeeded';
    } else {
      overlayEntry.remove();

      return 'fail';
    }
  }

  Future<String> orderprocess(String orderid) async {
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
    Response response = await httpService.postorderdetail(
      cartdata.toJson(),
      orderid,
    );

    var data = json.decode(response.toString());

    if (data["statusCode"] == 200) {
      overlayEntry.remove();

      return 'succeeded';
    } else {
      overlayEntry.remove();

      return 'fail';
    }
  }

  void _onCardButtonPressed(String message) async {
    final Map<String, dynamic> data = jsonDecode(message);
    final String orderid = data['orderid'];
    final String paymentmethodid = data['paymentmethodid'];

    String result = await cardprocess(paymentmethodid, orderid);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(
            orderid: orderid,
            status: result,
          ),
        ),
        (route) => false,
      );
    }
  }

  void _onAliButtonPressed(String message) async {
    final Map<String, dynamic> data = jsonDecode(message);
    final String orderid = data['orderid'];
    final String redirectstatus = data['redirectstatus'];
    final String status = data['status'];

    await orderprocess(orderid);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(
            orderid: orderid,
            status: status,
            redirectstatus: redirectstatus,
          ),
        ),
        (route) => false,
      );
    }
  }

  void _onWeChatButtonPressed(String message) async {
    final Map<String, dynamic> data = jsonDecode(message);
    final String orderid = data['orderid'];
    final String status = data['status'];

    await orderprocess(orderid);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(
            orderid: orderid,
            status: status,
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
