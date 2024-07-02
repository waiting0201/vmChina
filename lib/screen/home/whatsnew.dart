import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'whatsnewdetail.dart';

class Whatsnews extends StatefulWidget {
  const Whatsnews({
    super.key,
  });

  @override
  State<Whatsnews> createState() => _WhatsnewsState();
}

class _WhatsnewsState extends State<Whatsnews> {
  final List<WhatsNew> _whatsnews = [];
  final int _take = 10;

  late bool _isWhatsnewLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();
    getWhatsnews();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getWhatsnews() async {
    if (_hasMore && !_isWhatsnewLoading) {
      setState(() {
        _isWhatsnewLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getwhatsnewlists(_skip, _take, null).then((value) {
        var data = json.decode(value.toString());

        log('getwhatsnews code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _whatsnews.addAll((data["data"] as List)
                .map((e) => WhatsNew.fromMap(e))
                .toList());
            _skip = _skip + _take;
            _isWhatsnewLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            log('getwhatsnews isloading: $_isWhatsnewLoading');
            log('getwhatsnews skip: $_skip');
          });
        } else {
          setState(() {
            _isWhatsnewLoading = false;
            _hasMore = false;

            log('getwhatsnews isloading');
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
          lang.S.of(context).whatsnewTitle,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).whatsnewTitle,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 50,
                right: 50,
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).whatsnewCaption,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  //load more here
                  getWhatsnews();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: verticalSpace,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _hasMore ? _whatsnews.length + 1 : _whatsnews.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= _whatsnews.length) {
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
                            builder: (context) => Whatsnewdetail(
                              whatsnew: _whatsnews[index],
                            ),
                          ),
                        );
                      },
                      child: ImageStackCard(
                        url: _whatsnews[index].portraiturl!,
                        title: _whatsnews[index].title,
                        subtitle: _whatsnews[index].summary,
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
    );
  }
}
