import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../brand/homebrand.dart';
import '../brand/designer.dart';
import '../brand/collectiondetail.dart';
import '../brand/memberplan.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import '../cart/cart_provider.dart';
import '../cart/cart.dart';
import '../cart/preorder.dart';
import '../profile/faqdetail.dart';
import 'photoview.dart';
import 'sizetable.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _size = TextEditingController();
  final CarouselController _controller = CarouselController();
  final List<ProductMedia> _photos = [];
  final List<Product> _productsbybrand = [];
  final List<Product> _productsbycollection = [];
  final List<OrderDetailMessage> _messages = [];
  final List<Manufacture> _manufactures = [];
  final List<Designer> _designers = [];
  final List<Faq> _faqs = [];
  final List<VSize> _sizes = [];
  final List<Collection> _collections = [];
  final List<Carts> _carts = [];

  late CartChangeProvider _cartChangeProvider;
  late AuthChangeProvider _authChangeProvider;
  late Product _product;
  late Brand _brand;
  late Setup _setup;
  late bool _isSetupLoading = false;
  late bool _isBrandLoading = false;
  late bool _isPhotoLoading = false;
  late bool _isProductByBrandLoading = false;
  late bool _isProductByCollectionLoading = false;
  late bool _isMessageLoading = false;
  late bool _isManufactureLoading = false;
  late bool _isFaqLoading = false;
  late bool _isDesignerLoading = false;
  late bool _isSizeLoading = false;
  late bool _isCollectionLoading = false;
  late bool lastStatus = false;
  late bool _isMembershipFree = false;
  late int _selectedIndex = 0; // index of the selected photo
  late String selectedSize = ""; //購買尺寸
  late int buyamount = 1; //購買數量
  late bool isStock = true;
  late double _price;

  @override
  void initState() {
    super.initState();

    _cartChangeProvider =
        Provider.of<CartChangeProvider>(context, listen: false);
    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);

    _product = widget.product;

    getBrand();
    getPhotos();
    getProductsByBrandID();
    getProductsByCollectionID();
    getMessages();
    getManufactures();
    getFaqs();
    getDesigners();
    if (_product.productsizes!.length > 1) getSizes();
    getCollections();
    getSetup();

    if (_product.productsizes!.isNotEmpty) {
      setState(() {
        _size.text = _product.productsizes![0].size;
        selectedSize = _product.productsizes![0].productsizeid;
        if (_product.productsizes![0].inventory <= 0) {
          isStock = false;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSetup() async {
    if (!_isSetupLoading && mounted) {
      setState(() {
        _isSetupLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getsetup().then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _setup = Setup.fromMap(data["data"]);
            _isMembershipFree = (_setup.ischargemembershipfee == 0);
            _isSetupLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _isSetupLoading = false;
          });
        }
      });
    }
  }

  Future<void> getPhotos() async {
    if (!_isPhotoLoading && mounted) {
      setState(() {
        _isPhotoLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getproductmediasbyid(_product.productid).then((value) {
        var data = json.decode(value.toString());

        log('getphotos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _photos.addAll((data["data"] as List)
                .map((e) => ProductMedia.fromMap(e))
                .toList());
            _isPhotoLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getphotos isloading');
            _isPhotoLoading = false;
          });
        }
      });
    }
  }

  Future<void> getBrand() async {
    if (!_isBrandLoading && mounted) {
      setState(() {
        _isBrandLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getbrandbyid(_product.brandid, null).then((value) {
        var data = json.decode(value.toString());

        log('getbrand code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _brand = Brand.fromMap(data["data"]);
            _isBrandLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getbrand isloading');
            _isBrandLoading = false;
          });
        }
      });
    }
  }

  Future<void> getDesigners() async {
    if (!_isDesignerLoading && mounted) {
      setState(() {
        _isDesignerLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getdesignerlistsbybrandid(widget.product.brandid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getdesigners code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _designers.addAll((data["data"] as List)
                .map((e) => Designer.fromMap(e))
                .toList());

            _isDesignerLoading = false;

            log('getdesigners isloading: $_isDesignerLoading');
          });
        } else if (mounted) {
          setState(() {
            _isDesignerLoading = false;

            log('getdesigners isloading');
          });
        }
      });
    }
  }

  Future<void> getProductsByBrandID() async {
    if (!_isProductByBrandLoading && mounted) {
      setState(() {
        _isProductByBrandLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getproductlistswithoutselfbybrandid(_product.brandid,
              _product.productid, _product.collectionid!, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getproductsbybrand code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _productsbybrand.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _isProductByBrandLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getproductsbybrand isloading');
            _isProductByBrandLoading = false;
          });
        }
      });
    }
  }

  Future<void> getProductsByCollectionID() async {
    if (!_isProductByCollectionLoading && mounted) {
      setState(() {
        _isProductByCollectionLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getproductlistswithoutselfbycollectionid(
              _product.collectionid!, _product.productid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getproductsbycollection code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _productsbycollection.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _isProductByCollectionLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getproductsbycollection isloading');
            _isProductByCollectionLoading = false;
          });
        }
      });
    }
  }

  Future<void> getMessages() async {
    if (!_isMessageLoading && mounted) {
      setState(() {
        _isMessageLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getorderdetailmessagesbyproductid(_product.productid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getmessages code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _messages.addAll((data["data"] as List)
                .map((e) => OrderDetailMessage.fromMap(e))
                .toList());
            _isMessageLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getmessages isloading');
            _isMessageLoading = false;
          });
        }
      });
    }
  }

  Future<void> getManufactures() async {
    if (!_isManufactureLoading && mounted) {
      setState(() {
        _isManufactureLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getmanufacturelistsbyproductid(_product.productid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getmanufactures code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _manufactures.addAll((data["data"] as List)
                .map((e) => Manufacture.fromMap(e))
                .toList());
            _isManufactureLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getmanufactures isloading');
            _isManufactureLoading = false;
          });
        }
      });
    }
  }

  Future<void> getFaqs() async {
    if (!_isFaqLoading && mounted) {
      setState(() {
        _isFaqLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getfaqlists(null).then((value) {
        var data = json.decode(value.toString());

        log('getfaqs code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _faqs.addAll((data["data"] as List)
                .skip(1)
                .map((e) => Faq.fromMap(e))
                .toList());
            _isFaqLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getfaqs isloading');
            _isFaqLoading = false;
          });
        }
      });
    }
  }

  Future<void> getSizes() async {
    if (!_isSizeLoading && mounted) {
      setState(() {
        _isSizeLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getsizelistsbycategoryidandtype(
              _product.categoryid, _product.sizetype!)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _sizes.addAll(
                (data["data"] as List).map((e) => VSize.fromMap(e)).toList());
            _isSizeLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getsize isloading');
            _isSizeLoading = false;
          });
        }
      });
    }
  }

  Future<void> getCollections() async {
    if (!_isCollectionLoading && mounted) {
      setState(() {
        _isCollectionLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcollectionlistsbybrandid(widget.product.brandid, 0, 10, null)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _collections.addAll((data["data"] as List)
                .map((e) => Collection.fromMap(e))
                .toList());
            _isCollectionLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _isCollectionLoading = false;
          });
        }
      });
    }
  }

  void validate() {
    if (selectedSize == "") {
      sizeselect();
    }
  }

  void alert(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WarnModal(
          title: 'Alert',
          message: message,
        );
      },
    );
  }

  void sizeselect() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            left: horizonSpace,
            right: horizonSpace,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              Text(
                lang.S.of(context).productdetailSelectSize,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              ProductSizePicker(
                productsize: _product.productsizes!,
                onSelectedItemChanged: (index) {
                  ProductSize productsize = _product.productsizes![index];
                  setState(() {
                    _size.text = productsize.size;
                    selectedSize = productsize.productsizeid;
                    if (productsize.inventory <= 0) {
                      isStock = false;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getPrice() {
    _price = _product.price;

    if (!_isSetupLoading) {
      if (_setup.discounttype == 0) {
        if (_authChangeProvider.status &&
            _authChangeProvider.member.membershipfees!.isNotEmpty &&
            _authChangeProvider.member.membershipfees!
                .any((e) => e.brandmemberplan!.brandid == _product.brandid)) {
          _price = _product.discountprice;
        }
      } else if (_setup.discounttype == 1) {
        if (_authChangeProvider.status &&
            _authChangeProvider.member.membershipfees!.isNotEmpty &&
            _authChangeProvider.member.membershipfees!
                .any((e) => e.brandmemberplan!.brandid == _product.brandid)) {
          MembershipFee membershipfee =
              _authChangeProvider.member.membershipfees!.singleWhere(
                  (e) => e.brandmemberplan!.brandid == _product.brandid);

          _price = _product.price * membershipfee.brandmemberplan!.promote;
          _price = _price.roundToDouble();
        }
      }
    }
    return _price;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Builder(
          //builer產生自己的newContext，屬於上層Scaffold
          builder: (BuildContext newContext) => NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool isScrolled) {
              return [
                SliverAppBar(
                  toolbarHeight: 44,
                  elevation: 0.0,
                  backgroundColor: whiteColor,
                  surfaceTintColor: whiteColor,
                  centerTitle: true,
                  title: Text(
                    _product.title,
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconTheme: const IconThemeData(
                    color: lightIconColor,
                  ),
                  actions: [
                    ProductFavoriteIcon(
                      product: _product,
                    ),
                    const CartIcon(),
                  ],
                  floating: true,
                  snap: true,
                  pinned: true,
                )
              ];
            },
            physics: const BouncingScrollPhysics(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isPhotoLoading
                      ? Shimmer.fromColors(
                          baseColor: shimmerbaseColor,
                          highlightColor: shimmerhilightColor,
                          child: Container(
                            height: 480,
                            color: whiteColor,
                          ),
                        )
                      : _photos.isEmpty
                          ? const SizedBox()
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                CarouselSlider.builder(
                                  options: CarouselOptions(
                                    height: 480,
                                    aspectRatio: 3 / 4,
                                    viewportFraction: 1,
                                    enableInfiniteScroll: false,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                  ),
                                  carouselController: _controller,
                                  itemCount: _photos.length,
                                  itemBuilder: (BuildContext context, int index,
                                          int realIndex) =>
                                      Padding(
                                    padding: const EdgeInsets.only(
                                      right: 0.0,
                                      left: 0.0,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Photoview(
                                              productmedias: _photos,
                                              initialindex: index,
                                              tag:
                                                  _photos[index].productmediaid,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: _photos[index].productmediaid,
                                        child: Image(
                                          width: 480,
                                          image: NetworkImage(
                                            _photos[index].url,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Row(
                                    children: _photos
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => Container(
                                            width: 35.0,
                                            height: 3.0,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 0.0,
                                              horizontal: 0.0,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: _selectedIndex == entry.key
                                                  ? darkColor
                                                  : lightbackgroundColor,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: verticalSpace,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Row(
                      children: [
                        InkWell(
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
                                .getbrandbyid(_product.brandid, null)
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
                          child: Text(
                            _product.brandtitle.toUpperCase(),
                            style: textTheme.displayMedium,
                          ),
                        ),
                        const Spacer(),
                        if (!_isManufactureLoading && _manufactures.isNotEmpty)
                          Row(
                            children: [
                              Text(
                                lang.S.of(context).productdetailMadeIn,
                                style: textTheme.titleSmall,
                              ),
                              const SizedBox(width: 5),
                              Image(
                                width: 15,
                                image: NetworkImage(_manufactures[0].flagurl!),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _product.title,
                          style: textTheme.titleSmall,
                        ),
                        const Spacer(),
                        Text(
                          lang.S.of(context).productdetailItaly,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: ProductPrice(product: _product),
                  ),
                  if (_product.isselling == "n")
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 3,
                        left: horizonSpace,
                        right: horizonSpace,
                      ),
                      child: Text(
                        lang.S.of(context).commonOutStock,
                        style: textTheme.titleSmall?.copyWith(color: redColor),
                      ),
                    ),

                  if (!_isSetupLoading && _setup.discounttype == 1) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: horizonSpace,
                        right: horizonSpace,
                      ),
                      child: ExpansionTile(
                        backgroundColor: bggray100,
                        dense: true,
                        initiallyExpanded: false,
                        tilePadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 3,
                        ),
                        childrenPadding: const EdgeInsets.only(
                          top: 0,
                          left: 20,
                          bottom: 3,
                        ),
                        title: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              lang.S
                                  .of(context)
                                  .productdetailClubInsiderPricing,
                              style: textTheme.titleSmall,
                            )
                          ],
                        ),
                        children: [
                          ClubInsiderPrice(
                            brandmemberplans: _brand.brandmemberplans,
                            product: _product,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_product.videourl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: horizonSpace,
                        right: horizonSpace,
                      ),
                      child: VideoPlay(
                        pathh: _product.videourl!,
                        isautoplay: true,
                        control: true,
                      ),
                    ),
                  _product.summary == null || _product.summary == ''
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Text(
                            _product.summary!,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Divider(
                      color: lightbackgroundColor,
                    ),
                  ),
                  if (_product.productsizes!.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Sizetable(
                                    sizes: _sizes,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              lang.S.of(context).productdetailSizeGuide,
                              style: textTheme.titleSmall?.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _size,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: false,
                              fillColor: colorScheme.secondaryContainer,
                              contentPadding: const EdgeInsets.only(
                                left: 56,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                ),
                              ),
                              hintText: lang.S
                                  .of(context)
                                  .productdetailPleaseSelectSize,
                              hintStyle: textTheme.bodyMedium,
                              suffixIcon: const Icon(
                                IconlyLight.arrowDown2,
                              ),
                            ),
                            onTap: () => sizeselect(),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Column(
                      children: [
                        ExpansionTile(
                          dense: true,
                          initiallyExpanded: false,
                          tilePadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          childrenPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          title: Text(
                            lang.S.of(context).productdetailDesignDetails,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            _product.content == ''
                                ? const SizedBox()
                                : Text(
                                    _product.content ?? '',
                                    style: textTheme.bodySmall,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Row(
                                children: [
                                  Text(
                                    lang.S.of(context).productdetailDesignIn,
                                    style: textTheme.titleSmall,
                                  ),
                                  const SizedBox(width: 5),
                                  Image(
                                    width: 15,
                                    image: NetworkImage(_product.flagurl!),
                                  ),
                                ],
                              ),
                            ),
                            if (!_isManufactureLoading &&
                                _manufactures.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  children: [
                                    Text(
                                      lang.S.of(context).productdetailMadeIn,
                                      style: textTheme.titleSmall,
                                    ),
                                    const SizedBox(width: 5),
                                    Image(
                                      width: 15,
                                      image: NetworkImage(
                                          _manufactures[0].flagurl!),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        /*const Divider(
                          color: lightbackgroundColor,
                        ),
                        _isManufactureLoading
                            ? Container()
                            : ExpansionTile(
                                dense: true,
                                initiallyExpanded: false,
                                tilePadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                childrenPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                title: Text(
                                  lang.S.of(context).productdetailMaterial,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  _manufactures[0].videourl!.isNotEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
                                          child: VideoPlay(
                                            pathh: _manufactures[0].videourl!,
                                            isautoplay: false,
                                            control: true,
                                          ),
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Row(
                                      children: [
                                        Text(
                                          lang.S
                                              .of(context)
                                              .productdetailMaterialFrom,
                                          style: textTheme.titleSmall,
                                        ),
                                        const SizedBox(width: 5),
                                        Image(
                                          image: NetworkImage(
                                              _product.materialflagurl!),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _manufactures[0].content == ''
                                      ? Container()
                                      : Text(
                                          _manufactures[0].content ?? '',
                                          style: textTheme.bodySmall,
                                        ),
                                ],
                              ),*/
                        const Divider(
                          color: lightbackgroundColor,
                        ),
                        ExpansionTile(
                          dense: true,
                          initiallyExpanded: false,
                          tilePadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          childrenPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          title: Text(
                            lang.S.of(context).productdetailProductCare,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            Text(
                              _product.productcare ?? '',
                              style: textTheme.bodySmall,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const Divider(
                          color: lightbackgroundColor,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _faqs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: bggray100,
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Faqdetail(faq: _faqs[index]),
                                  ),
                                );
                              },
                              contentPadding:
                                  const EdgeInsets.only(left: 5, right: 5),
                              title: Text(
                                _faqs[index].title,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                color: darkColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _isMessageLoading
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: verticalSpace,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: shimmerbaseColor,
                            highlightColor: shimmerhilightColor,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Container(
                                color: whiteColor,
                              ),
                            ),
                          ),
                        )
                      : _messages.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: verticalSpace,
                                left: horizonSpace,
                                right: horizonSpace,
                              ),
                              child: ListView.builder(
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: false,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _messages.length,
                                itemBuilder: (_, i) {
                                  return Card(
                                    elevation: 1,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: colorScheme.secondaryContainer,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(6),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                              vertical: -2,
                                            ),
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                _messages[i].memberphoto,
                                              ),
                                              radius: 25,
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_messages[i].firstname} ${_messages[i].lastname}',
                                                  style: textTheme.titleSmall,
                                                ),
                                                Text(
                                                  _messages[i].createdate,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                          color:
                                                              lightTitleColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            _messages[i].message,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              color: lightTitleColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
                  //________________________________________________________Shop the collection
                  _productsbycollection.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: verticalSpace,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Text(
                            lang.S.of(context).productdetailShoptheCollection,
                            style: textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                  _isProductByCollectionLoading
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: shimmerbaseColor,
                            highlightColor: shimmerhilightColor,
                            child: Container(
                              height: 395,
                              color: whiteColor,
                            ),
                          ),
                        )
                      : _productsbycollection.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: ProductsHorizonSlideList(
                                  products: _productsbycollection),
                            )
                          : const SizedBox(),
                  //________________________________________________________Shop the brand
                  _productsbybrand.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: verticalSpace,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Text(
                            lang.S.of(context).productdetailShoptheBrand,
                            style: textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                  _isProductByBrandLoading
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: shimmerbaseColor,
                            highlightColor: shimmerhilightColor,
                            child: Container(
                              height: 395,
                              color: whiteColor,
                            ),
                          ),
                        )
                      : _productsbybrand.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: ProductsHorizonSlideList(
                                  products: _productsbybrand),
                            )
                          : const SizedBox(),
                  //________________________________________________________brand
                  _isBrandLoading
                      ? const SizedBox()
                      : _brand.summary == null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: verticalSpace,
                                left: horizonSpace,
                                right: horizonSpace,
                              ),
                              child: Column(
                                children: [
                                  ImageStackCard(
                                    url: _brand.landscapeurl!,
                                    width: 1194,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(50.0),
                                    width: double.infinity,
                                    color: bggray100,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _brand.title,
                                                style: textTheme.titleLarge,
                                              ),
                                              const SizedBox(width: 5),
                                              Image(
                                                width: 15,
                                                image: NetworkImage(
                                                    _brand.flagurl!),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          _brand.summary!,
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodySmall,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20.0,
                                            left: horizonSpace,
                                            right: horizonSpace,
                                          ),
                                          child: Center(
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                OverlayEntry overlayEntry =
                                                    OverlayEntry(
                                                  builder: (context) =>
                                                      Positioned(
                                                    top: 0,
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      child:
                                                          const LoadingCircle(),
                                                    ),
                                                  ),
                                                );
                                                Overlay.of(context)
                                                    .insert(overlayEntry);

                                                HttpService httpService =
                                                    HttpService();
                                                await httpService
                                                    .getbrandbyid(
                                                        widget.product.brandid,
                                                        null)
                                                    .then((value) {
                                                  var data = json
                                                      .decode(value.toString());
                                                  if (data["statusCode"] ==
                                                      200) {
                                                    overlayEntry.remove();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Homebrand(
                                                          brand: Brand.fromMap(
                                                              data["data"]),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    overlayEntry.remove();
                                                  }
                                                });
                                              },
                                              child: Text(
                                                lang.S
                                                    .of(context)
                                                    .productdetailDiscover,
                                                style: textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: darkColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: verticalSpace,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Center(
                      child: Text(
                        lang.S.of(context).productdetailShare,
                        style: textTheme.titleLarge,
                      ),
                    ),
                  ),
                  _isDesignerLoading
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: horizonSpace,
                            right: horizonSpace,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: bggray100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageStackCard(
                                  url: _designers[0].portraiturl!,
                                  width: 140,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                _designers[0].title,
                                                maxLines: 2,
                                                softWrap: true,
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Image(
                                              image: NetworkImage(
                                                  _designers[0].flagurl),
                                              width: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          bottom: 15,
                                        ),
                                        child: Text(
                                          _designers[0].summary ?? '',
                                          textAlign: TextAlign.left,
                                          style: textTheme.bodySmall,
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          OverlayEntry overlayEntry =
                                              OverlayEntry(
                                            builder: (context) => Positioned(
                                              top: 0,
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                child: const LoadingCircle(),
                                              ),
                                            ),
                                          );
                                          Overlay.of(context)
                                              .insert(overlayEntry);

                                          HttpService httpService =
                                              HttpService();
                                          await httpService
                                              .getbrandbyid(
                                                  widget.product.brandid, null)
                                              .then((value) {
                                            var data =
                                                json.decode(value.toString());
                                            if (data["statusCode"] == 200) {
                                              overlayEntry.remove();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Designers(
                                                    brand: Brand.fromMap(
                                                        data["data"]),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              overlayEntry.remove();
                                            }
                                          });
                                        },
                                        child: Text(
                                          'More',
                                          style: textTheme.titleSmall?.copyWith(
                                            color: darkColor,
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
                  ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    padding: const EdgeInsets.only(
                      top: verticalSpace,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _collections.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: itemSpace,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Collectiondetail(
                                collection: _collections[index],
                              ),
                            ),
                          );
                        },
                        child: ImageStackCard(
                          url: _collections[index].portraiturl!,
                          title: _collections[index].title,
                          subtitle: _collections[index].subtitle,
                          flagurl: _collections[index].flagurl,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: horizonSpace,
          ),
          width: MediaQuery.of(context).size.width,
          child: _isSetupLoading
              ? const SizedBox()
              : !isStock
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_product.isselling == "y") ...[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                lang.S.of(context).commonPreOrder,
                                style: textTheme.titleSmall?.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                              onPressed: () {
                                _price = getPrice();

                                Carts cart = Carts(
                                  productid: _product.productid,
                                  brandid: _product.brandid,
                                  brandtitle: _product.brandtitle,
                                  producttitle: _product.title,
                                  productphoto:
                                      _photos.isNotEmpty ? _photos[0].url : '',
                                  sizetitle: _size.text,
                                  productsizeid: selectedSize,
                                  quantity: buyamount,
                                  price: _price,
                                  discountprice: _product.discountprice,
                                  total: buyamount * _price,
                                );

                                _carts.clear();
                                _carts.add(cart);

                                if (_authChangeProvider.status) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Preorder(
                                        carts: _carts,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LogIn(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        _isBrandLoading
                            ? const SizedBox()
                            : MemberPlanIcon(
                                brand: _brand,
                              ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_product.isselling == "y") ...[
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkColor,
                              ),
                              child: Text(
                                lang.S.of(context).commonAddtoCart,
                                style: textTheme.titleSmall?.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                              onPressed: () {
                                if (selectedSize == "") {
                                  sizeselect();
                                } else {
                                  _price = getPrice();

                                  Carts cart = Carts(
                                    productid: _product.productid,
                                    brandid: _product.brandid,
                                    brandtitle: _product.brandtitle,
                                    producttitle: _product.title,
                                    productphoto: _photos.isNotEmpty
                                        ? _photos[0].url
                                        : '',
                                    sizetitle: _size.text,
                                    productsizeid: selectedSize,
                                    quantity: buyamount,
                                    price: _price,
                                    discountprice: _product.discountprice,
                                    total: buyamount * _price,
                                  );

                                  if (_authChangeProvider.status) {
                                    if (_cartChangeProvider.addCart(cart)) {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SafeArea(
                                          top: false,
                                          left: false,
                                          right: false,
                                          bottom: true,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.only(
                                              top: 20,
                                              left: horizonSpace,
                                              right: horizonSpace,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 10,
                                                  ),
                                                  child: Text(
                                                    lang.S
                                                        .of(context)
                                                        .productdetailAddSuccess,
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 20,
                                                      ),
                                                      child: Image(
                                                        width: 90,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          cart.productphoto!,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            cart.brandtitle
                                                                .toUpperCase(),
                                                            maxLines: 2,
                                                            softWrap: true,
                                                            style: textTheme
                                                                .displaySmall
                                                                ?.copyWith(
                                                              color: darkColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            cart.producttitle,
                                                            style: textTheme
                                                                .displaySmall,
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            '${lang.S.of(context).productdetailSize}: ${cart.sizetitle}',
                                                            style: textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                              color: darkColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 20,
                                                    ),
                                                    child: ExchangePrice(
                                                      price: cart.price,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        color: redColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 15,
                                                  ),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          darkColor,
                                                    ),
                                                    child: Text(
                                                      lang.S
                                                          .of(context)
                                                          .commonGotoCart,
                                                      style: textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Cart(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: whiteColor,
                                              title: const Text('Message'),
                                              content: Text(lang.S
                                                  .of(context)
                                                  .productdetailMessage),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    lang.S
                                                        .of(context)
                                                        .commonExit,
                                                    style: textTheme.titleSmall
                                                        ?.copyWith(
                                                            color: darkColor),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      });
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LogIn(),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        _isBrandLoading
                            ? const SizedBox()
                            : MemberPlanIcon(
                                brand: _brand,
                              ),
                      ],
                    ),
        ),
      ),
    );
  }
}
