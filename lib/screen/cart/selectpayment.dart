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
import 'cart_provider.dart';

class SelectPayment extends StatefulWidget {
  final String? refer;
  const SelectPayment({
    super.key,
    this.refer,
  });

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  late CartChangeProvider _cartChangeProvider;
  late List<Carts> _carts = [];
  late Member _member;
  late double _subtotal;
  late String _selected = '';

  @override
  void initState() {
    super.initState();
    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    //_member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    _carts = _cartChangeProvider.carts;
    _subtotal = _cartChangeProvider.getSubTotalPrice();
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
            Row(
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  onPressed: () {
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
                      /*launchUrl(
                        Uri.parse(
                            'https://www.vetrinamia.com.cn/paymentms/mobilecnpayment?memberid=${_member.memberid}&shippinglocationid=$_selected&shippingtype=$_shippingtype&ispreorder=$_ispreorder&amt=$_subtotal'),
                        mode: LaunchMode.externalApplication,
                      );*/
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
