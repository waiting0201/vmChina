import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';

class PreorderSelectPayment extends StatefulWidget {
  final List<Carts> carts;
  final String shippinglocationid;
  final String shippingtype;
  const PreorderSelectPayment({
    super.key,
    required this.carts,
    required this.shippinglocationid,
    required this.shippingtype,
  });

  @override
  State<PreorderSelectPayment> createState() => _PreorderSelectPaymentState();
}

class _PreorderSelectPaymentState extends State<PreorderSelectPayment> {
  late Member _member;
  late double _subtotal;
  late String _selected = '';

  @override
  void initState() {
    super.initState();
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    _subtotal = widget.carts.fold(0, (sum, e) => sum + e.total);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
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
          "支付方式",
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: CartSummary(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
              ),
              child: Text(
                "请选择支付方式",
                style: textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selected = "WECHATONL";
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: whiteColor,
                      side: _selected.isNotEmpty && _selected == "WECHATONL"
                          ? const BorderSide(
                              color: primaryColor,
                              width: 2.5,
                            )
                          : const BorderSide(
                              color: whiteColor,
                            ),
                    ),
                    child: Image.asset(
                      "images/wechatpay.jpg",
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selected = "ALIPAY";
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: whiteColor,
                      side: _selected.isNotEmpty && _selected == "ALIPAY"
                          ? const BorderSide(
                              color: primaryColor,
                              width: 2.5,
                            )
                          : const BorderSide(
                              color: whiteColor,
                            ),
                    ),
                    child: Image.asset(
                      "images/alipay.jpg",
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selected = "CHINAPAY";
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: whiteColor,
                      side: _selected.isNotEmpty && _selected == "CHINAPAY"
                          ? const BorderSide(
                              color: primaryColor,
                              width: 2.5,
                            )
                          : const BorderSide(
                              color: whiteColor,
                            ),
                    ),
                    child: Image.asset(
                      "images/chinapay.jpg",
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_selected.isEmpty) {
                      setState(() {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return const WarnModal(
                              title: 'Alert',
                              message: "请选择支付方式",
                            );
                          },
                        );
                      });
                    } else {
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
                        items: widget.carts,
                        subtotal: _subtotal,
                      );

                      HttpService httpService = HttpService();
                      await httpService
                          .postasiapayorder(
                        cartdata.toJson(),
                        _member.memberid,
                        widget.shippinglocationid,
                        widget.shippingtype,
                        "y",
                      )
                          .then((value) {
                        var data = json.decode(value.toString());

                        if (data["statusCode"] == 200) {
                          overlayEntry.remove();
                          Asiapay pay = Asiapay.fromMap(data["data"]);

                          Uri uri = Uri.parse(
                              '${pay.asiapayurl}?merchantId=${pay.merchantid}&amount=${pay.amt}&orderRef=${pay.ordercode}&currCode=${pay.currcode}&successUrl=${pay.successurl}&failUrl=${pay.failurl}&cancelUrl=${pay.cancelurl}&payType=N&lang=X&payMethod=$_selected&secureHash=${pay.securehash}');
                          launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          overlayEntry.remove();
                        }
                      });
                    }
                  },
                  label: Text(
                    "提交",
                    style: textTheme.titleSmall?.copyWith(
                      color: whiteColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
