import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/repository.dart';
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../category/productdetail.dart';
import '../profile/addaddress.dart';
import 'cart_provider.dart';
import 'payment.dart';
import 'selectpayment.dart';

class Checkout extends StatefulWidget {
  const Checkout({
    super.key,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final List<ShippingLocation> _shippinglocations = [];
  final String _shippingtype = "B";
  final String _ispreorder = "n";

  late CartChangeProvider _cartChangeProvider;
  late List<Carts> _carts = [];
  late Member _member;
  late double _subtotal;
  late String _selected = '';
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;
    _firstname.text = _member.firstname!;
    _lastname.text = _member.lastname!;
    _carts = _cartChangeProvider.carts;
    _subtotal = _cartChangeProvider.getSubTotalPrice();
    getShippingLocations();
  }

  Future<void> getShippingLocations() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpService httpService = HttpService();
    await httpService
        .getshippinglocationlistsbymemberid(_member.memberid, null)
        .then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200) {
        setState(() {
          _shippinglocations.addAll((data["data"] as List)
              .map((e) => ShippingLocation.fromMap(e))
              .toList());
          if (_shippinglocations.isNotEmpty &&
              _shippinglocations.any((e) => e.isdefault == true)) {
            _selected = _shippinglocations
                .singleWhere((element) => element.isdefault == true)
                .shippinglocationid;
          }
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

    //debugInvertOversizedImages = true;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).checkoutTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: CartSummary(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingCircle(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Text(
                      lang.S.of(context).checkoutShipping,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  _shippinglocations.isEmpty
                      ? const SizedBox()
                      : ListView.separated(
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
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
                                color: _selected.isEmpty &&
                                            _shippinglocations[index]
                                                .isdefault ||
                                        _selected ==
                                            _shippinglocations[index]
                                                .shippinglocationid
                                    ? primaryColor
                                    : lightGreyTextColor,
                                width: _selected.isEmpty &&
                                            _shippinglocations[index]
                                                .isdefault ||
                                        _selected ==
                                            _shippinglocations[index]
                                                .shippinglocationid
                                    ? 2.5
                                    : 1.0,
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
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selected = _shippinglocations[index]
                                            .shippinglocationid;
                                      });
                                    },
                                    child: Text(
                                      '${_shippinglocations[index].address},\n${_shippinglocations[index].district ?? ""},\n${_shippinglocations[index].city}, ${_shippinglocations[index].state ?? ""}\n${_shippinglocations[index].country}, ${_shippinglocations[index].postcode}',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: _selected.isEmpty &&
                                                    _shippinglocations[index]
                                                        .isdefault ||
                                                _selected ==
                                                    _shippinglocations[index]
                                                        .shippinglocationid
                                            ? primaryColor
                                            : lightGreyTextColor,
                                      ),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Addaddress(),
                            ),
                          );
                          if (result != null && result) {
                            setState(() {
                              _shippinglocations.clear();
                            });
                            getShippingLocations();
                          }
                        },
                        child: Text(
                          lang.S.of(context).commonAddAddress,
                          style: textTheme.titleSmall?.copyWith(
                            color: darkColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Text(
                      lang.S.of(context).checkoutContact,
                      style: textTheme.titleLarge,
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
                                child: TextFormField(
                                  controller: _firstname,
                                  style: textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    labelText:
                                        lang.S.of(context).checkoutFirstName,
                                    hintText: lang.S
                                        .of(context)
                                        .checkoutFirstNamePlaceholder,
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
                                          .checkoutFirstNameRequired;
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
                                    labelText:
                                        lang.S.of(context).checkoutLastName,
                                    hintText: lang.S
                                        .of(context)
                                        .checkoutLastNamePlaceholder,
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
                                          .checkoutLastNameRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Text(
                      lang.S.of(context).checkoutShopping,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: horizonSpace,
                      bottom: verticalSpace,
                    ),
                    itemCount: _carts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, i) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: itemSpace,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: horizonSpace,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        OverlayEntry overlayEntry =
                                            OverlayEntry(
                                          builder: (context) => Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              child: const LoadingCircle(),
                                            ),
                                          ),
                                        );
                                        Overlay.of(context)
                                            .insert(overlayEntry);

                                        HttpService httpService = HttpService();
                                        httpService
                                            .getproductbyid(
                                                _carts[i].productid, null)
                                            .then((value) {
                                          var data =
                                              json.decode(value.toString());
                                          if (data["statusCode"] == 200) {
                                            overlayEntry.remove();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(
                                                  product: Product.fromMap(
                                                      data["data"]),
                                                ),
                                              ),
                                            );
                                          } else {
                                            overlayEntry.remove();
                                          }
                                        });
                                      },
                                      child: CachedNetworkImage(
                                        memCacheWidth: 90,
                                        imageUrl: _carts[i].productphoto!,
                                      ),
                                      /*Image(
                                        width: 90,
                                        image: CachedNetworkImageProvider(
                                          _carts[i].productphoto!,
                                        ),
                                      ),*/
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _carts[i].brandtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: textTheme.displaySmall,
                                        ),
                                        Text(
                                          _carts[i].producttitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: textTheme.displayMedium,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${lang.S.of(context).checkoutQty}: 1',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                color: darkColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              '${lang.S.of(context).checkoutSize}: ${_carts[i].sizetitle}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                color: darkColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ExchangePrice(
                                      price: _carts[i].price,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: redColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Divider(
                            color: lightbackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: horizonSpace,
        ),
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: darkColor,
          ),
          child: Text(
            lang.S.of(context).commonPayment,
            style: textTheme.titleSmall?.copyWith(
              color: whiteColor,
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_selected.isEmpty) {
                setState(() {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return WarnModal(
                        title: 'Alert',
                        message: lang.S.of(context).checkoutAlert,
                      );
                    },
                  );
                });
              } else {
                /*launchUrl(
                  Uri.parse(
                      'https://www.vetrinamia.com.cn/paymentms/mobilecnpayment?memberid=${_member.memberid}&shippinglocationid=$_selected&shippingtype=$_shippingtype&ispreorder=$_ispreorder&amt=$_subtotal'),
                  mode: LaunchMode.externalApplication,
                );*/
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Payment(
                      shippinglocationid: _selected,
                    ),
                  ),
                );*/
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectPayment(
                      shippinglocationid: _selected,
                      shippingtype: "B",
                      ispreorder: "n",
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
