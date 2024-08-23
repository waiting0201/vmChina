import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../home/home.dart';
import '../authentication/auth_provider.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';

class Clubinsider extends StatefulWidget {
  const Clubinsider({super.key});

  @override
  State<Clubinsider> createState() => _ClubinsiderState();
}

class _ClubinsiderState extends State<Clubinsider> {
  final List<MembershipFee> _membershipfees = [];
  final int _take = 10;

  late AuthChangeProvider _authChangeProvider;
  late Setup _setup;
  late Member _member;
  late bool _isSetupLoading = false;
  late bool _isMembershipFree = true;
  late bool _isLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

    getSetup();
    getMembershipFees();
  }

  Future<void> getSetup() async {
    if (!_isSetupLoading && mounted) {
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

  Future<void> getMembershipFees() async {
    if (_hasMore && !_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getmembershipfeelists(_member.memberid, _skip, _take, null)
          .then((value) {
        var data = json.decode(value.toString());

        debugPrint('getmembershipfees code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _membershipfees.addAll((data["data"] as List)
                .map((e) => MembershipFee.fromMap(e))
                .toList());
            _skip = _skip + _take;
            _isLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            debugPrint('getmembershipfees isloading: $_isLoading');
            debugPrint('getmembershipfees skip: $_skip');
          });
        } else {
          setState(() {
            _isLoading = false;
            _hasMore = false;

            debugPrint('getmembershipfees isloading: $_isLoading');
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
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).meClubInsider,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: !_isLoading && _membershipfees.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    IconlyLight.addUser,
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
                      lang.S.of(context).clubinsiderEmptyCaption,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                      lang.S.of(context).clubinsiderBrowse,
                      style: textTheme.titleSmall?.copyWith(
                        color: whiteColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(
                            bottomNavIndex: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 500) {
                  //load more here
                  getMembershipFees();
                }
                return false;
              },
              child: SingleChildScrollView(
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
                          IconlyLight.user3,
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
                      child: Text(
                        lang.S.of(context).clubinsiderTitle,
                        style: textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: horizonSpace,
                        right: horizonSpace,
                      ),
                      child: Text(
                        lang.S.of(context).clubinsiderCaption,
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ListView.builder(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: horizonSpace,
                        right: horizonSpace,
                        bottom: verticalSpace,
                      ),
                      itemCount: _hasMore
                          ? _membershipfees.length + 1
                          : _membershipfees.length,
                      itemBuilder: (context, index) {
                        if (index >= _membershipfees.length) {
                          return Center(
                            child: Shimmer.fromColors(
                              baseColor: shimmerbaseColor,
                              highlightColor: shimmerhilightColor,
                              child: Container(
                                color: whiteColor,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: ClubinsiderCard(
                            membershipfee: _membershipfees[index],
                            ismembershipfree: _isMembershipFree,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
