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
import '../widgets/constant.dart';
import 'memberplancomplete.dart';

class Memberplanaddpayment extends StatefulWidget {
  final BrandMemberPlan brandmemberplan;
  final Brand brand;
  const Memberplanaddpayment({
    required this.brandmemberplan,
    required this.brand,
    super.key,
  });

  @override
  State<Memberplanaddpayment> createState() => _MemberplanaddpaymentState();
}

class _MemberplanaddpaymentState extends State<Memberplanaddpayment> {
  late AuthChangeProvider _authChangeProvider;
  late final WebViewController _controller;
  late bool isLoading = false;
  late Member _member;

  @override
  void initState() {
    super.initState();
    checkislogin();
  }

  Future<void> checkislogin() async {
    setState(() {
      isLoading = true;
    });

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

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

    HttpService httpService = HttpService();
    Response response = await httpService.postsetupintentandcreatesubscription(
      _member.memberid,
      widget.brandmemberplan.brandmemberplanid,
      paymentmethodid,
    );

    var data = json.decode(response.toString());

    if (data["statusCode"] == 200) {
      _authChangeProvider.refreshMember();
      overlayEntry.remove();

      return true;
    } else {
      overlayEntry.remove();

      return false;
    }
  }

  void _onButtonPressed(String paymentmethodid) async {
    TextTheme textTheme = Theme.of(context).textTheme;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        icon: const Icon(
          Icons.payment,
          size: 50,
        ),
        iconColor: primaryColor,
        backgroundColor: whiteColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.brandmemberplan.trialday != null &&
                      widget.brandmemberplan.trialday! > 0
                  ? '${lang.S.of(context).memberplanpaymentConfirmCaption(currencySign, widget.brandmemberplan.price.toStringAsFixed(2), widget.brandmemberplan.plantitle, widget.brandmemberplan.brandtitle!)}\n\n${lang.S.of(context).memberplanpaymentTrialCaption(widget.brandmemberplan.trialday!)}'
                  : lang.S.of(context).memberplanpaymentConfirmCaption(
                        currencySign,
                        widget.brandmemberplan.price.toStringAsFixed(2),
                        widget.brandmemberplan.plantitle,
                        widget.brandmemberplan.brandtitle!,
                      ),
              style: textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              lang.S.of(context).commonBack,
              style: textTheme.titleSmall?.copyWith(
                color: darkColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: darkColor,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              lang.S.of(context).commonConfirm,
              style: textTheme.titleSmall?.copyWith(
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    ).then((dialogresult) async {
      if (dialogresult) {
        bool result = await addprocess(paymentmethodid);

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MemberPlanComplete(
                brandmemberplan: widget.brandmemberplan,
                brand: widget.brand,
                result: result,
              ),
            ),
            (route) => false,
          );
        }
      }
    });
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
