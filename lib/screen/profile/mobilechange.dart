import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Mobilechange extends StatefulWidget {
  const Mobilechange({super.key});

  @override
  State<Mobilechange> createState() => _MobilechangeState();
}

class _MobilechangeState extends State<Mobilechange> {
  final _formKey = GlobalKey<FormState>();
  final _mobile = TextEditingController();
  final _code = TextEditingController();

  late AuthChangeProvider _authChangeProvider;
  late Member _member;
  late bool _isLoading = false;
  late bool _isMobileValid = false;
  late bool _isCounting = false;
  late int _start;
  String? _mobileError;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;
  }

  @override
  void dispose() {
    _code.dispose();
    _mobile.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _isCounting = true;
          _start--;
        });
      } else {
        setState(() {
          _isCounting = false;
        });
        _timer?.cancel();
      }
    });
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
          '手机号码',
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: verticalSpace,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: horizonSpace),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: textTheme.bodyMedium,
                              initialValue: '+86',
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: lang.S.of(context).signupCountryCode,
                                hintText: lang.S
                                    .of(context)
                                    .signupCountryCodePlaceholder,
                                hintStyle: textTheme.bodySmall?.copyWith(
                                  color: lightGreyTextColor,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _mobile,
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: lang.S.of(context).signupMobile,
                                hintText:
                                    lang.S.of(context).signupMobilePlaceholder,
                                hintStyle: textTheme.bodySmall?.copyWith(
                                  color: lightGreyTextColor,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText: _mobileError,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _isMobileValid = true;
                                });
                                if (value.isEmpty) {
                                  setState(() {
                                    _isMobileValid = false;
                                  });
                                }
                                if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                                  setState(() {
                                    _isMobileValid = false;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return lang.S
                                      .of(context)
                                      .signupMobileRequired;
                                }
                                if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                                  return '手机号码格式错误';
                                }

                                setState(() {
                                  _isMobileValid = true;
                                });

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizonSpace,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _code,
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: '验证码',
                                hintText: '请输入验证码',
                                hintStyle: textTheme.bodySmall?.copyWith(
                                  color: lightGreyTextColor,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '验证码必填';
                                }
                                if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                                  return '验证码格式错误';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: () async {
                                debugPrint('Mobile Valid: $_isMobileValid');
                                debugPrint('Counting: $_isCounting');
                                if (_isMobileValid && !_isCounting) {
                                  HttpService httpService = HttpService();
                                  await httpService
                                      .postupdateaccountsendsms(
                                          _mobile.text, _member.memberid)
                                      .then((value) {
                                    var data = json.decode(value.toString());

                                    if (data["statusCode"] == 200) {
                                      startTimer();
                                    } else if (data["statusCode"] == 202) {
                                      setState(() {
                                        _mobileError = data["statusMessage"];
                                      });
                                    }
                                  });
                                }
                                if (!_isMobileValid && !_isCounting) {
                                  setState(() {
                                    _mobileError = "请先输入手机号码";
                                  });
                                }
                              },
                              child: Text(
                                _isCounting ? '($_start)' : '获取验证码',
                                style: textTheme.titleSmall?.copyWith(
                                  color: darkColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, left: horizonSpace),
                      child: Text(
                        '短信验证码60分钟有效',
                        style: textTheme.bodySmall?.copyWith(
                          color: lightGreyTextColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: _isLoading
                          ? const LoadingCircle()
                          : ElevatedButton(
                              child: Text(
                                lang.S.of(context).commonSaveChanges,
                                style: textTheme.titleSmall?.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  _authChangeProvider
                                      .updatemobile(
                                          _member.memberid, _mobile.text)
                                      .then((value) {
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    _authChangeProvider.refreshMember();

                                    if (value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('手机号码修改成功'),
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
                                  });
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
