import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../category/productdetail.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'cart_provider.dart';
import 'cartempty.dart';
import 'checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late CartChangeProvider _cartChangeProvider;
  late AuthChangeProvider _authChangeProvider;
  late List<Carts> _carts = [];

  @override
  void initState() {
    super.initState();
    getCarts();
  }

  void getCarts() {
    setState(() {
      _cartChangeProvider =
          Provider.of<CartChangeProvider>(context, listen: false);
      _authChangeProvider =
          Provider.of<AuthChangeProvider>(context, listen: false);
      _carts = _cartChangeProvider.carts;
    });
  }

  void removeCart(String productid) {
    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    _cartChangeProvider.removeCart(productid);
    if (_cartChangeProvider.carts.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CartEmpty()),
      );
    } else {
      setState(() {
        _carts = _cartChangeProvider.carts;
      });
    }
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          lang.S.of(context).cartTitle,
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: CartSummary(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: verticalSpace,
        ),
        itemCount: _carts.length,
        shrinkWrap: true,
        itemBuilder: (_, i) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: InkWell(
                          onTap: () {
                            OverlayEntry overlayEntry = OverlayEntry(
                              builder: (context) => Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: const LoadingCircle(),
                                ),
                              ),
                            );
                            Overlay.of(context).insert(overlayEntry);

                            HttpService httpService = HttpService();
                            httpService
                                .getproductbyid(_carts[i].productid, null)
                                .then((value) {
                              var data = json.decode(value.toString());
                              if (data["statusCode"] == 200) {
                                overlayEntry.remove();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      product: Product.fromMap(data["data"]),
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
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  '${lang.S.of(context).cartQty}: 1',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: darkColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  '${lang.S.of(context).cartSize}: ${_carts[i].sizetitle}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall?.copyWith(
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
                        child: IconButton(
                          onPressed: () {
                            removeCart(_carts[i].productid);
                          },
                          icon: const Icon(Icons.delete_outline_sharp),
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: ExchangePrice(
                        price: _carts[i].price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: redColor,
                        ),
                      ),
                    ),
                  )
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
            lang.S.of(context).cartCheckOut,
            style: textTheme.titleSmall?.copyWith(
              color: whiteColor,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _authChangeProvider.status
                    ? const Checkout()
                    : const LogIn(),
              ),
            );
          },
        ),
      ),
    );
  }
}
