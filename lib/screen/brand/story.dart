import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../brand/collectiondetail.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'designer.dart';

class Story extends StatefulWidget {
  final Brand brand;
  const Story({
    super.key,
    required this.brand,
  });

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final List<BrandMedia> _brandphotos = [];
  final List<StoryMedia> _storyphotos = [];
  final List<Designer> _designers = [];
  final List<Collection> _collections = [];

  late bool _isBrandPhotoLoading = false;
  late bool _isStoryPhotoLoading = false;
  late bool _isDesignerLoading = false;
  late bool _isCollectionLoading = false;

  @override
  void initState() {
    super.initState();
    getStoryPhotos();
    getBrandPhotos();
    getDesigners();
    getCollections();
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

  Future<void> getStoryPhotos() async {
    if (!_isStoryPhotoLoading) {
      setState(() {
        _isStoryPhotoLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getstorymediasbyid(widget.brand.brandid).then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200) {
          setState(() {
            _storyphotos.addAll((data["data"] as List)
                .map((e) => StoryMedia.fromMap(e))
                .toList());
            _isStoryPhotoLoading = false;
          });
        } else {
          setState(() {
            _isStoryPhotoLoading = false;
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
          lang.S.of(context).storyTitle,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            widget.brand.storyvideourl!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: verticalSpace,
                    ),
                    child: VideoPlay(
                      pathh: widget.brand.storyvideourl!,
                      isautoplay: true,
                      control: true,
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
                  lang.S.of(context).storyShareMoment,
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
                widget.brand.content!,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ),
            if (!_isDesignerLoading)
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: ImageStackCard(
                  url: _designers[0].landscapeurl!,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(_designers[0].flagurl),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _designers[0].title,
                        style: textTheme.titleLarge,
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
            if (!_isStoryPhotoLoading &&
                _storyphotos.where((e) => e.scaletype == 3).isNotEmpty)
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
                  itemCount: _storyphotos.where((e) => e.scaletype == 3).length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(
                      left: 2,
                      right: 2,
                    ),
                    child: ImageStackCard(
                        url: _storyphotos
                            .where((e) => e.scaletype == 3)
                            .elementAt(index)
                            .url),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).storyDiscover,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(
                top: 10,
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
