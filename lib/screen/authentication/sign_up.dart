import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/library.dart';
import '../widgets/partial.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _mobile = TextEditingController();

  late bool hidePassword = true;
  late bool _isLoging = false;
  late bool _isMobileValid = false;
  late bool _isCounting = false;
  late int _start;
  String? _mobileError;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    _firstname.dispose();
    _lastname.dispose();
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
  Widget build(BuildContext context) {
    final authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 44,
          elevation: 0.0,
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          iconTheme: const IconThemeData(
            color: lightIconColor,
          ),
          centerTitle: true,
          title: Text(
            lang.S.of(context).appTitle,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: verticalSpace,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    lang.S.of(context).signupTitle,
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
                    lang.S.of(context).signupCaption,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: horizonSpace),
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
                                  labelText:
                                      lang.S.of(context).signupCountryCode,
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
                                  hintText: lang.S
                                      .of(context)
                                      .signupMobilePlaceholder,
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
                        child: TextFormField(
                          controller: _password,
                          style: textTheme.bodyMedium,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).signupPassword,
                            hintText:
                                lang.S.of(context).signupPasswordPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colorScheme.outline,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S.of(context).signupPasswordRequired;
                            }
                            if (value.length < 8) {
                              return lang.S.of(context).signupPasswordMustMore;
                            }
                            if (value.length > 20) {
                              return lang.S.of(context).signupPasswordMustLess;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 5, left: horizonSpace),
                        child: Text(
                          lang.S.of(context).signupPasswordNote,
                          style: textTheme.bodySmall?.copyWith(
                            color: lightGreyTextColor,
                          ),
                          textAlign: TextAlign.left,
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
                              child: TextFormField(
                                controller: _firstname,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText: lang.S.of(context).signupFirstName,
                                  hintText: lang.S
                                      .of(context)
                                      .signupFirstNamePlaceholder,
                                  hintStyle: textTheme.bodySmall?.copyWith(
                                    color: lightGreyTextColor,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return lang.S
                                        .of(context)
                                        .signupFirstNameRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: _lastname,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  fillColor: whiteColor,
                                  labelText: lang.S.of(context).signupLastName,
                                  hintText: lang.S
                                      .of(context)
                                      .signupLastNamePlaceholder,
                                  hintStyle: textTheme.bodySmall?.copyWith(
                                    color: lightGreyTextColor,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return lang.S
                                        .of(context)
                                        .signupLastNameRequired;
                                  }
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
                                    Response response = await httpService
                                        .postsendsms(_mobile.text);

                                    var data = json.decode(response.toString());

                                    if (data["statusCode"] == 200) {
                                      startTimer();
                                    } else if (data["statusCode"] == 202) {
                                      setState(() {
                                        _mobileError = data["statusMessage"];
                                      });
                                    }
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
                        child: _isLoging
                            ? const LoadingCircle()
                            : ElevatedButton(
                                child: Text(
                                  lang.S.of(context).commonContinue,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: whiteColor,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoging = true;
                                    });

                                    authchangeprovider
                                        .signUp(
                                            _code.text,
                                            _password.text,
                                            _firstname.text,
                                            _lastname.text,
                                            44,
                                            _mobile.text)
                                        .then(
                                      (value) {
                                        setState(() {
                                          _isLoging = false;
                                        });

                                        if (value) {
                                          setState(() {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: whiteColor,
                                                  title: const Text('恭喜你!'),
                                                  content: Text(lang.S
                                                      .of(context)
                                                      .signupSuccessmessage),
                                                  actions: [
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    const Home(
                                                              bottomNavIndex: 0,
                                                            ),
                                                          ),
                                                          (route) => false,
                                                        );
                                                      },
                                                      child: Text(
                                                        lang.S
                                                            .of(context)
                                                            .commonOk,
                                                        style: textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                color:
                                                                    darkColor),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: whiteColor,
                                                  title: const Text('Alert'),
                                                  content: Text(
                                                    lang.S
                                                        .of(context)
                                                        .signupAlert,
                                                  ),
                                                  actions: [
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        lang.S
                                                            .of(context)
                                                            .commonExit,
                                                        style: textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                color:
                                                                    darkColor),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: horizonSpace),
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: parseTextWithStyles(
                                  lang.S.of(context).signupNote,
                                ),
                              ),
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
