import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';

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
  late Country _selectedcountry;
  late Member _member;
  late ShippingLocation _shippinglocation;
  late bool isModify = false;
  late bool isDefault = false;

  final List<Country> _countrys = [];
  final _formKey = GlobalKey<FormState>();
  final _country = TextEditingController();
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

    getCountrys();

    if (widget.shippinglocation != null) {
      isModify = true;
      _shippinglocation = widget.shippinglocation!;
      _state.text = _shippinglocation.state ?? '';
      _postcode.text = _shippinglocation.postcode;
      _city.text = _shippinglocation.city;
      _district.text = _shippinglocation.district ?? '';
      _address.text = _shippinglocation.address;
      isDefault = _shippinglocation.isdefault;
    }
  }

  Future<void> getCountrys() async {
    HttpService httpService = HttpService();
    await httpService.getcountrylists().then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200) {
        setState(() {
          _countrys.addAll(
              (data["data"] as List).map((e) => Country.fromMap(e)).toList());

          if (widget.shippinglocation != null) {
            _selectedcountry = _countrys.singleWhere(
                (element) => element.countryid == _shippinglocation.countryid);
            _country.text = _selectedcountry.nickname;
          }
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
          isModify
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
                  isModify
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
                            child: InkWell(
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 350,
                                    child: CupertinoPicker(
                                      backgroundColor: whiteColor,
                                      itemExtent: 40,
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: 0,
                                      ),
                                      children: List<Widget>.generate(
                                        _countrys.length,
                                        (int index) => Center(
                                          child: Text(
                                            _countrys[index].nickname,
                                          ),
                                        ),
                                      ),
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                        _country.text =
                                            _countrys[selectedItem].nickname;
                                        _selectedcountry =
                                            _countrys[selectedItem];
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _country,
                                  style: textTheme.bodyMedium,
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
                                    suffixIcon: const Icon(
                                      IconlyLight.arrowDown2,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return lang.S
                                          .of(context)
                                          .addaddressRequiredCountry;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
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
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          const SizedBox(width: 10.0),
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
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: _address,
                              style: textTheme.bodyMedium,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                labelText: lang.S.of(context).addaddressAddress,
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
                            visualDensity: const VisualDensity(horizontal: -4),
                            value: isDefault,
                            onChanged: (val) {
                              setState(
                                () {
                                  isDefault = val!;
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
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (isModify) {
                            _authChangeProvider
                                .updateShippingLocation(
                              _shippinglocation.shippinglocationid,
                              _shippinglocation.memberid,
                              _selectedcountry.countryid,
                              _postcode.text,
                              _city.text,
                              _district.text,
                              _address.text,
                              isDefault,
                              _state.text,
                            )
                                .then((value) {
                              if (value) {
                                Navigator.pop(context, true);
                              } else {}
                            });
                          } else {
                            _authChangeProvider
                                .addShippingLocation(
                                    _member.memberid,
                                    _selectedcountry.countryid,
                                    _postcode.text,
                                    _city.text,
                                    _district.text,
                                    _address.text,
                                    isDefault,
                                    _state.text)
                                .then((value) {
                              if (value) {
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
                    isModify
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                _authChangeProvider
                                    .deleteShippingLocation(
                                        _shippinglocation.shippinglocationid)
                                    .then(
                                  (value) {
                                    if (value) {
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
                        : Container()
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
