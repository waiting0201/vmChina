import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;

  _AZItem({
    required this.title,
    required this.tag,
  });

  @override
  String getSuspensionTag() => tag;
}

class Brandsubalphabets extends StatefulWidget {
  final String subcategoryid;
  final String categorytitle;
  const Brandsubalphabets({
    super.key,
    required this.subcategoryid,
    required this.categorytitle,
  });

  @override
  State<Brandsubalphabets> createState() => _BrandsubalphabetsState();
}

class _BrandsubalphabetsState extends State<Brandsubalphabets> {
  final List<Brand> _brands = [];

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getBrands();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getBrands() async {
    if (!_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getsubcategoryallbrandlists(widget.subcategoryid)
          .then((value) {
        var data = json.decode(value.toString());

        log('getbrands code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _brands.addAll(
                (data["data"] as List).map((e) => Brand.fromMap(e)).toList());

            _isLoading = false;

            log('getbrands isloading: $_isLoading');
          });
        } else if (mounted) {
          setState(() {
            _isLoading = false;

            log('getbrands isloading: $_isLoading');
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
        centerTitle: false,
        title: Row(
          children: [
            Text(
              lang.S.of(context).brandsTitle,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.categorytitle,
              style: textTheme.titleSmall,
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: const [
          CartIcon(),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: LoadingCircle(),
            )
          : AzListView(
              data: _brands
                  .map((e) =>
                      _AZItem(title: e.title, tag: e.title[0].toUpperCase()))
                  .toList(),
              itemCount: _brands.length,
              itemBuilder: (context, k) {
                return ExpansionTile(
                  dense: false,
                  backgroundColor: bggray100,
                  leading: BrandFavoriteIcon(brandid: _brands[k].brandid),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          _brands[k].title,
                          maxLines: 2,
                          softWrap: true,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image(
                        image: NetworkImage(_brands[k].flagurl!),
                      ),
                    ],
                  ),
                  trailing: const SizedBox(),
                  childrenPadding: const EdgeInsets.only(
                    left: horizonSpace,
                    right: horizonSpace,
                    bottom: horizonSpace,
                  ),
                  children: [
                    BrandExpendCard(
                      brand: _brands[k],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
