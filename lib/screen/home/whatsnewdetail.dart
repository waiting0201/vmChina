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
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Whatsnewdetail extends StatefulWidget {
  final WhatsNew whatsnew;
  const Whatsnewdetail({
    super.key,
    required this.whatsnew,
  });

  @override
  State<Whatsnewdetail> createState() => _WhatsnewdetailState();
}

class _WhatsnewdetailState extends State<Whatsnewdetail> {
  bool _isPhotoLoading = false;
  final List<WhatsNewMedia> _photos = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPhotos();
    log("${widget.whatsnew.videourl}");
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
          .getwhatsnewmediasbyid(widget.whatsnew.whatsnewid)
          .then((value) {
        var data = json.decode(value.toString());

        log('getphotos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _photos.addAll((data["data"] as List)
                .map((e) => WhatsNewMedia.fromMap(e))
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
        title: Text(
          widget.whatsnew.title,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
                        aspectRatio: 3 / 4,
                        child: Container(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  )
                : _photos.where((e) => e.scaletype == 4).isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
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
                          itemCount:
                              _photos.where((e) => e.scaletype == 4).length,
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
                  widget.whatsnew.title,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            if (widget.whatsnew.summary != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 50,
                  right: 50,
                ),
                child: Text(
                  widget.whatsnew.summary!,
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
            if (widget.whatsnew.content != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Text(
                  widget.whatsnew.content!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
              ),
            widget.whatsnew.videourl!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: VideoPlay(
                      pathh: widget.whatsnew.videourl!,
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
                  lang.S.of(context).whatsnewProducts,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: ProductVerticalLists(
                whatsnewid: widget.whatsnew.whatsnewid,
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
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
