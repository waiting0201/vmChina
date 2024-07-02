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

class DesignerMessage extends StatefulWidget {
  final Designer designer;
  const DesignerMessage({
    super.key,
    required this.designer,
  });

  @override
  State<DesignerMessage> createState() => _DesignerMessageState();
}

class _DesignerMessageState extends State<DesignerMessage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
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
    _member = _authchangeprovider.member;
    _name.text = '${_member.firstname!} ${_member.lastname!}';
    _email.text = _member.email;
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
            widget.designer.title,
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
                    'Message',
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
                    'Please enter the message you want to convey to the designer.',
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
                            labelText: 'Your Name',
                            hintText: 'Enter your name',
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Your name required';
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
                          controller: _email,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: 'Your Email',
                            hintText: 'Enter your email',
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email required';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Invalid email';
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
                            labelText: 'Your Message',
                            hintText: 'Hello! Leave a message...',
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Message required';
                            }
                            if (value.length > 200) {
                              return 'Message should less than 200 characters';
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
                                          .postdesignermessage(
                                              _member.memberid,
                                              widget.designer.designerid,
                                              _name.text,
                                              _email.text,
                                              _message.text)
                                          .then((response) {
                                        var data =
                                            json.decode(response.toString());
                                        if (data["statusCode"] == 200) {
                                          setState(() {
                                            _isLoging = false;
                                          });

                                          Navigator.pop(context);
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
