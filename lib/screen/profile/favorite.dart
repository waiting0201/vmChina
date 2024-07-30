import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import '../category/productdetail.dart';
import '../brand/homebrand.dart';
import '../home/home.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite>
    with SingleTickerProviderStateMixin {
  final List<Product> _products = [];
  final List<Brand> _brands = [];
  final int _producttake = 10;
  final int _brandtake = 10;
  final List<String> _types = [
    "商品",
    "品牌",
  ];

  late TabController _tabcontroller;
  late AuthChangeProvider _authChangeProvider;
  late bool _isProductLoading = false;
  late bool _isBrandLoading = false;
  late bool _producthasMore = true;
  late bool _brandhasMore = true;
  late int _productskip = 0;
  late int _brandskip = 0;
  late Member _member;

  @override
  void initState() {
    super.initState();
    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    _member = _authChangeProvider.member;

    _tabcontroller = TabController(length: _types.length, vsync: this);

    getMemberProducts();
    getMemberBrands();
  }

  Future<void> getMemberProducts() async {
    if (_producthasMore && !_isProductLoading && mounted) {
      setState(() {
        _isProductLoading = true;
      });

      HttpService httpService = HttpService();

      await httpService
          .getmemberproductlists(
              _member.memberid, _productskip, _producttake, null)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _products.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _productskip = _productskip + _producttake;
            _isProductLoading = false;
            if ((data["data"] as List).length < _producttake) {
              _producthasMore = false;
            }
          });
        } else if (mounted) {
          setState(() {
            _isProductLoading = false;
            _producthasMore = false;
          });
        }
      });
    }
  }

  Future<void> getMemberBrands() async {
    if (_brandhasMore && !_isBrandLoading && mounted) {
      setState(() {
        _isBrandLoading = true;
      });

      HttpService httpService = HttpService();

      await httpService
          .getmemberbrandlists(_member.memberid, _brandskip, _brandtake, null)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _brands.addAll(
                (data["data"] as List).map((e) => Brand.fromMap(e)).toList());
            _brandskip = _brandskip + _brandtake;
            _isBrandLoading = false;
            if ((data["data"] as List).length < _brandtake) {
              _brandhasMore = false;
            }
          });
        } else if (mounted) {
          setState(() {
            _isBrandLoading = false;
            _brandhasMore = false;
          });
        }
      });
    }
  }

  Future<void> removeMemberProduct(String productid) async {
    HttpService httpService = HttpService();

    await httpService
        .removememberproduct(_member.memberid, productid)
        .then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200 && mounted) {
        setState(() {
          _products.removeWhere((e) => e.productid == productid);
        });
      } else {}
    });
  }

  Future<void> removeMemberBrand(String brandid) async {
    HttpService httpService = HttpService();

    await httpService
        .removememberbrand(_member.memberid, brandid)
        .then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200 && mounted) {
        setState(() {
          _brands.removeWhere((e) => e.brandid == brandid);
        });
      } else {}
    });
  }

  @override
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
          lang.S.of(context).favoriteMyFavorite,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(
              horizontal: horizonSpace,
            ),
            child: TabBar(
              controller: _tabcontroller,
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              tabs: _types
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
              labelPadding: const EdgeInsets.only(
                right: horizonSpace,
              ),
              indicatorPadding: const EdgeInsets.only(
                right: horizonSpace,
              ),
              onTap: (value) {},
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabcontroller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _isProductLoading
              ? const LoadingCircle()
              : _products.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {}
                        return false;
                      },
                      child: GridView.count(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.9,
                        shrinkWrap: true,
                        children: List.generate(
                          _producthasMore
                              ? _products.length + 2
                              : _products.length,
                          (index) {
                            if (index >= _products.length) {
                              return Shimmer.fromColors(
                                baseColor: shimmerbaseColor,
                                highlightColor: shimmerhilightColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 2,
                                    left: 2,
                                  ),
                                  child: Container(
                                    color: whiteColor,
                                  ),
                                ),
                              );
                            }
                            return InkWell(
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
                                    .getproductbyid(
                                        _products[index].productid, null)
                                    .then((value) {
                                  var data = json.decode(value.toString());
                                  if (data["statusCode"] == 200) {
                                    overlayEntry.remove();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                          product:
                                              Product.fromMap(data["data"]),
                                        ),
                                      ),
                                    );
                                  } else {
                                    overlayEntry.remove();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 2,
                                  right: 2,
                                ),
                                child: Card(
                                  elevation: 0.0,
                                  margin: const EdgeInsets.all(0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 3 / 4,
                                            child: Image(
                                              image: CachedNetworkImageProvider(
                                                _products[index].portraiturl!,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: IconButton(
                                              alignment: Alignment.centerRight,
                                              onPressed: () {
                                                removeMemberProduct(
                                                    _products[index].productid);
                                              },
                                              icon: const Icon(
                                                  Icons.delete_outline_sharp),
                                              color: primaryColor,
                                              iconSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _products[index].brandtitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: textTheme.displaySmall,
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              _products[index].title,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              softWrap: true,
                                              style: textTheme.displayMedium,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            ProductPrice(
                                                product: _products[index]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            IconlyLight.heart,
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
                              lang.S.of(context).favoriteNoProductCaption,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: Text(
                              lang.S.of(context).favoriteStartShopping,
                              style: textTheme.titleSmall?.copyWith(
                                color: whiteColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(
                                    bottomNavIndex: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
          _isBrandLoading
              ? const LoadingCircle()
              : _brands.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {}
                        return false;
                      },
                      child: GridView.count(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        shrinkWrap: true,
                        children: List.generate(
                          _brandhasMore ? _brands.length + 2 : _brands.length,
                          (index) {
                            if (index >= _brands.length) {
                              return Shimmer.fromColors(
                                baseColor: shimmerbaseColor,
                                highlightColor: shimmerhilightColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 2,
                                    left: 2,
                                  ),
                                  child: Container(
                                    color: whiteColor,
                                  ),
                                ),
                              );
                            }
                            return InkWell(
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
                                    .getbrandbyid(_brands[index].brandid, null)
                                    .then((value) {
                                  var data = json.decode(value.toString());
                                  if (data["statusCode"] == 200) {
                                    overlayEntry.remove();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Homebrand(
                                          brand: Brand.fromMap(data["data"]),
                                        ),
                                      ),
                                    );
                                  } else {
                                    overlayEntry.remove();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 2,
                                  right: 2,
                                  bottom: 4,
                                ),
                                child: GridTile(
                                  footer: GridTileBar(
                                    backgroundColor: Colors.black38,
                                    title: Text(
                                      _brands[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: textTheme.labelSmall,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 3 / 4,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                            _brands[index].portraiturl!,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          alignment: Alignment.centerRight,
                                          onPressed: () {
                                            removeMemberBrand(
                                                _brands[index].brandid);
                                          },
                                          icon: const Icon(
                                              Icons.delete_outline_sharp),
                                          color: primaryColor,
                                          iconSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            IconlyLight.heart,
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
                              lang.S.of(context).favoriteNoBrandCaption,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: Text(
                              lang.S.of(context).favoriteBrowseBrand,
                              style: textTheme.titleSmall?.copyWith(
                                color: whiteColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(
                                    bottomNavIndex: 1,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
