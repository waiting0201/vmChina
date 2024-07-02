import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Clubinsiderchangeplan extends StatefulWidget {
  final Brand brand;
  final String membershipfeeid;
  const Clubinsiderchangeplan({
    super.key,
    required this.brand,
    required this.membershipfeeid,
  });

  @override
  State<Clubinsiderchangeplan> createState() => _ClubinsiderchangeplanState();
}

class _ClubinsiderchangeplanState extends State<Clubinsiderchangeplan> {
  late AuthChangeProvider _authChangeProvider;
  late Member _member;
  late BrandMemberPlan _plan1;
  late BrandMemberPlan _plan2;
  late BrandMemberPlan _plan3;
  late bool _isLoading = false;
  late double _totalspend = 0;

  @override
  void initState() {
    super.initState();
    _plan1 = widget.brand.brandmemberplans[0];
    _plan2 = widget.brand.brandmemberplans[1];
    _plan3 = widget.brand.brandmemberplans[2];

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);

    if (_authChangeProvider.status) {
      _member = _authChangeProvider.member;
      getTotalSpend();
    }
  }

  Future<void> getTotalSpend() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .gettotalspendbybrandidandmemberid(
              widget.brand.brandid, _member.memberid)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200) {
          setState(() {
            _totalspend = data["data"];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
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

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        centerTitle: true,
        title: Text(
          widget.brand.title,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).memberplanPricing,
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
                lang.S.of(context).memberplanCaption(widget.brand.title),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: verticalSpace,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Card(
                surfaceTintColor: whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          _plan1.plantitle,
                          style: textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$currencySign${_plan1.price}',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' / ${lang.S.of(context).commonPerMonth}',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 50,
                        right: 50,
                      ),
                      child: Center(
                        child: Text(
                          lang.S.of(context).memberplanPlan1Caption,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Center(
                        child: Text(
                          '${lang.S.of(context).memberplanPlan1Include(_plan1.plantitle)}:',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        children: [
                          _plan1.trialday! != 0 && _plan1.trialday != null
                              ? Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      margin: const EdgeInsets.only(right: 8),
                                    ),
                                    Expanded(
                                      child: Text(
                                        lang.S.of(context).memberplanPlan1Trial(
                                            _plan1.trialday.toString()),
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan1Discount(
                                      _plan1.plantitle),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan1Allow,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      child: Center(
                        child: ClubinsiderPlanSubscribeButton(
                          brand: widget.brand,
                          plan: _plan1,
                          membershipfeeid: widget.membershipfeeid,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 15,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Card(
                surfaceTintColor: whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          _plan2.plantitle,
                          style: textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$currencySign${_plan2.price}',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' / ${lang.S.of(context).commonPerMonth}',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 50,
                        right: 50,
                      ),
                      child: Center(
                        child: Text(
                          lang.S.of(context).memberplanPlan2Caption,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Center(
                        child: Text(
                          '${lang.S.of(context).memberplanPlan2Include(_plan2.plantitle)}:',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        children: [
                          _plan2.trialday! != 0 && _plan2.trialday != null
                              ? Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      margin: const EdgeInsets.only(right: 8),
                                    ),
                                    Expanded(
                                      child: Text(
                                        lang.S.of(context).memberplanPlan2Trial(
                                            _plan2.trialday.toString()),
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S
                                      .of(context)
                                      .memberplanPlan2Rule1(_plan1.plantitle),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan2Rule2(
                                      currencySign, _plan2.totalspend),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan2Discount(
                                      _plan2.plantitle),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan2Allow,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan2Invited,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      child: Center(
                        child: ClubinsiderPlanSubscribeButton(
                          brand: widget.brand,
                          plan: _plan2,
                          membershipfeeid: widget.membershipfeeid,
                          totalspend: _totalspend,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 15,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Card(
                surfaceTintColor: whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          _plan3.plantitle,
                          style: textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$currencySign${_plan3.price}',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' / ${lang.S.of(context).commonPerMonth}',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 50,
                        right: 50,
                      ),
                      child: Center(
                        child: Text(
                          lang.S.of(context).memberplanPlan3Caption,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Center(
                        child: Text(
                          '${lang.S.of(context).memberplanPlan3Include(_plan3.plantitle)}:',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        children: [
                          _plan3.trialday! != 0 && _plan3.trialday != null
                              ? Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      margin: const EdgeInsets.only(right: 8),
                                    ),
                                    Expanded(
                                      child: Text(
                                        lang.S.of(context).memberplanPlan3Trial(
                                            _plan3.trialday.toString()),
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan3Discount(
                                      _plan3.plantitle),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan3Allow,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).memberplanPlan3Invited,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                              Expanded(
                                child: Text(
                                  lang.S
                                      .of(context)
                                      .memberplanPlan3AllowJustforyou,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      child: Center(
                        child: ClubinsiderPlanSubscribeButton(
                          brand: widget.brand,
                          plan: _plan3,
                          membershipfeeid: widget.membershipfeeid,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: verticalSpace,
            ),
          ],
        ),
      ),
    );
  }
}
