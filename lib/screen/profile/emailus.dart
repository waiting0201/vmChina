import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'emailuscomplete.dart';

class EmailUs extends StatefulWidget {
  const EmailUs({
    super.key,
  });

  @override
  State<EmailUs> createState() => _EmailUsState();
}

class _EmailUsState extends State<EmailUs> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _company = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  late AuthChangeProvider _authchangeprovider;
  late bool _isLoging = false;
  late Member _member;

  @override
  void initState() {
    super.initState();
    _authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    if (_authchangeprovider.status) {
      _member = _authchangeprovider.member;
      _name.text = '${_member.firstname!} ${_member.lastname!}';
      _phone.text = _member.mobile != null ? _member.mobile! : '';
      _email.text = _member.email;
    }
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          toolbarHeight: 44,
          elevation: 0.0,
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          automaticallyImplyLeading: false,
          title: Text(
            lang.S.of(context).emailusTitle,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_outlined,
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
                    lang.S.of(context).emailusMessageTitle,
                    style: textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 50,
                    right: 50,
                  ),
                  child: Text(
                    lang.S.of(context).emailusMessageCaption,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
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
                          controller: _name,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).emailusYourName,
                            hintText:
                                lang.S.of(context).emailusYourNamePlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S.of(context).emailusRequireYourName;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizonSpace,
                        ),
                        child: TextFormField(
                          controller: _phone,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).emailusYourPhone,
                            hintText:
                                lang.S.of(context).emailusYourPhonePlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S.of(context).emailusRequireYourPhone;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizonSpace,
                        ),
                        child: TextFormField(
                          controller: _company,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).emailusYourCompany,
                            hintText: lang.S
                                .of(context)
                                .emailusYourCompanyPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            labelText: lang.S.of(context).emailusYourEmail,
                            hintText:
                                lang.S.of(context).emailusYourEmailPlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S.of(context).emailusRequireYourEmail;
                            }
                            if (!EmailValidator.validate(value)) {
                              return lang.S.of(context).emailusInvalidYourEmail;
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
                          minLines: 3,
                          maxLines: 5,
                          controller: _message,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).emailusYourMessage,
                            hintText: lang.S
                                .of(context)
                                .emailusYourMessagePlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return lang.S
                                  .of(context)
                                  .emailusRequireYourMessage;
                            }
                            if (value.length > 200) {
                              return lang.S.of(context).emailusLessYourMessage;
                            }
                            return null;
                          },
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
                                    lang.S.of(context).commonSend,
                                    style: textTheme.titleSmall?.copyWith(
                                      color: whiteColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoging = true;
                                      });

                                      HttpService httpservice = HttpService();
                                      httpservice
                                          .postmessage(
                                        _name.text,
                                        _phone.text,
                                        _email.text,
                                        _message.text,
                                        _company.text,
                                      )
                                          .then((response) {
                                        var data =
                                            json.decode(response.toString());
                                        if (data["statusCode"] == 200) {
                                          setState(() {
                                            _isLoging = false;
                                          });

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Emailuscomplete(
                                                name: _name.text,
                                              ),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      });
                                    }
                                  },
                                ),
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
