import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import '../widgets/common.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  late bool _isLoging = false;

  @override
  Widget build(BuildContext context) {
    final authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1.0,
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
                    lang.S.of(context).forgotpasswordTitle,
                    style: textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: horizonSpace, right: horizonSpace),
                  child: Text(
                    lang.S.of(context).forgotpasswordCaption,
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall,
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
                            fillColor: whiteColor,
                            labelText: lang.S.of(context).forgotpasswordEmail,
                            hintText: lang.S
                                .of(context)
                                .forgotpasswordEmailPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S
                                  .of(context)
                                  .forgotpasswordRequiredEmail;
                            }
                            if (!EmailValidator.validate(value)) {
                              return lang.S
                                  .of(context)
                                  .forgotpasswordInvalidEmail;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: _isLoging
                            ? const LoadingCircle()
                            : ElevatedButton(
                                child: Text(
                                  lang.S.of(context).commonSend,
                                  style: textTheme.titleSmall
                                      ?.copyWith(color: whiteColor),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoging = true;
                                    });

                                    authchangeprovider
                                        .forget(_email.text)
                                        .then((value) {
                                      setState(() {
                                        _isLoging = false;
                                      });

                                      if (value) {
                                        setState(
                                          () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarnModal(
                                                  title: 'Information',
                                                  message: lang.S
                                                      .of(context)
                                                      .forgotpasswordInformation,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        setState(
                                          () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WarnModal(
                                                  title: 'Alert',
                                                  message: lang.S
                                                      .of(context)
                                                      .forgotpasswordAlert,
                                                );
                                              },
                                            );
                                          },
                                        );
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
      ),
    );
  }
}
