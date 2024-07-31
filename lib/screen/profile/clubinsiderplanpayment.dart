import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vetrinamia_cn/screen/widgets/extension.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'Clubinsiderplancomplete.dart';

class ClubinsiderPlanPayment extends StatefulWidget {
  final BrandMemberPlan brandmemberplan;
  final Brand brand;
  final String membershipfeedid;
  const ClubinsiderPlanPayment({
    required this.brandmemberplan,
    required this.brand,
    required this.membershipfeedid,
    super.key,
  });

  @override
  State<ClubinsiderPlanPayment> createState() => _ClubinsiderPlanPaymentState();
}

class _ClubinsiderPlanPaymentState extends State<ClubinsiderPlanPayment> {
  final List<MyPaymentMethod> _mypaymentmethods = [];

  late AuthChangeProvider _authChangeProvider;
  late BuildContext _context;
  late Member _member;
  late String _selectedpaymentid = '';
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.brandmemberplan.awid == null ||
        widget.brandmemberplan.awid!.isEmpty) postCreatePrice();

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

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
    _context = context;

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
                : Container(),
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
              child: _selectedpaymentid.isEmpty
                  ? Container()
                  : OutlinedButton(
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
                                  lang.S
                                      .of(context)
                                      .memberplanpaymentConfirmCaption(
                                        widget.brandmemberplan.price.toCNY(),
                                        widget.brandmemberplan.plantitle,
                                        widget.brandmemberplan.brandtitle!,
                                      ),
                                  style: textTheme.titleMedium,
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
                        ).then((value) async {
                          if (value) {
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
                            await httpService
                                .postupdatesubscription(
                              widget.brandmemberplan.brandmemberplanid,
                              widget.membershipfeedid,
                            )
                                .then(
                              (value) {
                                var data = json.decode(value.toString());

                                if (data["statusCode"] == 200) {
                                  _authChangeProvider.refreshMember();
                                  overlayEntry.remove();
                                  Navigator.pushAndRemoveUntil(
                                    _context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ClubinsiderPlanComplete(
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
                                    _context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ClubinsiderPlanComplete(
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
