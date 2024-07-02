import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../screen/authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import 'addwpayment.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final List<MyPaymentMethod> _mypaymentmethods = [];

  late bool _isLoading = false;
  late Member _member;

  @override
  void initState() {
    super.initState();

    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    getMyPaymentMethods();
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

  void _onButtonPressed(int index) async {
    MyPaymentMethod paymentmethod = _mypaymentmethods[index];

    HttpService httpService = HttpService();
    await httpService.deletepaymentmethod(paymentmethod.paymentmethodid);
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

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
          lang.S.of(context).meWallet,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingCircle()
          : _mypaymentmethods.isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.wallet,
                              color: primaryColor,
                              size: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Center(
                            child: Text(
                              lang.S.of(context).walletTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Text(
                            lang.S.of(context).walletCaption,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListView.separated(
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
                              Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: lightGreyTextColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.only(
                              top: 6.0,
                              bottom: 6.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  _mypaymentmethods[index].brand.toUpperCase(),
                                  style: textTheme.bodyMedium,
                                ),
                                Text(
                                  '****-****-****-${_mypaymentmethods[index].cardlast4}',
                                  style: textTheme.bodyMedium,
                                ),
                                Text(
                                  '${_mypaymentmethods[index].expmonth}/${_mypaymentmethods[index].expyear}',
                                  style: textTheme.bodyMedium,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: whiteColor,
                                          title: Text(
                                            lang.S.of(context).walletAreyousure,
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              color: primaryColor,
                                            ),
                                          ),
                                          content: Text(
                                            lang.S
                                                .of(context)
                                                .walletAreyousureCaption,
                                            style: textTheme.titleSmall,
                                          ),
                                          actions: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                width: 1.0,
                                                color: primaryColor,
                                              )),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                lang.S.of(context).commonCancel,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                _onButtonPressed(index);
                                                setState(() {
                                                  _mypaymentmethods
                                                      .removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                lang.S
                                                    .of(context)
                                                    .commonConfirm,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete_outline_sharp),
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          child: Text(
                            lang.S.of(context).walletAddCard,
                            style: textTheme.titleSmall?.copyWith(
                              color: whiteColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Addwpayment(),
                              ),
                            ).then((value) {
                              if (value) {
                                setState(() {
                                  _mypaymentmethods.clear();
                                });
                                getMyPaymentMethods();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconlyLight.wallet,
                        size: 100,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                        ),
                        child: Text(
                          lang.S.of(context).walletEmptyCaption,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: Text(
                          lang.S.of(context).walletAddCard,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Addwpayment(),
                            ),
                          ).then((value) {
                            if (value) {
                              setState(() {
                                _mypaymentmethods.clear();
                              });

                              getMyPaymentMethods();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
