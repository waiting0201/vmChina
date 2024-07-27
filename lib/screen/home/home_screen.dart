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
import '../cart/selectpayment.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAlertDialog();
    });

    getHomebanners();
    getDesignervideos();
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
          Icons.info_outline,
          size: 30,
        ),
        iconColor: primaryColor,
        backgroundColor: whiteColor,
        content: const Text(
          '亲爱的访客，\n\n我们热忱欢迎您来到Vetrina Mia。\n\n探索来自意大利、法国、西班牙以及整个欧洲的200多个才华横溢的设计师品牌的精美系列。在Vetrina Mia，我们独家将这些独特而奢华的作品带到包括中国在内的亚太市场。\n\n我们的承诺：\n\n• 独家访问：享受由顶级意大利奢侈品制造商制作的系列，仅通过我们的平台提供。\n• 卓越品质：每个品牌创造的所有时尚产品都由经验丰富的意大利工匠精心制作，这些工匠多年来一直为世界顶级奢侈品牌制作高端产品，我们将提供来自欧盟的材料和产品认证。\n• 平价奢华：我们消除中间商、广告成本并减少利润，使价格更加实惠，同时仍与来自意大利和欧洲的奢侈材料供应商合作。我们的每个品牌都提供高端时尚产品。\n\n品牌互动：顾客还可以与他们喜爱的欧洲品牌造型师直接沟通。\n\n我们的使命：\n\n我们相信，享受时尚的权利应该属于每个人，无论财富或地位。在Vetrina Mia，我们相信时尚是一种美丽设计并精心制作的艺术创作，每个人都应该能够享受，这是人类创造力的见证。\n\n展示：\n\n• 地点：我们的首个展厅位于中国上海市长宁区凯旋路1398号长宁国际商场T6-105号店铺。\n\n当前状态：从7月15日起，我们将持续提供来自意大利和法国品牌的艺术作品供您在我们的展厅空间内探索。\n\n从8月1日起，您将能够注册并表示您感兴趣的产品，并且在没有任何预付款的情况下排队购买当产品可用时。\n\n从9月1日起，我们将开始在线零售销售，所有销售将通过我们的平台和移动应用进行。我们的产品将通过我们位于香港的配送中心配送到顾客的最终目的地，或者有时直接从意大利发货以便产品更快到达。\n\n由于工匠们的制作过程漫长，可能会有等待时间，因为生产数量并不总是很高。有时，可能会出现延迟情况，我们对此表示歉意并希望大家能够理解。如果您不想等待，可以随时取消订单，无需任何承诺。\n\n购买条件：\n\n• 仅限会员：购买仅限于会员。\n• 品牌会员资格：每个品牌都有自己的会员资格。\n• 免费试用：您在每个品牌首次购买后的前三个月内，会员资格是免费的。\n• 赞助费用：从首次购买后的三个月后起，您可以支付小额赞助费，每个品牌每月10元人民币，相当于一杯浓缩咖啡的价格。当然，您也可以支付更高金额以支持您喜爱的品牌。\n• 灵活的会员制度：会员费用每3个月收取一次，但可以随时不需理由取消，但我们保留拒绝再次加入的权利。\n\n我们非常感谢您在我们启动期间对我们的理解和耐心，这段时间我们可能会遇到一些服务差错或问题，我们将努力尽快解决任何问题，并希望为您带来多样和迷人的时尚体验，以及温暖周到的服务。\n\n每位客户永远是Vetrina Mia最尊贵的客人。',
          textAlign: TextAlign.left,
        ),
        scrollable: true,
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: darkColor,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              lang.S.of(context).commonExit,
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

    //debugInvertOversizedImages = true;

    return Consumer<LanguageChangeProvider>(
      builder: (context, language, child) {
        return !language.status
            ? const SizedBox()
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
                                      aspectRatio: 3 / 4,
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
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: horizonSpace,
                              right: horizonSpace,
                            ),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectPayment(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Payment",
                                  style: textTheme.titleSmall?.copyWith(
                                    color: darkColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
