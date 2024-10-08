import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluwx/fluwx.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../profile/lawdetail.dart';
import 'sign_up.dart';
import 'forgot_password.dart';

class LogIn extends StatefulWidget {
  final String? refer;
  const LogIn({
    super.key,
    this.refer,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _fluwx = Fluwx();
  final _formKey = GlobalKey<FormState>();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  final List<Law> _laws = [];

  late AuthChangeProvider _authChangeProvider;
  late bool hidePassword = true;
  late bool isChecked = false;
  late bool status = false;
  late bool _isLoging = false;
  late bool _startLogin = false;
  late bool _isWeChatInstalled = false;
  late bool _isLawLoading = false;
  late bool _isAgreeTerm = false;
  late bool _isAgreePrivacy = false;
  late Function(WeChatResponse) responseListener;

  @override
  void initState() {
    super.initState();
    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);

    getLaws();
    doInit();
  }

  @override
  void dispose() {
    super.dispose();
    _fluwx.removeSubscriber(responseListener);
  }

  Future<void> doWeChatSignUp(String code) async {
    _authChangeProvider.wechatBinding(code).then((value) {
      if (value != null) {
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Profile(),
          ),
          (route) => false,
        );
      }
    });
  }

  Future<void> doInit() async {
    bool isWeChatInstalled = await _fluwx.isWeChatInstalled;
    setState(() {
      _isWeChatInstalled = isWeChatInstalled;
    });

    responseListener = (res) {
      if (res is WeChatAuthResponse) {
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

        if (res.isSuccessful) {
          _authChangeProvider.wechatBinding(res.code!).then((value) {
            if (value != null) {
              overlayEntry.remove();
              /*setState(() {
                _startLogin = false;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WechatEmail(
                    name: value.nickname,
                    unionid: value.unionid,
                  ),
                ),
              );*/
            } else {
              overlayEntry.remove();

              if (widget.refer == 'intro') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.pop(context);
              }
            }
          });
        } else {
          overlayEntry.remove();
          setState(() {
            _startLogin = false;
          });
        }
      } else {
        setState(() {
          _startLogin = false;
        });
      }
    };
    _fluwx.addSubscriber(responseListener);
  }

  Future<void> doLogin() async {
    if (mounted) {
      setState(() {
        _startLogin = true;
      });
    }

    _fluwx
        .authBy(
            which: NormalAuth(
                scope: 'snsapi_userinfo',
                state: 'vm_wechat_login',
                nonAutomatic: false))
        .then((value) {
      if (!value) {
        log("scope:${value.toString()}");
        return;
      }
    });
  }

  Future<void> getLaws() async {
    if (!_isLawLoading && mounted) {
      setState(() {
        _isLawLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getlaws(null).then((value) {
        var data = json.decode(value.toString());

        debugPrint('getlaws code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _laws.addAll(
                (data["data"] as List).map((e) => Law.fromMap(e)).toList());
            _isLawLoading = false;
          });
        } else if (mounted) {
          setState(() {
            debugPrint('getlaws isloading');
            _isLawLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: false,
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
                  ),
                  child: Text(
                    lang.S.of(context).loginTitle,
                    style: textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: verticalSpace,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizonSpace,
                        ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S.of(context).signupMobileRequired;
                            }
                            if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                              return '手机号码格式错误';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                            labelText: lang.S.of(context).loginPassword,
                            hintText:
                                lang.S.of(context).loginPasswordPlaceholder,
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
                              return lang.S.of(context).loginPasswordRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizonSpace,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /*Checkbox(
                              activeColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1.0),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              checkColor: Colors.white,
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                              value: isChecked,
                              onChanged: (val) {
                                setState(
                                  () {
                                    isChecked = val!;
                                  },
                                );
                              },
                            ),
                            Text(
                              lang.S.of(context).remember,
                              style: textTheme.bodySmall?.copyWith(
                                color: lightGreyTextColor,
                              ),
                            ),
                            const Spacer(),*/
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: primaryColor,
                              ),
                              child: Text(
                                lang.S.of(context).loginForgotPassword,
                                style: textTheme.bodySmall?.copyWith(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: _isLoging
                              ? const LoadingCircle()
                              : ElevatedButton(
                                  child: Text(
                                    lang.S.of(context).commonSignIn,
                                    style: textTheme.titleSmall?.copyWith(
                                      color: whiteColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoging = true;
                                      });

                                      _authChangeProvider
                                          .signIn(_mobile.text, _password.text,
                                              true)
                                          .then(
                                        (value) {
                                          setState(() {
                                            _isLoging = false;
                                          });

                                          if (value) {
                                            if (widget.refer == 'intro') {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home(),
                                                ),
                                                (route) => false,
                                              );
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          } else {
                                            setState(
                                              () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return WarnModal(
                                                      title: 'Alert',
                                                      message: lang.S
                                                          .of(context)
                                                          .loginAlert,
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: lang.S.of(context).loginNotMember,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                        children: [
                          TextSpan(
                            text: lang.S.of(context).loginCreateAccount,
                            style: textTheme.bodySmall?.copyWith(
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isWeChatInstalled) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: _startLogin
                          ? const LoadingCircle()
                          : ElevatedButton.icon(
                              icon: const Icon(
                                Icons.wechat,
                                color: whiteColor,
                              ),
                              onPressed: () {
                                if (_isAgreeTerm && _isAgreePrivacy) {
                                  doLogin();
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: whiteColor,
                                        title: const Text('Alert'),
                                        content: const Text(
                                          '请同意条款与隐私权',
                                        ),
                                        actions: [
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
                                }
                              },
                              label: Text(
                                lang.S
                                    .of(context)
                                    .loginSignInorRegisterwithwechat,
                                style: textTheme.titleSmall?.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: wechatColor,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Column(
                      children: [
                        if (!_isLawLoading) ...[
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  activeColor: Colors.yellow,
                                  checkColor: Colors.black,
                                  value: _isAgreeTerm,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isAgreeTerm = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                lang.S.of(context).signupTerm,
                                style: textTheme.titleSmall,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Lawdetail(law: _laws[1]),
                                    ),
                                  );
                                },
                                child: Text(
                                  lang.S.of(context).termTitle,
                                  style: textTheme.titleSmall?.copyWith(
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  activeColor: Colors.yellow,
                                  checkColor: Colors.black,
                                  value: _isAgreePrivacy,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isAgreePrivacy = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                lang.S.of(context).signupPrivacy,
                                style: textTheme.titleSmall,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Lawdetail(law: _laws[0]),
                                    ),
                                  );
                                },
                                child: Text(
                                  lang.S.of(context).privacyTitle,
                                  style: textTheme.titleSmall?.copyWith(
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
