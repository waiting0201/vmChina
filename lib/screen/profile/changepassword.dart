import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../screen/authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmpassword = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  late Member _member;

  @override
  void initState() {
    super.initState();
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    final authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
          lang.S.of(context).meChangePassword,
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
                          labelText: lang.S.of(context).changepasswordPassword,
                          hintText: lang.S
                              .of(context)
                              .changepasswordPasswordPlaceholder,
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
                            return lang.S
                                .of(context)
                                .changepasswordPasswordRequired;
                          }
                          if (value.length < 8) {
                            return lang.S
                                .of(context)
                                .changepasswordPasswordMustMore;
                          }
                          if (value.length > 20) {
                            return lang.S
                                .of(context)
                                .changepasswordPasswordMustLess;
                          }

                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, left: horizonSpace),
                      child: Text(
                        lang.S.of(context).changepasswordPasswordNote,
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
                          labelText:
                              lang.S.of(context).changepasswordConfirmPassword,
                          hintText: lang.S
                              .of(context)
                              .changepasswordConfirmPasswordPlaceholder,
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
                                .changepasswordConfirmPasswordRequired;
                          }
                          if (value != _password.text) {
                            return lang.S
                                .of(context)
                                .changepasswordConfirmPasswordMustSame;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text(
                          lang.S.of(context).commonSaveChanges,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authchangeprovider
                                .updatepassword(
                                    _member.memberid, _password.text)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WarnModal(
                                        title: 'Information',
                                        message: lang.S
                                            .of(context)
                                            .changepasswordInformation,
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
                                      return const WarnModal(
                                        title: 'Alert',
                                        message: 'Updated Failed.',
                                      );
                                    },
                                  );
                                });
                              }
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
