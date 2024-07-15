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
import 'campaigndetail.dart';

class Campaigns extends StatefulWidget {
  final Brand brand;
  const Campaigns({
    super.key,
    required this.brand,
  });

  @override
  State<Campaigns> createState() => _CampaignsState();
}

class _CampaignsState extends State<Campaigns> {
  final List<Campaign> _campaigns = [];
  final int _take = 10;

  late bool _isCampaignLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();
    getCampaigns();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCampaigns() async {
    if (_hasMore && !_isCampaignLoading) {
      setState(() {
        _isCampaignLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcampaignlistsbybrandid(widget.brand.brandid, _skip, _take, null)
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
          lang.S.of(context).campaignTitle,
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
                  lang.S.of(context).campaignFollow,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
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
                  top: verticalSpace,
                  left: horizonSpace,
                  right: horizonSpace,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _hasMore ? _campaigns.length + 1 : _campaigns.length,
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
