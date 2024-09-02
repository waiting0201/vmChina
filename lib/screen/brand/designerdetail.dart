import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../widgets/common.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import 'designermessage.dart';

class Designerdetail extends StatefulWidget {
  final Widget image;
  final String tag;
  final Designer designer;
  final String brandid;
  const Designerdetail({
    super.key,
    required this.image,
    required this.tag,
    required this.designer,
    required this.brandid,
  });

  @override
  State<Designerdetail> createState() => _DesignerdetailState();
}

class _DesignerdetailState extends State<Designerdetail> {
  final List<DesignerMedia> _photos = [];
  final List<Collection> _collections = [];
  final List<Category> _categorys = [];
  final int _take = 10;

  late bool _isCollectionLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;
  late bool _isPhotoLoading = false;
  late bool _isCategoryLoading = false;

  @override
  void initState() {
    super.initState();
    getPhotos();
    getCollections();
    getCategorys();
  }

  Future<void> getPhotos() async {
    if (!_isPhotoLoading && mounted) {
      setState(() {
        _isPhotoLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getdesignermediasbyid(widget.designer.designerid)
          .then((value) {
        var data = json.decode(value.toString());

        debugPrint('getphotos code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _photos.addAll((data["data"] as List)
                .map((e) => DesignerMedia.fromMap(e))
                .toList());
            _isPhotoLoading = false;
          });
        } else if (mounted) {
          setState(() {
            debugPrint('getphotos isloading');
            _isPhotoLoading = false;
          });
        }
      });
    }
  }

  Future<void> getCollections() async {
    if (_hasMore && !_isCollectionLoading) {
      setState(() {
        _isCollectionLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcollectionlistsbybrandid(widget.brandid, _skip, _take, null)
          .then((value) {
        var data = json.decode(value.toString());

        debugPrint('getcollections code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _collections.addAll((data["data"] as List)
                .map((e) => Collection.fromMap(e))
                .toList());
            _skip = _skip + _take;
            _isCollectionLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            debugPrint('getcollections isloading: $_isCollectionLoading');
            debugPrint('getcollections skip: $_skip');
          });
        } else if (mounted) {
          setState(() {
            _isCollectionLoading = false;
            _hasMore = false;

            debugPrint('getcollections isloading');
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
          .getbrandcategorylists(widget.brandid, null)
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
  void dispose() {
    super.dispose();
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
          lang.S.of(context).shareamomentTitle,
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
      body: Consumer<AuthChangeProvider>(
        builder: (context, auth, child) => SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: widget.tag,
                child: Material(
                  child: widget.image,
                ),
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.designer.squareurl!),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.designer.title,
                          style: textTheme.displayMedium,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image(
                        image: NetworkImage(widget.designer.flagurl),
                        width: 15,
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.location_on, size: 15),
                      const SizedBox(width: 2),
                      Text(
                        '${widget.designer.subtitle}, ${widget.designer.country}',
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      if (auth.status) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DesignerMessage(
                              designer: widget.designer,
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
                    icon: const Icon(
                      Icons.message,
                      color: primaryColor,
                      size: 24,
                    ),
                  )),
              if (widget.designer.content!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    widget.designer.content ?? '',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (widget.designer.videourl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: VideoPlay(
                    pathh: widget.designer.videourl!,
                    isautoplay: true,
                    control: true,
                  ),
                ),
              if (!_isPhotoLoading)
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Center(
                  child: Text(
                    lang.S.of(context).shareamomentHometown,
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                child: Text(
                  widget.designer.hometown ?? '',
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              if (!_isPhotoLoading &&
                  _photos.where((e) => e.scaletype == 1).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _photos.where((e) => e.scaletype == 1).length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: itemSpace,
                      ),
                      child: Image(
                        image: CachedNetworkImageProvider(
                          _photos
                              .where((e) => e.scaletype == 1)
                              .elementAt(index)
                              .url,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!_isCollectionLoading && _collections.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Center(
                    child: Text(
                      lang.S.of(context).shareamomentDiscover,
                      style: textTheme.titleLarge,
                    ),
                  ),
                ),
              if (!_isCollectionLoading && _collections.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: CollectionsList(
                    collections: _collections,
                  ),
                ),
              if (!_isCategoryLoading && _categorys.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Center(
                    child: Text(
                      lang.S.of(context).shareamomentShop,
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
              ],
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
