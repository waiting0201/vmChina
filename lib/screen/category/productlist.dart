import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../language/language_provider.dart';
import '../category/productdetail.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';

class Productlist extends StatefulWidget {
  final String categorytitle;
  final String categoryid;
  final String? subcategoryid;
  final String? thirdcategoryid;
  final String? brandid;
  final String? collectionid;
  final String? justforyouid;
  final String? whatsnewid;
  final String? eventid;
  final String? q;

  const Productlist({
    super.key,
    required this.categorytitle,
    required this.categoryid,
    this.subcategoryid,
    this.thirdcategoryid,
    this.brandid,
    this.collectionid,
    this.justforyouid,
    this.whatsnewid,
    this.eventid,
    this.q,
  });

  @override
  State<Productlist> createState() => _ProductlistState();
}

class _ProductlistState extends State<Productlist> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final List<Product> _products = [];
  final int _take = 20;

  late List<Product> filteredProducts = [];
  late List<String> _selectedColors = [];
  late List<String> _selectedSizes = [];
  late double _startInitValue;
  late double _endInitValue;
  late double _startValue = 0;
  late double _endValue = 0;

  late bool _isNewest = false;
  late bool _isPopularity = false;
  late bool _isPricelow = false;
  late bool _isPricehigh = false;

  late bool _isLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();

    getProducts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> getProducts() async {
    if (_hasMore && !_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getproductlistsbyparameters(
        _skip,
        _take,
        widget.categoryid,
        widget.subcategoryid,
        widget.thirdcategoryid,
        widget.brandid,
        widget.collectionid,
        widget.justforyouid,
        widget.whatsnewid,
        widget.eventid,
        widget.q,
        null,
      )
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _products.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _applyFilters();
            _skip = _skip + _take;
            _isLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;
          });
        } else if (mounted) {
          setState(() {
            _isLoading = false;
            _hasMore = false;
          });
        }
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      getProducts();
    }
  }

  void _applyFilters() {
    setState(() {
      filteredProducts = _products.where((product) {
        return (_selectedColors.isEmpty ||
                product.productcolors!
                    .map((e) => e.colorid)
                    .any((a) => _selectedColors.contains(a))) &&
            (_selectedSizes.isEmpty ||
                product.productsizes!
                    .map((e) => e.sizeid)
                    .any((a) => _selectedSizes.contains(a))) &&
            (_startValue == 0 || product.price >= _startValue) &&
            (_endValue == 0 || product.price <= _endValue);
      }).toList();
    });
  }

  void _updatePriceFilterValues(double? startprice, double? endprice) {
    setState(() {
      _startValue = startprice!.round().toDouble();
      _endValue = endprice!.round().toDouble();
      _skip = 0;
      _products.clear();
      filteredProducts.clear();
      getProducts();
    });
  }

  void _updateColorFilterValues(List<String>? colors) {
    setState(() {
      _selectedColors = colors!;
      _skip = 0;
      _products.clear();
      filteredProducts.clear();
      getProducts();
    });
  }

  void _updateSizeFilterValues(List<String>? sizes) {
    setState(() {
      _selectedSizes = sizes!;
      _skip = 0;
      _products.clear();
      filteredProducts.clear();
      getProducts();
    });
  }

  void _updateSortValues(
    isNewest,
    isPopularity,
    isPricelow,
    isPricehigh,
  ) {
    setState(() {
      _isNewest = isNewest;
      _isPopularity = isPopularity;
      _isPricelow = isPricelow;
      _isPricehigh = isPricehigh;

      if (_isNewest) {
        return filteredProducts
            .sort((a, b) => -a.createdate.compareTo(b.createdate));
      } else if (_isPopularity) {
        return filteredProducts.sort((a, b) => -a.popular.compareTo(b.popular));
      } else if (_isPricelow) {
        return filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (_isPricehigh) {
        return filteredProducts.sort((a, b) => -a.price.compareTo(b.price));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future selectfilter(BuildContext context, int selectindex) {
    //TextTheme textTheme = Theme.of(context).textTheme;

    return showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) => DefaultTabController(
        initialIndex: selectindex,
        length: 3,
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: horizonSpace,
            right: horizonSpace,
          ),
          height: 250,
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: TabBar(
                  padding: const EdgeInsets.only(
                    left: 4,
                    bottom: 5,
                  ),
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: lang.S.of(context).productlistSize,
                    ),
                    Tab(
                      text: lang.S.of(context).productlistPrice,
                    ),
                    Tab(
                      text: lang.S.of(context).productlistColor,
                    )
                  ],
                  labelPadding: const EdgeInsets.only(
                    right: horizonSpace,
                  ),
                  indicatorPadding: const EdgeInsets.only(
                    right: horizonSpace,
                  ),
                  onTap: (index) {
                    if (_products.isNotEmpty) {
                      setState(() {
                        _startInitValue = _startValue =
                            _products.map<double>((e) => e.price).reduce(min);
                        _endInitValue = _endValue =
                            _products.map<double>((e) => e.price).reduce(max);

                        selectindex = index;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SizeFilter(
                      context: context,
                      onChanged: _updateSizeFilterValues,
                      products: _products,
                      categoryid: widget.categoryid,
                    ),
                    PriceFilter(
                      onChanged: _updatePriceFilterValues,
                      startValue: _products.isNotEmpty ? _startInitValue : 0,
                      endValue: _products.isNotEmpty ? _endInitValue : 0,
                      startlastValue: _products.isNotEmpty ? _startValue : 0,
                      endlastValue: _products.isNotEmpty ? _endValue : 0,
                    ),
                    ColorFilter(
                      onChanged: _updateColorFilterValues,
                      products: _products,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: whiteColor,
      key: _key,
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        centerTitle: true,
        title: Text(
          widget.categorytitle,
          style: textTheme.titleLarge,
        ),
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: const [
          CartIcon(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(
                left: horizonSpace, right: horizonSpace, bottom: 10),
            child: SizedBox(
              height: 25,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      selectfilter(context, 0);
                      if (_products.isNotEmpty) {
                        setState(() {
                          _startInitValue = _startValue =
                              _products.map<double>((e) => e.price).reduce(min);
                          _endInitValue = _endValue =
                              _products.map<double>((e) => e.price).reduce(max);
                        });
                      }
                    },
                    child: Text(
                      lang.S.of(context).productlistSize,
                      style: textTheme.titleSmall?.copyWith(color: darkColor),
                    ),
                  ),
                  const SizedBox(width: itemSpace),
                  OutlinedButton(
                    onPressed: () {
                      selectfilter(context, 1);
                      if (_products.isNotEmpty) {
                        setState(() {
                          _startInitValue = _startValue =
                              _products.map<double>((e) => e.price).reduce(min);
                          _endInitValue = _endValue =
                              _products.map<double>((e) => e.price).reduce(max);
                        });
                      }
                    },
                    child: Text(
                      lang.S.of(context).productlistPrice,
                      style: textTheme.titleSmall?.copyWith(color: darkColor),
                    ),
                  ),
                  const SizedBox(width: itemSpace),
                  OutlinedButton(
                    onPressed: () {
                      selectfilter(context, 2);
                      if (_products.isNotEmpty) {
                        setState(() {
                          _startInitValue = _startValue =
                              _products.map<double>((e) => e.price).reduce(min);
                          _endInitValue = _endValue =
                              _products.map<double>((e) => e.price).reduce(max);
                        });
                      }
                    },
                    child: Text(
                      lang.S.of(context).productlistColor,
                      style: textTheme.titleSmall?.copyWith(color: darkColor),
                    ),
                  ),
                  const SizedBox(width: itemSpace),
                  OutlinedButton(
                    onPressed: () {
                      _key.currentState!.openEndDrawer();
                    },
                    child: Text(
                      lang.S.of(context).productlistRefine,
                      style: textTheme.titleSmall?.copyWith(color: darkColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: horizonSpace,
                    bottom: 10,
                  ),
                  child: Text(
                    lang.S.of(context).productlistSortBy,
                    style: textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  title: Text(
                    lang.S.of(context).productlistNewest,
                    style: textTheme.bodyMedium,
                  ),
                  trailing:
                      _isNewest ? const Icon(Icons.check) : const Text(''),
                  onTap: () {
                    setState(() {
                      _updateSortValues(true, false, false, false);
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    lang.S.of(context).productlistPopularity,
                    style: textTheme.bodyMedium,
                  ),
                  trailing:
                      _isPopularity ? const Icon(Icons.check) : const Text(''),
                  onTap: () {
                    setState(() {
                      _updateSortValues(false, true, false, false);
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    lang.S.of(context).productlistPriceLow,
                    style: textTheme.bodyMedium,
                  ),
                  trailing:
                      _isPricelow ? const Icon(Icons.check) : const Text(''),
                  onTap: () {
                    setState(() {
                      _updateSortValues(false, false, true, false);
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    lang.S.of(context).productlistPriceHigh,
                    style: textTheme.bodyMedium,
                  ),
                  trailing:
                      _isPricehigh ? const Icon(Icons.check) : const Text(''),
                  onTap: () {
                    setState(() {
                      _updateSortValues(false, false, false, true);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingCircle()
          : _products.isEmpty
              ? Center(
                  child: Text(
                    'Coming Soon',
                    style: textTheme.titleLarge,
                    textAlign: TextAlign.justify,
                  ),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: verticalSpace,
                    ),
                    child: Consumer<LanguageChangeProvider>(
                      builder: (context, language, child) {
                        return !language.status
                            ? const SizedBox()
                            : GridView.count(
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: false,
                                padding: const EdgeInsets.only(
                                  left: 13,
                                  right: 13,
                                ),
                                crossAxisCount: 2,
                                childAspectRatio: 1 / 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(
                                  filteredProducts.length,
                                  (index) {
                                    return InkWell(
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
                                                filteredProducts[index]
                                                    .productid,
                                                null)
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 2,
                                          right: 2,
                                        ),
                                        child: ProductCard(
                                          product: filteredProducts[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                  ),
                ),
    );
  }
}
