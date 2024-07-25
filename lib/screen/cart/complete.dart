import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../profile/orderdetail.dart';
import '../home/home.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'cart_provider.dart';

class Complete extends StatefulWidget {
  final String orderid;
  final String status;
  final String? redirectstatus;
  const Complete({
    required this.orderid,
    required this.status,
    this.redirectstatus,
    super.key,
  });

  @override
  State<Complete> createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  late CartChangeProvider _cartChangeProvider;
  late Member _member;
  late Order _order;
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;

    CartData cartdata = CartData(
      items: _cartChangeProvider.carts,
      subtotal: _cartChangeProvider.getSubTotalPrice(),
    );

    HttpService httpService = HttpService();
    httpService.postorderdetail(
      cartdata.toJson(),
      widget.orderid,
    );

    getorder();
  }

  Future<void> getorder() async {
    if (!_isLoading && mounted) {
      _isLoading = true;
    }

    HttpService httpService = HttpService();
    Response response = await httpService.getorderbyorderid(widget.orderid);
    var data = json.decode(response.toString());
    if (data["statusCode"] == 200) {
      setState(() {
        _order = Order.fromMap(data["data"]);
        _isLoading = false;
      });
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

    _cartChangeProvider.clearCart();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).paymentcompleteTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? Container()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _isLoading
                          ? Container()
                          : widget.status == 'succeeded'
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 100.0,
                                )
                              : const Icon(Icons.warning_rounded,
                                  color: Colors.amber, size: 100.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: verticalSpace,
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        child: Text(
                          _isLoading
                              ? ''
                              : widget.status == 'succeeded'
                                  ? lang.S.of(context).paymentcompleteSucceeded
                                  : lang.S.of(context).paymentcompleteWrong,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        child: Text(
                          _isLoading
                              ? ''
                              : widget.status == 'succeeded'
                                  ? 'Thank you ${_member.firstname}.\n${lang.S.of(context).paymentcompleteSucceededCaption}'
                                  : 'Sorry ${_member.firstname}. ${lang.S.of(context).paymentcompleteWrongCaption}',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: lightGreyTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Orderdetail(
                                order: _order,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          lang.S.of(context).paymentcompleteViewOrder,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: whiteColor,
                          side: const BorderSide(
                            color: darkColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          lang.S.of(context).paymentcompleteContinue,
                          style: textTheme.titleSmall?.copyWith(
                            color: darkColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(verticalSpace),
                          width: double.infinity,
                          color: bggray100,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    lang.S.of(context).paymentcompleteOrderNo,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      _order.ordercode,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: verticalSpace),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        lang.S
                                            .of(context)
                                            .paymentcompleteOrderDate,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Text(
                                          _order.orderdate,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        lang.S.of(context).paymentcompleteTotal,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: ExchangePrice(
                                          price: _order.totalprice +
                                              _order.freight,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
