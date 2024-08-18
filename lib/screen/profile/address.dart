import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../screen/authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import 'addaddress.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final List<ShippingLocation> _shippinglocations = [];

  late bool _isLoading = false;
  late Member _member;

  @override
  void initState() {
    super.initState();

    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    getShippingLocations();
  }

  Future<void> getShippingLocations() async {
    if (!_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpService httpService = HttpService();
    await httpService
        .getshippinglocationlistsbymemberid(_member.memberid, null)
        .then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200 && mounted) {
        setState(() {
          _shippinglocations.addAll((data["data"] as List)
              .map((e) => ShippingLocation.fromMap(e))
              .toList());
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
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
          lang.S.of(context).meAddressBook,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingCircle()
          : _shippinglocations.isNotEmpty
              ? SingleChildScrollView(
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
                              IconlyLight.location,
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
                          child: Center(
                            child: Text(
                              lang.S.of(context).addressTitle,
                              style: textTheme.titleLarge,
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
                            lang.S.of(context).addressCaption,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _shippinglocations.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _shippinglocations[index].isdefault
                                    ? primaryColor
                                    : lightGreyTextColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.only(
                              top: 6.0,
                              left: 12.0,
                              bottom: 6.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${_shippinglocations[index].address},\n${_shippinglocations[index].district ?? ""},\n${_shippinglocations[index].city}, ${_shippinglocations[index].state ?? ""}\n${_shippinglocations[index].country}, ${_shippinglocations[index].postcode}',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: _shippinglocations[index].isdefault
                                          ? primaryColor
                                          : lightGreyTextColor,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Addaddress(
                                          shippinglocation:
                                              _shippinglocations[index],
                                        ),
                                      ),
                                    );
                                    if (result != null && result) {
                                      setState(() {
                                        _shippinglocations.clear();
                                      });
                                      getShippingLocations();
                                    }
                                  },
                                  icon: const Icon(Icons.edit_note_outlined),
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          child: Text(
                            lang.S.of(context).commonAddAddress,
                            style: textTheme.titleSmall?.copyWith(
                              color: whiteColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Addaddress(),
                              ),
                            ).then((value) {
                              if (value) {
                                _shippinglocations.clear();
                                getShippingLocations();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconlyLight.location,
                        size: 100,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                        ),
                        child: Text(
                          lang.S.of(context).addressEmptyCaption,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: Text(
                          lang.S.of(context).commonAddAddress,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Addaddress(),
                            ),
                          ).then((value) {
                            if (value) {
                              _shippinglocations.clear();
                              getShippingLocations();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
