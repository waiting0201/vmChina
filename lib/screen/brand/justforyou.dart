import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import '../brand/memberplan.dart';
import 'justforyoudetail.dart';

class Justforyous extends StatefulWidget {
  final Brand brand;
  const Justforyous({
    super.key,
    required this.brand,
  });

  @override
  State<Justforyous> createState() => _JustforyousState();
}

class _JustforyousState extends State<Justforyous> {
  final List<Justforyou> _justforyous = [];
  final int _take = 10;

  late bool _isJustforyouLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();
    getJustforyous();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getJustforyous() async {
    if (_hasMore && !_isJustforyouLoading) {
      setState(() {
        _isJustforyouLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getjustforyoulistsbybrandid(widget.brand.brandid, _skip, _take, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getjustforyous code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _justforyous.addAll((data["data"] as List)
                .map((e) => Justforyou.fromMap(e))
                .toList());
            _skip = _skip + _take;
            _isJustforyouLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            log('getjustforyous isloading: $_isJustforyouLoading');
            log('getjustforyous skip: $_skip');
          });
        } else if (mounted) {
          setState(() {
            _isJustforyouLoading = false;
            _hasMore = false;

            log('getjustforyous isloading');
          });
        }
      });
    }
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
        automaticallyImplyLeading: true,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        centerTitle: true,
        title: Text(
          lang.S.of(context).justforyouTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: [
          BrandFavoriteIcon(
            brandid: widget.brand.brandid,
          ),
          const CartIcon(),
        ],
      ),
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ),
            child: BrandMenu(
              brand: widget.brand,
            ),
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
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).justforyouTitle,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 50,
                right: 50,
              ),
              child: Text(
                lang.S.of(context).justforyouCaption,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  //load more here
                  getJustforyous();
                }
                return false;
              },
              child: ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.only(
                  top: verticalSpace,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount:
                    _hasMore ? _justforyous.length + 1 : _justforyous.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= _justforyous.length) {
                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: shimmerbaseColor,
                        highlightColor: shimmerhilightColor,
                        child: AspectRatio(
                          aspectRatio: 3 / 4, // 16:9 aspect ratio
                          child: Container(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    );
                  }
                  return Consumer<AuthChangeProvider>(
                    builder: (context, auth, child) {
                      bool isbrandmember = auth.status &&
                          auth.member.membershipfees!.isNotEmpty &&
                          auth.member.membershipfees!.any((e) =>
                              e.brandmemberplan!.brandid ==
                              widget.brand.brandid);

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: itemSpace,
                        ),
                        child: InkWell(
                          onTap: () {
                            if (!auth.status) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogIn(),
                                ),
                              );
                            } else {
                              if (isbrandmember) {
                                late MembershipFee membershipfee = auth
                                    .member.membershipfees!
                                    .singleWhere((e) =>
                                        e.brandmemberplan!.brandid ==
                                        widget.brand.brandid);
                                if (membershipfee.brandmemberplan!.plantitle ==
                                    'VIP') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Justforyoudetail(
                                        justforyou: _justforyous[index],
                                      ),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: whiteColor,
                                          title: Text(lang.S
                                              .of(context)
                                              .justforyouNotifyTitle),
                                          content: Text(lang.S
                                              .of(context)
                                              .justforyouNotifyCaption),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                lang.S.of(context).commonExit,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                        color: darkColor),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                }
                              } else {
                                setState(() {
                                  showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        icon: const Icon(
                                          IconlyLight.addUser,
                                          size: 50,
                                        ),
                                        iconColor: primaryColor,
                                        backgroundColor: whiteColor,
                                        title: Text(lang.S
                                            .of(context)
                                            .justforyouNotifyTitle),
                                        content: Text(
                                          lang.S
                                              .of(context)
                                              .justforyouNotifyCaption,
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MemberPlan(
                                                    brand: widget.brand,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                              side: const BorderSide(
                                                color: primaryColor,
                                              ),
                                            ),
                                            child: const Icon(
                                              IconlyLight.addUser,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              lang.S.of(context).commonExit,
                                              style: textTheme.titleSmall
                                                  ?.copyWith(color: darkColor),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            }
                          },
                          child: ImageStackCard(
                            url: _justforyous[index].portraiturl!,
                            title: _justforyous[index].title,
                            subtitle: _justforyous[index].subtitle,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
      floatingActionButton: MemberPlanIcon(
        brand: widget.brand,
      ),
    );
  }
}
