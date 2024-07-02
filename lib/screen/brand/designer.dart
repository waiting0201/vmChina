import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../authentication/auth_provider.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'designerdetail.dart';

class Designers extends StatefulWidget {
  final Brand brand;
  const Designers({
    super.key,
    required this.brand,
  });

  @override
  State<Designers> createState() => _DesignersState();
}

class _DesignersState extends State<Designers> {
  final List<Designer> _designers = [];

  late bool status = false;
  late bool _isDesignerLoading = false;

  @override
  void initState() {
    super.initState();
    getDesigners();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    final authchangeprovider =
        Provider.of<AuthChangeProvider>(context, listen: false);
    TextTheme textTheme = Theme.of(context).textTheme;

    setState(() {
      status = authchangeprovider.status;
    });

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
          lang.S.of(context).shareamomentTitle,
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
                top: 15,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: 640,
                  aspectRatio: 3 / 4,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: null,
                ),
                itemCount: _designers.length,
                itemBuilder: (BuildContext context, int index, int realIndex) =>
                    Card(
                  elevation: 1.0,
                  color: whiteColor,
                  surfaceTintColor: whiteColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Designerdetail(
                            image: Image(
                              image: CachedNetworkImageProvider(
                                  _designers[index].portraiturl!),
                              fit: BoxFit.cover,
                            ),
                            tag: _designers[index].designerid,
                            designer: _designers[index],
                            brandid: widget.brand.brandid,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                _designers[index].squareurl!),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _designers[index].title,
                                  style: textTheme.displayMedium,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Image(
                                image: NetworkImage(_designers[index].flagurl),
                                width: 15,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.location_on, size: 15),
                              const SizedBox(width: 2),
                              Text(
                                '${_designers[index].subtitle}, ${_designers[index].country}',
                              ),
                            ],
                          ),
                        ),
                        Hero(
                          tag: _designers[index].designerid,
                          child: Material(
                            color: whiteColor,
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  _designers[index].portraiturl!),
                              height: 475,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        if (_designers[index].summary != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10),
                            child: Text(
                              _designers[index].summary!.trim(),
                              style: textTheme.bodySmall,
                              softWrap: true,
                              maxLines: 3,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MemberPlanIcon(
        brand: widget.brand,
      ),
    );
  }
}
