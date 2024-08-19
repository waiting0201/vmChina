import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../screen/authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import '../home/home.dart';
import 'account.dart';
import 'address.dart';
import 'payment.dart';
import 'clubinsider.dart';
import 'changepassword.dart';
import 'orderhistory.dart';
import 'languagechange.dart';
import 'faqdetail.dart';
import 'legalstatement.dart';
import 'lawdetail.dart';
import 'emailus.dart';
import 'notificationsetting.dart';
import 'privacysetting.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late bool _isFaqLoading = false;
  late bool _isLawLoading = false;

  final List<Faq> _faqs = [];
  final List<Law> _laws = [];

  late PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();

    initPackageInfo();
    getFaqs();
    getLaws();
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> getFaqs() async {
    if (!_isFaqLoading && mounted) {
      setState(() {
        _isFaqLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getfaqlists(null).then((value) {
        var data = json.decode(value.toString());

        log('getfaqs code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _faqs.addAll(
                (data["data"] as List).map((e) => Faq.fromMap(e)).toList());
            _isFaqLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getfaqs isloading');
            _isFaqLoading = false;
          });
        }
      });
    }
  }

  Future<void> getLaws() async {
    if (!_isLawLoading && mounted) {
      setState(() {
        _isLawLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getlaws(null).then((value) {
        var data = json.decode(value.toString());

        log('getlaws code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _laws.addAll(
                (data["data"] as List).map((e) => Law.fromMap(e)).toList());
            _isLawLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getlaws isloading');
            _isLawLoading = false;
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
        iconTheme: const IconThemeData(color: lightIconColor),
        title: Text(
          lang.S.of(context).meTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: const [
          CartIcon(),
        ],
      ),
      body: Consumer<AuthChangeProvider>(
        builder: (context, auth, child) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: horizonSpace,
              right: horizonSpace,
            ),
            child: Column(
              children: [
                //_____________________________________________________Account Section
                auth.status
                    ? Card(
                        margin: const EdgeInsets.all(0),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2.0,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 36,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${auth.member.firstname.toString()} ${auth.member.lastname.toString()}',
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    auth.member.email,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: lightGreyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const AccountSection(),
                const SizedBox(height: 20.0),
                //_____________________________________________________Account
                auth.status
                    ? Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Account(),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          horizontalTitleGap: 10.0,
                          leading: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.profile,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            lang.S.of(context).meAccount,
                            style: textTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: lightGreyTextColor,
                          ),
                        ),
                      )
                    : Container(),
                //_____________________________________________________Address Book
                auth.status
                    ? Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Address(),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          horizontalTitleGap: 10.0,
                          leading: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.location,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            lang.S.of(context).meAddressBook,
                            style: textTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: lightGreyTextColor,
                          ),
                        ),
                      )
                    : Container(),
                //_____________________________________________________Wallet
                /*auth.status
                    ? Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Payment(),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          horizontalTitleGap: 10.0,
                          leading: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.wallet,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            lang.S.of(context).meWallet,
                            style: textTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: lightGreyTextColor,
                          ),
                        ),
                      )
                    : Container(),*/
                //_____________________________________________________Club Insider
                auth.status
                    ? Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Clubinsider(),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          horizontalTitleGap: 10.0,
                          leading: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.user3,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            lang.S.of(context).meClubInsider,
                            style: textTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: lightGreyTextColor,
                          ),
                        ),
                      )
                    : Container(),
                //_____________________________________________________Change Password
                auth.status
                    ? Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Changepassword(),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          horizontalTitleGap: 10.0,
                          leading: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.password,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            lang.S.of(context).meChangePassword,
                            style: textTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: lightGreyTextColor,
                          ),
                        ),
                      )
                    : Container(),
                //_____________________________________________________Order History
                auth.status
                    ? Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        color: whiteColor,
                        surfaceTintColor: whiteColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Orderhistory(),
                              ),
                            );
                          },
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          horizontalTitleGap: 10.0,
                          leading: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withOpacity(0.1),
                            ),
                            child: const Icon(
                              IconlyLight.buy,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            lang.S.of(context).meOrderHistory,
                            style: textTheme.bodyMedium,
                          ),
                          trailing: const Icon(
                            FeatherIcons.chevronRight,
                            color: lightGreyTextColor,
                          ),
                        ),
                      )
                    : Container(),
                //_____________________________________________________Language
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    lang.S.of(context).meLanguageandCurrency,
                    style: textTheme.titleLarge,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  color: whiteColor,
                  surfaceTintColor: whiteColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Languagechange(),
                        ),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 10.0, right: 10.0),
                    horizontalTitleGap: 10.0,
                    leading: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.language,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      lang.S.of(context).meRegion,
                      style: textTheme.bodyMedium,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                //_____________________________________________________My settings
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    lang.S.of(context).meMySetting,
                    style: textTheme.titleLarge,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  color: whiteColor,
                  surfaceTintColor: whiteColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Notificationsetting(),
                        ),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 15.0, right: 10.0),
                    horizontalTitleGap: 10.0,
                    title: Text(
                      lang.S.of(context).meNotificationSetting,
                      style: textTheme.bodyMedium,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  color: whiteColor,
                  surfaceTintColor: whiteColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Privacysetting(),
                        ),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 15.0, right: 10.0),
                    horizontalTitleGap: 10.0,
                    title: Text(
                      lang.S.of(context).mePrivacySetting,
                      style: textTheme.bodyMedium,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                //_____________________________________________________Frequently Asked Questions
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    lang.S.of(context).meFrequentlyAskedQuestion,
                    style: textTheme.titleLarge,
                  ),
                ),
                ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _faqs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 4),
                      color: whiteColor,
                      surfaceTintColor: whiteColor,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Faqdetail(faq: _faqs[index]),
                            ),
                          );
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 15.0, right: 10.0),
                        horizontalTitleGap: 10.0,
                        title: Text(
                          _faqs[index].title,
                          style: textTheme.bodyMedium,
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: lightGreyTextColor,
                        ),
                      ),
                    );
                  },
                ),
                //_____________________________________________________Legal
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    lang.S.of(context).meLegal,
                    style: textTheme.titleLarge,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  color: whiteColor,
                  surfaceTintColor: whiteColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Legalstatement(),
                        ),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 15.0, right: 10.0),
                    horizontalTitleGap: 10.0,
                    title: Text(
                      lang.S.of(context).meLegalStatement,
                      style: textTheme.bodyMedium,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _laws.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 4),
                      color: whiteColor,
                      surfaceTintColor: whiteColor,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Lawdetail(law: _laws[index]),
                            ),
                          );
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 15.0, right: 10.0),
                        horizontalTitleGap: 10.0,
                        title: Text(
                          _laws[index].title,
                          style: textTheme.bodyMedium,
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: lightGreyTextColor,
                        ),
                      ),
                    );
                  },
                ),
                //_____________________________________________________Contact Us
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    lang.S.of(context).meContactUs,
                    style: textTheme.titleLarge,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailUs(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Icon(Icons.email),
                      Text(lang.S.of(context).meEmailUs),
                    ],
                  ),
                ),
                //_____________________________________________________Logout
                if (auth.status) ...[
                  const SizedBox(height: 50),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        auth.logOut().then((value) {
                          if (value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                              (route) => false,
                            );
                          }
                        });
                      },
                      child: Text(
                        lang.S.of(context).commonLogOut,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 50),
                Text(
                  'CN v ${_packageInfo.version}+${_packageInfo.buildNumber}',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
