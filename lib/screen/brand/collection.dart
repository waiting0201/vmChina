import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'collectiondetail.dart';

class Collections extends StatefulWidget {
  final Brand brand;
  const Collections({
    super.key,
    required this.brand,
  });

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  final List<Collection> _collections = [];
  final int _take = 10;

  late bool _isCollectionLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();
    getCollections();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCollections() async {
    if (_hasMore && !_isCollectionLoading) {
      setState(() {
        _isCollectionLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcollectionlistsbybrandid(widget.brand.brandid, _skip, _take, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getcollections code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _collections.addAll((data["data"] as List)
                .map((e) => Collection.fromMap(e))
                .toList());
            _skip = _skip + _take;
            _isCollectionLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            log('getcollections isloading: $_isCollectionLoading');
            log('getcollections skip: $_skip');
          });
        } else {
          setState(() {
            _isCollectionLoading = false;
            _hasMore = false;

            log('getcollections isloading');
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
          lang.S.of(context).collectionTitle,
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
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).collectionShop,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  //load more here
                  getCollections();
                }
                return false;
              },
              child: ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.only(
                  top: verticalSpace,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount:
                    _hasMore ? _collections.length + 1 : _collections.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= _collections.length) {
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
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
      floatingActionButton: MemberPlanIcon(
        brand: widget.brand,
      ),
    );
  }
}
