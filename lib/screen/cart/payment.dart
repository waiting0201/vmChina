import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

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
  //final String shippinglocationid;
  const Payment({
    //required this.shippinglocationid,
    super.key,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _fluwx = fluwx.Fluwx();

  late final WebViewController _controller;
  late CartChangeProvider _cartChangeProvider;
  late Member _member;
  late double _subtotal;
  late String _orderid = "";
  late bool _isLoading = false;
  late bool _isWeChatPaying = false;
  late Function(fluwx.WeChatResponse) responseListener;

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
    //_member = Provider.of<AuthChangeProvider>(context, listen: false).member;
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
            }
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Cardresponse',
        onMessageReceived: (JavaScriptMessage message) {
          log("Card:${message.message}");
          //_onCardButtonPressed(message.message);
        },
      )
      ..addJavaScriptChannel(
        'WeChatresponse',
        onMessageReceived: (JavaScriptMessage message) {
          log("WeChat:");
          //_onWeChatButtonPressed(message.message);
        },
      )
      ..loadRequest(
        Uri.parse(
            'https://vetrinamiahk-frontend.azurewebsites.net/paymentms/mobilecnpayment'),
        headers: {
          //"memberid": _member.memberid,
          //"shippinglocationid": widget.shippinglocationid,
          //"shippingtype": "B",
          //"ispreorder": "n",
          //"carts": cartdata.toJson(),
        },
      );

    _controller = controller;
  }

  /*Future<String> cardprocess(String paymentmethodid) async {
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
      "n",
    );

    var data = json.decode(response.toString());
    OrderResponse or = OrderResponse.fromMap(data["data"]);

    if (data["statusCode"] == 200) {
      overlayEntry.remove();
      setState(() {
        _orderid = or.orderid;
      });

      return 'succeeded';
    } else {
      overlayEntry.remove();
      setState(() {
        _orderid = or.orderid;
      });

      return 'failed';
    }
  }

  void _onCardButtonPressed(String paymentmethodid) async {
    String result = await cardprocess(paymentmethodid);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Complete(
            orderid: _orderid,
            status: result,
          ),
        ),
        (route) => false,
      );
    }
  }*/

  void _onAliButtonPressed(String message) async {
    if (mounted) {
      final Map<String, dynamic> data = jsonDecode(message);
      final String orderid = data['orderid'];
      final String redirectstatus = data['redirectstatus'];
      final String status = data['status'];

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
    if (mounted) {
      setState(() {
        _isWeChatPaying = true;
      });
    }

    responseListener = (res) {
      if (res is fluwx.WeChatPaymentResponse) {
        if (res.isSuccessful) {
          setState(() {
            _isWeChatPaying = false;
          });

          /*_authChangeProvider.wechatBinding(res.code!).then((value) {
            if (value != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WechatEmail(
                    name: value.nickname,
                    unionid: value.unionid,
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          });*/
        } else {
          setState(() {
            _isWeChatPaying = false;
          });
        }
      } else {
        setState(() {
          _isWeChatPaying = false;
        });
      }
    };
    _fluwx.addSubscriber(responseListener);

    /*_fluwx.pay(
        which: fluwx.Payment(
      appId: result['appid'].toString(),
      partnerId: result['partnerid'].toString(),
      prepayId: result['prepayid'].toString(),
      packageValue: result['package'].toString(),
      nonceStr: result['noncestr'].toString(),
      timestamp: result['timestamp'],
      sign: result['sign'].toString(),
    ));*/
  }

  @override
  void dispose() {
    super.dispose();
    _fluwx.removeSubscriber(responseListener);
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
