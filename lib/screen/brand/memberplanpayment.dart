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
  late AuthChangeProvider _authChangeProvider;
  late Setup _setup;
  late Member _member;
  late bool _isSetupLoading = false;
  late bool _isMembershipFree = false;
  late int _trialdays = 0;

  @override
  void initState() {
    super.initState();

    if (widget.brandmemberplan.awid == null ||
        widget.brandmemberplan.awid!.isEmpty) postCreatePrice();

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

    getSetup();
  }

  Future<void> getSetup() async {
    if (!_isSetupLoading) {
      setState(() {
        _isSetupLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getsetup().then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _setup = Setup.fromMap(data["data"]);
            _isMembershipFree = (_setup.ischargemembershipfee == 0 &&
                DateTime.parse(_setup.freemembershipfeeuntil!)
                        .compareTo(DateTime.now()) >
                    0);
            if (_isMembershipFree) {
              //Duration difference = DateTime.parse(_setup.freemembershipfeeuntil!)
              //.difference(DateTime.now());
              //_trialdays = difference.inDays;
              _trialdays = widget.brandmemberplan.trialday!;
            } else {
              _trialdays = widget.brandmemberplan.trialday!;
            }
            _isSetupLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _isSetupLoading = false;
          });
        }
      });
    }
  }

  Future<void> postCreatePrice() async {
    HttpService httpService = HttpService();
    await httpService.postcreateprice(widget.brandmemberplan.brandmemberplanid);
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
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Center(
                child: Text(
                  _trialdays > 0
                      ? lang.S
                          .of(context)
                          .memberplanpaymentCNTrialCaption(_trialdays)
                      : lang.S.of(context).memberplanpaymentCNCaption(
                          _authChangeProvider.member.email),
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
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
                          : lang.S.of(context).memberplanpaymentConfirmCaption(
                              currencySign,
                              widget.brandmemberplan.price.toStringAsFixed(2),
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
                    .postcreatecnsubscription(
                  _member.memberid,
                  widget.brandmemberplan.brandmemberplanid,
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
