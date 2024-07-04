import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmpassword = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _mobile = TextEditingController();
  final _country = TextEditingController();
  final List<Country> _countrys = [];

  late bool hidePassword = true;
  late bool hideConfirmPassword = true;
  late bool _isLoging = false;
  late Country _selectedcountry;

  @override
  void initState() {
    getCountrys();
    super.initState();
  }

  Future<void> getCountrys() async {
    HttpService httpService = HttpService();
    await httpService.getcountrylists().then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200) {
        setState(() {
          _countrys.addAll(
              (data["data"] as List).map((e) => Country.fromMap(e)).toList());
        });
      } else {
        setState(() {});
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
                          horizontal: horizonSpace,
                        ),
                        child: TextFormField(
                          controller: _email,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).signupAccount,
                            hintText:
                                lang.S.of(context).signupAccountPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S
                                  .of(context)
                                  .signupAccountRequiredEmail;
                            }
                            if (!EmailValidator.validate(value)) {
                              return lang.S
                                  .of(context)
                                  .signupAccountInvalidEmail;
                            }
                            return null;
                          },
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
                            if (value == value.toLowerCase()) {
                              return lang.S
                                  .of(context)
                                  .signupPasswordContainUpper;
                            }
                            if (value == value.toUpperCase()) {
                              return lang.S
                                  .of(context)
                                  .signupPasswordContainLower;
                            }
                            if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!#$%&]).{8,20}$')
                                .hasMatch(value)) {
                              return lang.S
                                  .of(context)
                                  .signupPasswordContainSpecial;
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
                        child: TextFormField(
                          controller: _confirmpassword,
                          style: textTheme.bodyMedium,
                          obscureText: hideConfirmPassword,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).signupConfirmPassword,
                            hintText: lang.S
                                .of(context)
                                .signupConfirmPasswordPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colorScheme.outline,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S
                                  .of(context)
                                  .signupConfirmPasswordRequired;
                            }
                            if (value != _password.text) {
                              return lang.S
                                  .of(context)
                                  .signupConfirmPasswordMustSame;
                            }
                            return null;
                          },
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
                            horizontal: horizonSpace),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _country,
                                style: textTheme.bodyMedium,
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
                                  suffixIcon: const Icon(
                                    IconlyLight.arrowDown2,
                                  ),
                                ),
                                onTap: () => showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    child: CupertinoPicker(
                                      backgroundColor:
                                          colorScheme.secondaryContainer,
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: 0,
                                      ),
                                      children: List<Widget>.generate(
                                          _countrys.length, (int index) {
                                        return Center(
                                          child: Text(
                                            '${_countrys[index].nickname} (+${_countrys[index].phonecode})',
                                          ),
                                        );
                                      }),
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                        _country.text =
                                            '+${_countrys[selectedItem].phonecode}';
                                        _selectedcountry =
                                            _countrys[selectedItem];
                                      },
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return lang.S
                                        .of(context)
                                        .signupCountryCodeRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
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
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return lang.S
                                        .of(context)
                                        .signupMobileRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: _isLoging
                            ? const LoadingCircle()
                            : ElevatedButton(
                                child: Text(
                                  lang.S.of(context).commonSignUp,
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
                                            _email.text,
                                            _password.text,
                                            _firstname.text,
                                            _lastname.text,
                                            _selectedcountry.countryid,
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
                                                  title: const Text(
                                                      'Congratulations!'),
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
