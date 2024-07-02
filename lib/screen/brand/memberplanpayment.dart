import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../../model/repository.dart';
import '../home/setup_provider.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'memberplanaddpayment.dart';
import 'memberplancomplete.dart';

class MemberPlanPayment extends StatefulWidget {
  final BrandMemberPlan brandmemberplan;
  final Brand brand;
  const MemberPlanPayment({
    required this.brandmemberplan,
    required this.brand,
    super.key,
  });

  @override
  State<MemberPlanPayment> createState() => _MemberPlanPaymentState();
}

class _MemberPlanPaymentState extends State<MemberPlanPayment> {
  final List<MyPaymentMethod> _mypaymentmethods = [];

  late SetupChangeProvider _setupChangeProvider;
  late AuthChangeProvider _authChangeProvider;
  late Setup _setup;
  late Member _member;
  late String _selectedpaymentid = '';
  late bool _isMembershipFree = false;
  late bool _isLoading = false;
  late int _trialdays = 0;

  @override
  void initState() {
    super.initState();

    if (widget.brandmemberplan.awid == null ||
        widget.brandmemberplan.awid!.isEmpty) postCreatePrice();

    _setupChangeProvider =
        Provider.of<SetupChangeProvider>(context, listen: false);
    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

    if (!_setupChangeProvider.isloading) {
      setState(() {
        _setup = _setupChangeProvider.setup;
        _isMembershipFree = (_setup.ischargemembershipfee == 0 &&
            DateTime.parse(_setup.freemembershipfeeuntil!)
                    .compareTo(DateTime.now()) >
                0);
        if (_isMembershipFree) {
          Duration difference = DateTime.parse(_setup.freemembershipfeeuntil!)
              .difference(DateTime.now());
          _trialdays = difference.inDays;
        } else {
          _trialdays = widget.brandmemberplan.trialday!;
        }
      });
    }

    if (_authChangeProvider.status && _member.awid != null) {
      getMyPaymentMethods();
    }
  }

  Future<void> postCreatePrice() async {
    HttpService httpService = HttpService();
    await httpService.postcreateprice(widget.brandmemberplan.brandmemberplanid);
  }

  Future<void> getMyPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });
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
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).memberplanpaymentTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_mypaymentmethods.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Text(
                  lang.S.of(context).memberplanpaymentPayment,
                  style: textTheme.titleLarge,
                ),
              ),
            !_isLoading && _mypaymentmethods.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mypaymentmethods.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: itemSpace,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedpaymentid ==
                                    _mypaymentmethods[index].paymentmethodid
                                ? primaryColor
                                : lightGreyTextColor,
                            width: _selectedpaymentid ==
                                    _mypaymentmethods[index].paymentmethodid
                                ? 2.5
                                : 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedpaymentid =
                                  _mypaymentmethods[index].paymentmethodid;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _mypaymentmethods[index].brand.toUpperCase(),
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
                            lang.S.of(context).memberplanpaymentEmptyCaption,
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
                                builder: (context) => Memberplanaddpayment(
                                  brandmemberplan: widget.brandmemberplan,
                                  brand: widget.brand,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
            if (_mypaymentmethods.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: ElevatedButton(
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
                          builder: (context) => Memberplanaddpayment(
                            brandmemberplan: widget.brandmemberplan,
                            brand: widget.brand,
                          ),
                        ),
                      );
                    },
                  ),
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
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: darkColor,
                ),
                child: Text(
                  lang.S.of(context).commonSubmit,
                  style: textTheme.titleSmall?.copyWith(
                    color: whiteColor,
                  ),
                ),
                onPressed: () {
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
                            _trialdays > 0
                                ? '${lang.S.of(context).memberplanpaymentConfirmCaption(currencySign, widget.brandmemberplan.price.toStringAsFixed(2), widget.brandmemberplan.plantitle, widget.brandmemberplan.brandtitle!)}\n\n${lang.S.of(context).memberplanpaymentTrialCaption(_trialdays)}'
                                : lang.S
                                    .of(context)
                                    .memberplanpaymentConfirmCaption(
                                        currencySign,
                                        widget.brandmemberplan.price
                                            .toStringAsFixed(2),
                                        widget.brandmemberplan.plantitle,
                                        widget.brandmemberplan.brandtitle!),
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
                  ).then((dialogresult) {
                    if (dialogresult) {
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
                      httpService
                          .postcreatesubscription(
                        _member.memberid,
                        widget.brandmemberplan.brandmemberplanid,
                        _selectedpaymentid,
                      )
                          .then(
                        (value) {
                          var data = json.decode(value.toString());

                          if (data["statusCode"] == 200) {
                            _authChangeProvider.refreshMember();
                            overlayEntry.remove();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberPlanComplete(
                                  brandmemberplan: widget.brandmemberplan,
                                  brand: widget.brand,
                                  result: true,
                                ),
                              ),
                              (route) => false,
                            );
                          } else {
                            overlayEntry.remove();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemberPlanComplete(
                                  brandmemberplan: widget.brandmemberplan,
                                  brand: widget.brand,
                                  result: false,
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      );
                    }
                  });
                },
              ),
            ),
    );
  }
}
