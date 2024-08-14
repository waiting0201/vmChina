import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../home/home.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _formKey = GlobalKey<FormState>();
  final _gender = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _country = TextEditingController();
  final _mobile = TextEditingController();
  final List<String> _titles = ["Mr.", "Mrs.", "Ms.", "I'd rather not say"];

  late AuthChangeProvider _authChangeProvider;
  late int _genderselect;
  late Member _member;
  late bool _isDisableing = false;

  @override
  void initState() {
    super.initState();

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

    _gender.text = _titles[_member.gender != null ? _member.gender! : 0];
    _firstname.text = _member.firstname!;
    _lastname.text = _member.lastname!;
    _month.text = _member.month != null ? _member.month!.toString() : '';
    _day.text = _member.day != null ? _member.day!.toString() : '';
    _year.text = _member.year != null ? _member.year!.toString() : '';
    _genderselect = _member.gender != null ? _member.gender! : 0;
    _mobile.text = _member.mobile != null ? _member.mobile! : '';
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
        title: Text(
          lang.S.of(context).meAccount,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: horizonSpace,
              right: horizonSpace,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.1),
                    ),
                    child: const Icon(
                      IconlyLight.profile,
                      color: primaryColor,
                      size: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    lang.S.of(context).accountTitle,
                    style: textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: verticalSpace,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: CupertinoPicker(
                            backgroundColor: colorScheme.secondaryContainer,
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                              initialItem: _member.gender != null
                                  ? _member.gender! - 1
                                  : 0,
                            ),
                            children: List<Widget>.generate(4, (int index) {
                              return Center(
                                child: Text(
                                  _titles[index],
                                ),
                              );
                            }),
                            onSelectedItemChanged: (int selectedItem) {
                              _gender.text = _titles[selectedItem];
                              _genderselect = selectedItem + 1;
                            },
                          ),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: TextFormField(
                        controller: _gender,
                        style: textTheme.bodyMedium,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          labelText: lang.S.of(context).accountGender,
                          hintText: lang.S.of(context).accountGenderPlaceholder,
                          hintStyle: textTheme.bodySmall?.copyWith(
                            color: lightGreyTextColor,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const Icon(
                            IconlyLight.arrowDown2,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return lang.S.of(context).accountRequiredGender;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizonSpace,
                  ),
                  child: TextFormField(
                    controller: _firstname,
                    style: textTheme.bodyMedium,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      labelText: lang.S.of(context).accountFirstName,
                      hintText: lang.S.of(context).accountFirstNamePlaceholder,
                      hintStyle: textTheme.bodySmall?.copyWith(
                        color: lightGreyTextColor,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.S.of(context).accountFirstNameRequired;
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
                    controller: _lastname,
                    style: textTheme.bodyMedium,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      labelText: lang.S.of(context).accountLastName,
                      hintText: lang.S.of(context).accountLastNamePlaceholder,
                      hintStyle: textTheme.bodySmall?.copyWith(
                        color: lightGreyTextColor,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.S.of(context).accountLastNameRequired;
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
                            labelText: lang.S.of(context).accountCountryCode,
                            hintText: lang.S
                                .of(context)
                                .accountCountryCodePlaceholder,
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: lightGreyTextColor,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _mobile,
                          readOnly: true,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            labelText: lang.S.of(context).accountMobile,
                            hintText:
                                lang.S.of(context).accountMobilePlaceholder,
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
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: horizonSpace),
                  child: Text(
                    lang.S.of(context).accountDateOfBirth,
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizonSpace,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                child: CupertinoPicker(
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  itemExtent: 40,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: _member.month != null
                                        ? _member.month! - 1
                                        : 0,
                                  ),
                                  children:
                                      List<Widget>.generate(12, (int index) {
                                    return Center(
                                      child: Text(
                                        '${index + 1}',
                                      ),
                                    );
                                  }),
                                  onSelectedItemChanged: (int selectedItem) {
                                    _month.text = '${selectedItem + 1}';
                                  },
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextFormField(
                              controller: _month,
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: lang.S.of(context).accountMonth,
                                hintText: 'Select month',
                                hintStyle: textTheme.bodySmall?.copyWith(
                                  color: lightGreyTextColor,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(
                                  IconlyLight.arrowDown2,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return lang.S
                                      .of(context)
                                      .accountRequiredMonth;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                child: CupertinoPicker(
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  itemExtent: 40,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: _member.day != null
                                        ? _member.day! - 1
                                        : 0,
                                  ),
                                  children:
                                      List<Widget>.generate(31, (int index) {
                                    return Center(
                                      child: Text(
                                        '${index + 1}',
                                      ),
                                    );
                                  }),
                                  onSelectedItemChanged: (int selectedItem) {
                                    _day.text = '${selectedItem + 1}';
                                  },
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextFormField(
                              controller: _day,
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: lang.S.of(context).accountDay,
                                hintText: 'Select day',
                                hintStyle: textTheme.bodySmall?.copyWith(
                                  color: lightGreyTextColor,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(
                                  IconlyLight.arrowDown2,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return lang.S.of(context).accountRequiredDay;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                child: CupertinoPicker(
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  itemExtent: 40,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: _member.year != null
                                        ? DateTime.now().year - _member.year!
                                        : 0,
                                  ),
                                  children:
                                      List<Widget>.generate(100, (int index) {
                                    return Center(
                                      child: Text(
                                        '${DateTime.now().year - index}',
                                      ),
                                    );
                                  }),
                                  onSelectedItemChanged: (int selectedItem) {
                                    _year.text =
                                        '${DateTime.now().year - selectedItem}';
                                  },
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextFormField(
                              controller: _year,
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: lang.S.of(context).accountYear,
                                hintText: 'Select year',
                                hintStyle: textTheme.bodySmall?.copyWith(
                                  color: lightGreyTextColor,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(
                                  IconlyLight.arrowDown2,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return lang.S.of(context).accountRequiredYear;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                        _authChangeProvider
                            .update(
                          _member.memberid,
                          _firstname.text,
                          _lastname.text,
                          _genderselect,
                          int.parse(_month.text),
                          int.parse(_day.text),
                          int.parse(_year.text),
                          44,
                          _mobile.text,
                        )
                            .then(
                          (value) {
                            if (value) {
                              _authChangeProvider.refreshMember();

                              setState(() {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WarnModal(
                                      title: 'Success',
                                      message:
                                          lang.S.of(context).accountSuccess,
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
                                    return WarnModal(
                                      title: 'Alert',
                                      message: lang.S.of(context).accountFail,
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: verticalSpace,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    lang.S.of(context).accountDisableTitle,
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
                    lang.S.of(context).accountDisableCaption,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    child: Text(
                      lang.S.of(context).commonRequestDisable,
                      style: textTheme.titleSmall?.copyWith(
                        color: darkColor,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _isDisableing
                              ? const LoadingCircle()
                              : AlertDialog(
                                  title: Text(
                                    lang.S.of(context).accountConfirm,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  content: Text(
                                    lang.S.of(context).accountConfirmCaption,
                                    style: textTheme.titleSmall,
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        lang.S.of(context).commonExit,
                                        style: textTheme.titleSmall?.copyWith(
                                          color: darkColor,
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: darkColor),
                                      child: Text(
                                        lang.S.of(context).commonConfirm,
                                        style: textTheme.titleSmall?.copyWith(
                                          color: whiteColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isDisableing = true;
                                        });
                                        _authChangeProvider
                                            .disablemember(_member.memberid)
                                            .then(
                                              (value) =>
                                                  Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home(),
                                                ),
                                                (route) => false,
                                              ),
                                            );
                                      },
                                    ),
                                  ],
                                );
                        },
                      );
                    },
                  ),
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
