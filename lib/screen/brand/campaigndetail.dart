import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import 'homebrand.dart';

class Campaigndetail extends StatefulWidget {
  final Campaign campaign;
  const Campaigndetail({
    super.key,
    required this.campaign,
  });

  @override
  State<Campaigndetail> createState() => _CampaigndetailState();
}

class _CampaigndetailState extends State<Campaigndetail> {
  final List<Campaign> _campaigns = [];
  final List<CampaignMedia> _photos = [];
  final List<Product> _products = [];
  final int _take = 10;

  late bool _isPhotoLoading = false;
  late bool _isCampaignLoading = false;
  late bool _isProductLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();
    getPhotos();
    getCampaigns();
    getProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getPhotos() async {
    if (!_isPhotoLoading) {
      setState(() {
        _isPhotoLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcampaignmediasbyid(widget.campaign.campaignid)
          .then((value) {
        var data = json.decode(value.toString());

        log('getphotos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _photos.addAll((data["data"] as List)
                .map((e) => CampaignMedia.fromMap(e))
                .toList());
            _isPhotoLoading = false;
          });
        } else {
          setState(() {
            log('getphotos isloading');
            _isPhotoLoading = false;
          });
        }
      });
    }
  }

  Future<void> getCampaigns() async {
    if (_hasMore && !_isCampaignLoading) {
      setState(() {
        _isCampaignLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcampaignlistswithoutselfbybrandid(widget.campaign.brandid,
              widget.campaign.campaignid, _skip, _take, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getcampaigns code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _campaigns.addAll((data["data"] as List)
                .map((e) => Campaign.fromMap(e))
                .toList());

            _skip = _skip + _take;
            _isCampaignLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            log('getcampaigns isloading: $_isCampaignLoading');
            log('getcampaigns skip: $_skip');
          });
        } else {
          setState(() {
            _isCampaignLoading = false;
            _hasMore = false;

            log('getcampaigns isloading');
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
          .getproductlistsbycampaignid(widget.campaign.campaignid, 0, 6, null)
          .then((value) {
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
        centerTitle: true,
        title: InkWell(
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
                .getbrandbyid(widget.campaign.brandid, null)
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
            widget.campaign.subtitle!,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: const [
          CartIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _photos.where((e) => e.scaletype == 4).isNotEmpty
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
                      itemCount: _photos.where((e) => e.scaletype == 4).length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) =>
                              Padding(
                        padding: const EdgeInsets.only(
                          right: 0.0,
                          left: 0.0,
                        ),
                        child: Image(
                          image: CachedNetworkImageProvider(
                            _photos
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
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Center(
                child: Text(
                  widget.campaign.title,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            if (widget.campaign.summary != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  widget.campaign.summary ?? '',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
              ),
            _photos.where((e) => e.scaletype == 2).isNotEmpty
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
                      itemCount: _photos.where((e) => e.scaletype == 2).length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: itemSpace,
                        ),
                        child: Image(
                          image: CachedNetworkImageProvider(
                            _photos
                                .where((e) => e.scaletype == 2)
                                .elementAt(index)
                                .url,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Text(
                widget.campaign.content ?? '',
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            if (!_isProductLoading && _products.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Center(
                  child: Text(
                    lang.S.of(context).campaignShop,
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
            if (!_isProductLoading && _products.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: ProductsHorizonSlideList(
                  products: _products,
                ),
              ),
            if (widget.campaign.videourl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: VideoPlay(
                  pathh: widget.campaign.videourl!,
                  isautoplay: true,
                  control: true,
                ),
              ),
            if (!_isPhotoLoading &&
                _photos.where((e) => e.scaletype == 3).isNotEmpty)
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
                  itemCount: _photos.where((e) => e.scaletype == 3).length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(
                      left: 2,
                      right: 2,
                    ),
                    child: ImageStackCard(
                        url: _photos
                            .where((e) => e.scaletype == 3)
                            .elementAt(index)
                            .url),
                  ),
                ),
              ),
            if (!_isCampaignLoading && _campaigns.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Center(
                  child: Text(
                    lang.S.of(context).commonDiscoverMore,
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
            if (!_isCampaignLoading && _campaigns.isNotEmpty)
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    //load more here
                    getCampaigns();
                  }
                  return false;
                },
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                      _hasMore ? _campaigns.length + 1 : _campaigns.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= _campaigns.length) {
                      return Center(
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
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: itemSpace,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Campaigndetail(
                                campaign: _campaigns[index],
                              ),
                            ),
                          );
                        },
                        child: ImageStackCard(
                          url: _campaigns[index].portraiturl!,
                          title: _campaigns[index].title,
                          subtitle: _campaigns[index].subtitle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
