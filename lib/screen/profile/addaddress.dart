import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Addaddress extends StatefulWidget {
  final ShippingLocation? shippinglocation;
  const Addaddress({
    this.shippinglocation,
    super.key,
  });

  @override
  State<Addaddress> createState() => _AddaddressState();
}

class _AddaddressState extends State<Addaddress> {
  late AuthChangeProvider _authChangeProvider;
  late Member _member;
  late ShippingLocation _shippinglocation;
  late bool _isModify = false;
  late bool _isDefault = false;
  late bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _postcode = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

    if (widget.shippinglocation != null) {
      _isModify = true;
      _shippinglocation = widget.shippinglocation!;
      _state.text = _shippinglocation.state ?? '';
      _postcode.text = _shippinglocation.postcode;
      _city.text = _shippinglocation.city;
      _district.text = _shippinglocation.district ?? '';
      _address.text = _shippinglocation.address;
      _isDefault = _shippinglocation.isdefault;
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 44,
          elevation: 0.0,
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(
              Icons.close_outlined,
            ),
          ),
          title: Text(
            _isModify
                ? lang.S.of(context).addaddressEditTitle
                : lang.S.of(context).addaddressAddTitle,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: horizonSpace,
              right: horizonSpace,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    _isModify
                        ? lang.S.of(context).addaddressEditCaption
                        : lang.S.of(context).addaddressAddCaption,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                controller: _address,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText:
                                      lang.S.of(context).addaddressAddress,
                                  hintText: lang.S
                                      .of(context)
                                      .addaddressAddressPlaceholder,
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
                                        .addaddressRequiredAddress;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _district,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText:
                                      lang.S.of(context).addaddressDistrict,
                                  hintText: lang.S
                                      .of(context)
                                      .addaddressDistrictPlaceholder,
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
                                        .addaddressRequiredDistrict;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _city,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText: lang.S.of(context).addaddressCity,
                                  hintText: lang.S
                                      .of(context)
                                      .addaddressCityPlaceholder,
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
                                        .addaddressRequiredCity;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: _postcode,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText:
                                      lang.S.of(context).addaddressPostalCode,
                                  hintText: lang.S
                                      .of(context)
                                      .addaddressPostalCodePlaceholder,
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
                                        .addaddressRequiredPostalCode;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _state,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText: lang.S.of(context).addaddressState,
                                  hintText: lang.S
                                      .of(context)
                                      .addaddressStatePlaceholder,
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
                                        .addaddressRequiredState;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                style: textTheme.bodyMedium,
                                initialValue: '中国',
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  labelText:
                                      lang.S.of(context).addaddressCountry,
                                  hintText: lang.S
                                      .of(context)
                                      .addaddressCountryPlaceholder,
                                  hintStyle: textTheme.bodySmall?.copyWith(
                                    color: lightGreyTextColor,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1.0),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              checkColor: Colors.white,
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                              value: _isDefault,
                              onChanged: (val) {
                                setState(
                                  () {
                                    _isDefault = val!;
                                  },
                                );
                              },
                            ),
                            Text(
                              lang.S.of(context).addaddressSet,
                              style: textTheme.bodySmall?.copyWith(
                                color: lightGreyTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const LoadingCircle()
                          : OutlinedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  if (_isModify) {
                                    _authChangeProvider
                                        .updateShippingLocation(
                                      _shippinglocation.shippinglocationid,
                                      _shippinglocation.memberid,
                                      44,
                                      _postcode.text,
                                      _city.text,
                                      _district.text,
                                      _address.text,
                                      _isDefault,
                                      _state.text,
                                    )
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        Navigator.pop(context, true);
                                      } else {}
                                    });
                                  } else {
                                    _authChangeProvider
                                        .addShippingLocation(
                                            _member.memberid,
                                            44,
                                            _postcode.text,
                                            _city.text,
                                            _district.text,
                                            _address.text,
                                            _isDefault,
                                            _state.text)
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        Navigator.pop(context, true);
                                      } else {}
                                    });
                                  }
                                }
                              },
                              child: Text(
                                lang.S.of(context).commonConfirm,
                                style: textTheme.titleSmall?.copyWith(
                                  color: darkColor,
                                ),
                              ),
                            ),
                      _isModify
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: _isLoading
                                  ? const LoadingCircle()
                                  : OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        _authChangeProvider
                                            .deleteShippingLocation(
                                                _shippinglocation
                                                    .shippinglocationid)
                                            .then(
                                          (value) {
                                            if (value) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Navigator.pop(context, true);
                                            } else {}
                                          },
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: redColor,
                                      ),
                                      child: Text(
                                        lang.S.of(context).commonDelete,
                                        style: textTheme.titleSmall?.copyWith(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                            )
                          : const SizedBox()
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
