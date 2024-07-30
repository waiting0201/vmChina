import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'story.dart';

class Eventdetail extends StatefulWidget {
  final Event event;
  const Eventdetail({
    super.key,
    required this.event,
  });

  @override
  State<Eventdetail> createState() => _EventdetailState();
}

class _EventdetailState extends State<Eventdetail> {
  final List<EventMedia> _photos = [];
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
      await httpService.geteventmediasbyid(widget.event.eventid).then((value) {
        var data = json.decode(value.toString());

        log('getphotos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _photos.addAll((data["data"] as List)
                .map((e) => EventMedia.fromMap(e))
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
            httpService.getbrandbyid(widget.event.brandid, null).then((value) {
              var data = json.decode(value.toString());
              if (data["statusCode"] == 200) {
                overlayEntry.remove();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Story(
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
            widget.event.subtitle!,
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
            if (!_isPhotoLoading &&
                _photos.where((e) => e.scaletype == 4).isNotEmpty)
              Padding(
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
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Center(
                child: Text(
                  widget.event.title,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            widget.event.videourl!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: horizonSpace,
                      right: horizonSpace,
                    ),
                    child: VideoPlay(
                      pathh: widget.event.videourl!,
                      isautoplay: true,
                      control: true,
                    ),
                  )
                : Container(),
            if (widget.event.summary != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Text(
                  widget.event.summary!,
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
            if (widget.event.content!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Text(
                  widget.event.content!,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            //________________________________________________________featured products
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).collectionProducts,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: ProductVerticalLists(
                eventid: widget.event.eventid,
                controller: _scrollController,
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
