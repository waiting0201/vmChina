import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../authentication/sign_up.dart';
import '../widgets/common.dart';
import '../widgets/carousel.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'collectiondetail.dart';
import 'designer.dart';

class Homebrand extends StatefulWidget {
  final Brand brand;
  const Homebrand({
    super.key,
    required this.brand,
  });

  @override
  State<Homebrand> createState() => _HomebrandState();
}

class _HomebrandState extends State<Homebrand> {
  final List<Collection> _collections = [];
  final List<BrandMedia> _brandphotos = [];
  final List<Designer> _designers = [];
  final List<Product> _products = [];
  final List<Category> _categorys = [];

  late AuthChangeProvider _authChangeProvider;
  late bool _isCollectionLoading = false;
  late bool _isBrandPhotoLoading = false;
  late bool _isDesignerLoading = false;
  late bool _isProductLoading = false;
  late bool _isCategoryLoading = false;

  @override
  void initState() {
    super.initState();
    _authChangeProvider =
        Provider.of<AuthChangeProvider>(context, listen: false);

    /*bool isbrandmember = _authChangeProvider.status &&
        _authChangeProvider.member.membershipfees!.isNotEmpty &&
        _authChangeProvider.member.membershipfees!
            .any((e) => e.brandmemberplan!.brandid == widget.brand.brandid);*/

    if (!_authChangeProvider.status && widget.brand.publishstatus != 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAlertDialog();
      });
    }

    getBrandPhotos();
    getDesigners();
    getCollections();
    getProducts();
    getCategorys();
  }

  void _showAlertDialog() {
    TextTheme textTheme = Theme.of(context).textTheme;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        icon: const Icon(
          Icons.person,
          size: 50,
        ),
        iconColor: primaryColor,
        backgroundColor: whiteColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lang.S.of(context).homebrandNotifyTitle(widget.brand.title),
              style: textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          lang.S.of(context).homebrandNotifyCaption,
          textAlign: TextAlign.center,
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context, false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              );
            },
            child: Text(
              lang.S.of(context).commonRegister,
              style: textTheme.titleSmall?.copyWith(
                color: darkColor,
              ),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: darkColor,
            ),
            onPressed: () {
              Navigator.pop(context, false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogIn(),
                ),
              );
            },
            child: Text(
              lang.S.of(context).commonSignIn,
              style: textTheme.titleSmall?.copyWith(
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getBrandPhotos() async {
    if (!_isBrandPhotoLoading) {
      setState(() {
        _isBrandPhotoLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getbrandmediasbyid(widget.brand.brandid).then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200) {
          setState(() {
            _brandphotos.addAll((data["data"] as List)
                .map((e) => BrandMedia.fromMap(e))
                .toList());
            _isBrandPhotoLoading = false;
          });
        } else {
          setState(() {
            _isBrandPhotoLoading = false;
          });
        }
      });
    }
  }

  Future<void> getDesigners() async {
    if (!_isDesignerLoading) {
      setState(() {
        _isDesignerLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getdesignerlistsbybrandid(widget.brand.brandid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getdesigners code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _designers.addAll((data["data"] as List)
                .map((e) => Designer.fromMap(e))
                .toList());

            _isDesignerLoading = false;

            log('getdesigners isloading: $_isDesignerLoading');
          });
        } else {
          setState(() {
            _isDesignerLoading = false;

            log('getdesigners isloading');
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
          .getcollectionlistsbybrandid(widget.brand.brandid, 0, 10, null)
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

  Future<void> getProducts() async {
    if (!_isProductLoading && mounted) {
      setState(() {
        _isProductLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getnewproductlistsbybrandid(widget.brand.brandid, 6, null)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _products.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _isProductLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _isProductLoading = false;
          });
        }
      });
    }
  }

  Future<void> getCategorys() async {
    if (!_isCategoryLoading && mounted) {
      setState(() {
        _isCategoryLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcategorylists(widget.brand.brandid, null)
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _categorys.addAll((data["data"] as List)
                .map((e) => Category.fromMap(e))
                .toList());
            _isCategoryLoading = false;
          });
        } else if (mounted) {
          setState(() {
            _isCategoryLoading = false;
          });
        }
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
        toolbarHeight: 44,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        centerTitle: true,
        title: Text(
          widget.brand.title,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: [
          BrandFavoriteIcon(
            brandid: widget.brand.brandid,
          ),
          const CartIcon(),
        ],
      ),
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ),
            child: BrandMenu(
              brand: widget.brand,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isBrandPhotoLoading
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: shimmerbaseColor,
                      highlightColor: shimmerhilightColor,
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  )
                : _brandphotos.where((e) => e.scaletype == 4).isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 3 / 4,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                          ),
                          itemCount: _brandphotos
                              .where((e) => e.scaletype == 4)
                              .length,
                          itemBuilder: (BuildContext context, int index,
                                  int realIndex) =>
                              Padding(
                            padding: const EdgeInsets.only(
                              right: 0.0,
                              left: 0.0,
                            ),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                _brandphotos
                                    .where((e) => e.scaletype == 4)
                                    .elementAt(index)
                                    .url,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(),
            if (widget.brand.videourl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: VideoPlay(
                  pathh: widget.brand.videourl!,
                  isautoplay: true,
                  control: true,
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
                  widget.brand.title,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            if (widget.brand.summary != null && widget.brand.summary != '')
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  widget.brand.summary ?? '',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
              ),
            if (!_isCollectionLoading && _collections.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: verticalSpace,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    aspectRatio: 3 / 4,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                  ),
                  itemCount: _collections.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) =>
                          Padding(
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
                        title: _collections[index].subtitle,
                        subtitle: _collections[index].title,
                        flagurl: _collections[index].flagurl!,
                      ),
                    ),
                  ),
                ),
              ),
            _isProductLoading
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: horizonSpace,
                    ),
                    child: Center(
                      child: Shimmer.fromColors(
                        baseColor: shimmerbaseColor,
                        highlightColor: shimmerhilightColor,
                        child: Container(
                          height: 395,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  )
                : _products.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: ProductsHorizonSlideList(
                          products: _products,
                        ),
                      )
                    : Container(),
            Padding(
              padding: const EdgeInsets.only(
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).homebrandJustForYou,
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
                lang.S.of(context).homebrandJustForYouCaption,
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            if (!_isBrandPhotoLoading &&
                _brandphotos.where((e) => e.scaletype == 3).isNotEmpty)
              SizedBox(
                height: 420,
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  padding: const EdgeInsets.only(
                    left: 13,
                    right: 13,
                  ),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemExtent: 220,
                  itemCount: _brandphotos.where((e) => e.scaletype == 3).length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(
                      left: 2,
                      right: 2,
                    ),
                    child: ImageStackCard(
                        url: _brandphotos
                            .where((e) => e.scaletype == 3)
                            .elementAt(index)
                            .url),
                  ),
                ),
              ),
            //__________________________________________________________collection video
            if (!_isCollectionLoading &&
                _collections.any((e) => e.videourl != null && e.videourl != ''))
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: CollectionvideoCarousel(
                  collections: _collections
                      .where((e) => e.videourl != null && e.videourl != '')
                      .toList(),
                ),
              ),
            _isBrandPhotoLoading
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
                : _brandphotos.where((e) => e.scaletype == 2).isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: verticalSpace,
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 4 / 3,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                          ),
                          itemCount: _brandphotos
                              .where((e) => e.scaletype == 2)
                              .length,
                          itemBuilder: (BuildContext context, int index,
                                  int realIndex) =>
                              Padding(
                            padding: const EdgeInsets.only(
                              right: 0.0,
                              left: 0.0,
                            ),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                _brandphotos
                                    .where((e) => e.scaletype == 2)
                                    .elementAt(index)
                                    .url,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
            if (!_isDesignerLoading)
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _designers[0].title,
                          style: textTheme.titleLarge,
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image(
                        image: NetworkImage(_designers[0].flagurl),
                      ),
                    ],
                  ),
                ),
              ),
            if (!_isDesignerLoading && _designers[0].summary != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  _designers[0].summary!,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            if (!_isDesignerLoading)
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Designers(
                            brand: widget.brand,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      lang.S.of(context).commonMore,
                      style: textTheme.titleSmall?.copyWith(
                        color: darkColor,
                      ),
                    ),
                  ),
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
                  lang.S.of(context).homebrandShopByCategory,
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
              child: _isCategoryLoading
                  ? Center(
                      child: Shimmer.fromColors(
                        baseColor: shimmerbaseColor,
                        highlightColor: shimmerhilightColor,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    )
                  : CategorysList(
                      categorys: _categorys,
                    ),
            ),
            const SizedBox(height: verticalSpace),
          ],
        ),
      ),
      floatingActionButton: MemberPlanIcon(
        brand: widget.brand,
      ),
    );
  }
}
