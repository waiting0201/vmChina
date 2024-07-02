import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'cartaddpayment.dart';
import 'complete.dart';

class Preorderpayment extends StatefulWidget {
  final List<Carts> carts;
  final String shippinglocationid;
  const Preorderpayment({
    required this.carts,
    required this.shippinglocationid,
    super.key,
  });

  @override
  State<Preorderpayment> createState() => _PreorderpaymentState();
}

class _PreorderpaymentState extends State<Preorderpayment> {
  final List<MyPaymentMethod> _mypaymentmethods = [];

  late Member _member;
  late double _subtotal;
  late String _selectedpaymentid = '';
  late bool _isPaying = false;
  late bool _isLoading = false;
  late String _orderid = "";

  @override
  void initState() {
    super.initState();

    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    _subtotal = widget.carts.fold(0, (sum, e) => sum + e.total);

    if (_member.awid != null) {
      getMyPaymentMethods();
    }
  }

  Future<void> getMyPaymentMethods() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpService httpService = HttpService();
    await httpService.getpaymentmethodbyawid(_member.awid!).then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200) {
        setState(() {
          _mypaymentmethods.addAll((data["data"] as List)
              .map((e) => MyPaymentMethod.fromMap(e))
              .toList());
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<bool> payprocess() async {
    if (mounted) {
      setState(() {
        _isPaying = true;
      });
    }

    log('payprocess');

    CartData cartdata = CartData(
      items: widget.carts,
      subtotal: _subtotal,
    );

    HttpService httpService = HttpService();
    Response response = await httpService.postpaymentintent(
      cartdata.toJson(),
      _member.memberid,
      _selectedpaymentid,
      widget.shippinglocationid,
      "B",
      "y",
    );

    var data = json.decode(response.toString());
    OrderResponse or = OrderResponse.fromMap(data["data"]);

    if (data["statusCode"] == 200) {
      if (mounted) {
        setState(() {
          _orderid = or.orderid;
          _isPaying = false;
        });
      }

      return true;
    } else {
      if (mounted) {
        setState(() {
          _orderid = or.orderid;
          _isPaying = false;
        });
      }

      return false;
    }
  }

  void _onButtonPressed() async {
    bool result = await payprocess();

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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).preorderpaymentTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: PreorderSummary(
            carts: widget.carts,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingCircle(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_mypaymentmethods.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: horizonSpace,
                        right: horizonSpace,
                      ),
                      child: Text(
                        lang.S.of(context).preorderpaymentPayment,
                        style: textTheme.titleLarge,
                      ),
                    ),
                  !_isLoading && _mypaymentmethods.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _mypaymentmethods.length,
                          itemBuilder: (BuildContext context, int index) =>
                              InkWell(
                            onTap: () {
                              setState(() {
                                _selectedpaymentid =
                                    _mypaymentmethods[index].paymentmethodid;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedpaymentid ==
                                          _mypaymentmethods[index]
                                              .paymentmethodid
                                      ? primaryColor
                                      : lightGreyTextColor,
                                  width: _selectedpaymentid ==
                                          _mypaymentmethods[index]
                                              .paymentmethodid
                                      ? 2.5
                                      : 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.only(
                                top: 12.0,
                                bottom: 12.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _mypaymentmethods[index]
                                        .brand
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: _selectedpaymentid ==
                                              _mypaymentmethods[index]
                                                  .paymentmethodid
                                          ? primaryColor
                                          : lightGreyTextColor,
                                    ),
                                  ),
                                  Text(
                                    '****-****-****-${_mypaymentmethods[index].cardlast4}',
                                    style: TextStyle(
                                      color: _selectedpaymentid ==
                                              _mypaymentmethods[index]
                                                  .paymentmethodid
                                          ? primaryColor
                                          : lightGreyTextColor,
                                    ),
                                  ),
                                  Text(
                                    '${_mypaymentmethods[index].expmonth}/${_mypaymentmethods[index].expyear}',
                                    style: TextStyle(
                                      color: _selectedpaymentid ==
                                              _mypaymentmethods[index]
                                                  .paymentmethodid
                                          ? primaryColor
                                          : lightGreyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 50,
                                  right: 50,
                                ),
                                child: Text(
                                  lang.S
                                      .of(context)
                                      .preorderpaymentEmptyCaption,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                child: Text(
                                  lang.S.of(context).commonAddPayment,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: whiteColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Cartaddpayment(
                                        shippinglocationid:
                                            widget.shippinglocationid,
                                        ispreorder: "y",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _mypaymentmethods.isEmpty
          ? Container()
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: horizonSpace,
              ),
              width: MediaQuery.of(context).size.width,
              child: _isPaying
                  ? const LoadingCircle()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkColor,
                      ),
                      child: Text(
                        lang.S.of(context).commonConfirm,
                        style: textTheme.titleSmall?.copyWith(
                          color: whiteColor,
                        ),
                      ),
                      onPressed: () {
                        _onButtonPressed();
                      },
                    ),
            ),
    );
  }
}
