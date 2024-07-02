import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluwx/fluwx.dart';

import '../../generated/l10n.dart' as lang;
import '../../screen/authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import 'sign_up.dart';
import 'forgot_password.dart';
import 'wechat_email.dart';

class LogIn extends StatefulWidget {
  final int? bottomNavIndex;
  const LogIn({
    super.key,
    this.bottomNavIndex,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _fluwx = Fluwx();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  late AuthChangeProvider _authChangeProvider;
  late bool hidePassword = true;
  late bool isChecked = false;
  late bool status = false;
  late bool _isLoging = false;
  late bool _startLogin = false;
  late Function(WeChatResponse) responseListener;

  @override
  void initState() {
    super.initState();
    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    doInit();
  }

  @override
  void dispose() {
    super.dispose();
    _fluwx.removeSubscriber(responseListener);
  }

  Future<void> doInit() async {
    responseListener = (res) {
      if (res is WeChatAuthResponse) {
        if (res.isSuccessful) {
          _authChangeProvider.wechatBinding(res.code!).then((value) {
            if (value != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WechatEmail(
                    name: value.nickname,
                    unionid: value.unionid,
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          });
        } else {
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
    bool isInstalled = await _fluwx.isWeChatInstalled;

    if (!isInstalled) {
      setState(
        () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const WarnModal(
                title: 'Information',
                message: "請先安裝微信",
              );
            },
          );
        },
      );
      return;
    }

    if (mounted) {
      setState(() {
        _startLogin = true;
      });
    }

    _fluwx
        .authBy(
            which:
                NormalAuth(scope: 'snsapi_userinfo', state: 'vm_wechat_login'))
        .then((value) {
      if (!value) {
        log("scope:${value.toString()}");
        return;
      }
    });
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
            'WELCOME',
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
                          controller: _email,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).loginAccount,
                            hintText:
                                lang.S.of(context).loginAccountPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S
                                  .of(context)
                                  .loginAccountRequiredEmail;
                            }
                            if (!EmailValidator.validate(value)) {
                              return lang.S
                                  .of(context)
                                  .loginAccountInvalidEmail;
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
                                          .signIn(
                                              _email.text, _password.text, true)
                                          .then(
                                        (value) {
                                          setState(() {
                                            _isLoging = false;
                                          });

                                          if (value) {
                                            Navigator.pop(context);
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
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
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
                              doLogin();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
