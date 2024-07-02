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

class Justforyoudetail extends StatefulWidget {
  final Justforyou justforyou;
  const Justforyoudetail({
    super.key,
    required this.justforyou,
  });

  @override
  State<Justforyoudetail> createState() => _JustforyoudetailState();
}

class _JustforyoudetailState extends State<Justforyoudetail> {
  final List<JustforyouMedia> _photos = [];
  final ScrollController _scrollController = ScrollController();

  late bool _isPhotoLoading = false;

  @override
  void initState() {
    super.initState();
    getPhotos();
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
          .getjustforyoumediasbyid(widget.justforyou.justforyouid)
          .then((value) {
        var data = json.decode(value.toString());

        log('getphotos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _photos.addAll((data["data"] as List)
                .map((e) => JustforyouMedia.fromMap(e))
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
                .getbrandbyid(widget.justforyou.brandid, null)
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
            widget.justforyou.subtitle!,
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
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isPhotoLoading
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
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
                : _photos.where((e) => e.scaletype == 1).isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                          ),
                          itemCount:
                              _photos.where((e) => e.scaletype == 1).length,
                          itemBuilder: (BuildContext context, int index,
                                  int realIndex) =>
                              Padding(
                            padding: const EdgeInsets.only(
                              right: 0.0,
                              left: 0.0,
                            ),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                _photos
                                    .where((e) => e.scaletype == 1)
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
                  widget.justforyou.title,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            widget.justforyou.summary != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 50,
                      right: 50,
                    ),
                    child: Text(
                      widget.justforyou.summary!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall,
                    ),
                  )
                : Container(),
            _photos.where((e) => e.scaletype == 4).isNotEmpty
                ? Padding(
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
            _photos.where((e) => e.scaletype == 2).isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: verticalSpace,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
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
                widget.justforyou.content!,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ),
            widget.justforyou.videourl!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: VideoPlay(
                      pathh: widget.justforyou.videourl!,
                      isautoplay: true,
                      control: true,
                    ),
                  )
                : Container(),
            //________________________________________________________featured products
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).justforyouProducts,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: ProductVerticalLists(
                justforyouid: widget.justforyou.justforyouid,
                controller: _scrollController,
              ),
            ),
            if (!_isPhotoLoading &&
                _photos.where((e) => e.scaletype == 3).isNotEmpty)
              SizedBox(
                height: 420,
                child: ListView.builder(
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
