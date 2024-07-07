import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../language/language_provider.dart';
import '../authentication/auth_provider.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/carousel.dart';
import '../widgets/partial.dart';
import 'whatsnew.dart';
import 'home.dart';

import '../cart/payment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Homebanner> _homebanners = [];
  final List<DesignerVideo> _designervideos = [];
  final List<Collection> _collections = [];
  final List<Product> _products = [];
  final List<Category> _categorys = [];

  late bool status = false;
  late bool _isHomebannerLoading = false;
  late bool _isDesignervideoLoading = false;
  late bool _isCollectionLoading = false;
  late bool _isProductLoading = false;
  late bool _isCategoryLoading = false;

  @override
  void initState() {
    super.initState();
    getHomebanners();
    getDesignervideos();
    getCollections();
    getProducts();
    getCategorys();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getHomebanners() async {
    if (!_isHomebannerLoading && mounted) {
      setState(() {
        _isHomebannerLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.gethomebannerlists(0, 10, null).then((value) {
        var data = json.decode(value.toString());

        //log('gethomebanners code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _homebanners.addAll((data["data"] as List)
                .map((e) => Homebanner.fromMap(e))
                .toList());
            _isHomebannerLoading = false;
          });
        } else if (mounted) {
          setState(() {
            //log('gethomebanners isloading');
            _isHomebannerLoading = false;
          });
        }
      });
    }
  }

  Future<void> getDesignervideos() async {
    if (!_isDesignervideoLoading && mounted) {
      setState(() {
        _isDesignervideoLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getdesignervideolists(0, 5, null).then((value) {
        var data = json.decode(value.toString());

        //log('getdesignervideos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _designervideos.addAll((data["data"] as List)
                .map((e) => DesignerVideo.fromMap(e))
                .toList());
            _isDesignervideoLoading = false;
          });
        } else if (mounted) {
          setState(() {
            //log('getdesignervideos isloading');
            _isDesignervideoLoading = false;
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
      await httpService.getpublishstatuscollectionlists(1, null).then((value) {
        var data = json.decode(value.toString());

        //log('getcollections code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _collections.addAll((data["data"] as List)
                .map((e) => Collection.fromMap(e))
                .toList());
            _isCollectionLoading = false;
          });
        } else if (mounted) {
          setState(() {
            //log('getcollections isloading');
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
      await httpService.getnewproductlists(0, 6, null).then((value) {
        var data = json.decode(value.toString());

        //log('getproducts code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _products.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _isProductLoading = false;
          });
        } else if (mounted) {
          setState(() {
            //log('getproducts isloading');
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
      await httpService.getcategorylists(null, null).then((value) {
        var data = json.decode(value.toString());

        //log('getcategorys code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _categorys.addAll((data["data"] as List)
                .map((e) => Category.fromMap(e))
                .toList());
            _isCategoryLoading = false;
          });
        } else {
          if (mounted) {
            setState(() {
              //log('getcategorys failed');
              _isCategoryLoading = false;
            });
          }
        }
      });
    }
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: true);

    return Consumer<LanguageChangeProvider>(
      builder: (context, language, child) {
        return !language.status
            ? Container()
            : Scaffold(
                backgroundColor: whiteColor,
                body: Builder(
                  //builer產生自己的newContext，屬於上層Scaffold
                  builder: (BuildContext newContext) => NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder:
                        (BuildContext context, bool isScrolled) {
                      return [
                        SliverAppBar(
                          toolbarHeight: 44,
                          elevation: 0.0,
                          backgroundColor: whiteColor,
                          surfaceTintColor: whiteColor,
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: Text(
                            'WELCOME',
                            style: textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          iconTheme: const IconThemeData(
                            color: lightIconColor,
                          ),
                          actions: const [
                            ScanIcon(),
                            CartIcon(),
                          ],
                          floating: false,
                          snap: false,
                          pinned: true,
                        )
                      ];
                    },
                    physics: const BouncingScrollPhysics(),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //________________________________________________________homebanner
                          _isHomebannerLoading
                              ? Center(
                                  child: Shimmer.fromColors(
                                    baseColor: shimmerbaseColor,
                                    highlightColor: shimmerhilightColor,
                                    child: AspectRatio(
                                      aspectRatio: 3 / 4, // 16:9 aspect ratio
                                      child: Container(
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                )
                              : HomebannerCarousel(
                                  homebanners: _homebanners,
                                ),
                          //________________________________________________________mission
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: 50,
                              right: 50,
                            ),
                            child: Text(
                              lang.S.of(context).homeMainCaption,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          //________________________________________________________new arrival
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeNewArrival,
                              style: textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeShopLatestTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeShopLatestCaption,
                              style: textTheme.bodySmall,
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
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: ProductsHorizonSlideList(
                                    products: _products,
                                  ),
                                ),
                          //________________________________________________________more button
                          Padding(
                            padding: const EdgeInsets.only(
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Home(
                                        bottomNavIndex: 2,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  lang.S.of(context).commonShopNow,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: darkColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //________________________________________________________Shop the latest Brands
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: 25,
                            ),
                            child: Text(
                              lang.S.of(context).homeShopTheBrand,
                              style: textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 25,
                            ),
                            child: Text(
                              lang.S.of(context).homeShopTheBrandTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 25,
                              right: 25,
                            ),
                            child: Text(
                              lang.S.of(context).homeShopTheBrandCaption,
                              style: textTheme.bodySmall,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 25,
                              right: 25,
                            ),
                            child: CurrentBrandsCarousel(),
                          ),
                          //________________________________________________________Brands Coming Soon
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: 25,
                            ),
                            child: Text(
                              lang.S.of(context).homePreviewComingSoon,
                              style: textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 25,
                            ),
                            child: Text(
                              lang.S.of(context).homeBrandComingSoonTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 25,
                              right: 25,
                            ),
                            child: Text(
                              lang.S.of(context).homeBrandComingSoonCaption,
                              style: textTheme.bodySmall,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 25,
                              right: 25,
                            ),
                            child: ComingBrandsCarousel(),
                          ),
                          //________________________________________________________behind the scenes
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(50.0),
                              width: double.infinity,
                              color: bggray100,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: Text(
                                      lang.S.of(context).homeBehindTheScenes,
                                      style: textTheme.titleLarge,
                                    ),
                                  ),
                                  Text(
                                    lang.S
                                        .of(context)
                                        .homeBehindTheScenesCaption,
                                    style: textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                          //________________________________________________________designer video
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: horizonSpace,
                            ),
                            child: _isDesignervideoLoading
                                ? Center(
                                    child: Shimmer.fromColors(
                                      baseColor: shimmerbaseColor,
                                      highlightColor: shimmerhilightColor,
                                      child: AspectRatio(
                                        aspectRatio:
                                            16 / 9, // 16:9 aspect ratio
                                        child: Container(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : DesignervideoCarousel(
                                    designervideos: _designervideos),
                          ),
                          //________________________________________________________Explore the collections
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeLatestCollections,
                              style: textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeExploreCollectionTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeExploreCollectionCaption,
                              style: textTheme.bodySmall,
                            ),
                          ),
                          _isCollectionLoading
                              ? Center(
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
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: CollectionsList(
                                    collections: _collections,
                                  ),
                                ),
                          //________________________________________________________whats new
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeWhatsNew,
                              style: textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeSeasonalArrivalTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                              right: horizonSpace,
                              bottom: 10,
                            ),
                            child: Text(
                              lang.S.of(context).homeSeasonalArrivalCaption,
                              style: textTheme.bodySmall,
                            ),
                          ),
                          const WhatsNewHorizonSlideList(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Whatsnews(),
                                    ),
                                  );
                                },
                                child: Text(
                                  lang.S.of(context).commonSeeAll,
                                  style: textTheme.titleSmall?.copyWith(
                                    color: darkColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //________________________________________________________Fashion shows
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
                              left: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeTuneIn,
                              style: textTheme.titleSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Text(
                              lang.S.of(context).homeFashionShowTitle,
                              style: textTheme.titleLarge,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: horizonSpace,
                              right: horizonSpace,
                              bottom: 10,
                            ),
                            child: Text(
                              lang.S.of(context).homeFashionShowCaption,
                              style: textTheme.bodySmall,
                            ),
                          ),
                          const EventHorizonSlideList(),
                          //________________________________________________________Sign or register
                          authchangeprovider.status
                              ? Container()
                              : const Padding(
                                  padding: EdgeInsets.only(
                                    top: verticalSpace,
                                  ),
                                  child: AccountSection(),
                                ),
                          //________________________________________________________Category
                          Padding(
                            padding: const EdgeInsets.only(
                              top: verticalSpace,
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
                          //________________________________________________________Search Bar
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: bggray100,
                                  side: const BorderSide(color: bggray100),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Home(bottomNavIndex: 2),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: darkColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      lang.S.of(context).homeSearch,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: darkColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Payment(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Pay',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: darkColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
