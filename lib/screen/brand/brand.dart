import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import '../widgets/common.dart';
import 'brandalphabet.dart';
import 'brandsubalphabet.dart';

class Brands extends StatefulWidget {
  const Brands({
    super.key,
  });

  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> with SingleTickerProviderStateMixin {
  final List<Category> _categorys = [];

  late TabController _tabcontroller;
  late bool _isCategoryLoading = false;
  late String _selected;

  @override
  void initState() {
    super.initState();
    getCategorys();
  }

  Future<void> getCategorys() async {
    if (!_isCategoryLoading && mounted) {
      setState(() {
        _isCategoryLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getcategorybrandlists(null).then((value) {
        var data = json.decode(value.toString());

        log('getcategorys code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _categorys.addAll((data["data"] as List)
                .map((e) => Category.fromMap(e))
                .toList());
            _tabcontroller =
                TabController(length: _categorys.length, vsync: this);
            _isCategoryLoading = false;
            _selected = _categorys[0].title;
          });
        } else if (mounted) {
          setState(() {
            log('getcategorys failed');
            _isCategoryLoading = false;
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
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          lang.S.of(context).brandsTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: const [
          CartIcon(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: _isCategoryLoading
              ? const SizedBox()
              : Column(
                  children: [
                    Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizonSpace,
                      ),
                      child: TabBar(
                        controller: _tabcontroller,
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        tabAlignment: TabAlignment.start,
                        indicatorSize: TabBarIndicatorSize.tab,
                        isScrollable: true,
                        tabs: _categorys
                            .map((e) => Tab(
                                  text: e.title,
                                ))
                            .toList(),
                        labelPadding: const EdgeInsets.only(
                          right: horizonSpace,
                        ),
                        indicatorPadding: const EdgeInsets.only(
                          right: horizonSpace,
                        ),
                        onTap: (value) {
                          setState(() {
                            _selected = _categorys[value].title;
                          });
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
      body: _isCategoryLoading
          ? const Center(
              child: LoadingCircle(),
            )
          : TabBarView(
              controller: _tabcontroller,
              physics: const NeverScrollableScrollPhysics(),
              children: _categorys.map((e) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Brandalphabets(
                                categoryid: e.categoryid,
                                categorytitle: e.title,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          '$_selected ${lang.S.of(context).brandsAZ}',
                          style: textTheme.bodyMedium,
                        ),
                        trailing: const Icon(
                          FeatherIcons.chevronRight,
                          color: lightGreyTextColor,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: horizonSpace,
                          right: horizonSpace,
                          bottom: 10,
                        ),
                        child: Divider(
                          color: lightbackgroundColor,
                        ),
                      ),
                      SizedBox(
                        height: 260,
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
                          itemExtent: 180,
                          itemCount: e.subcategorys!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Brandsubalphabets(
                                    subcategoryid:
                                        e.subcategorys![index].subcategoryid,
                                    categorytitle:
                                        '${e.title} ${e.subcategorys![index].title}',
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                                right: 2,
                              ),
                              child: SubCategoryCard(
                                  subcategory: e.subcategorys![index]),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            lang.S.of(context).brandsPopular,
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ),
                      PopularBrandsList(categoryid: e.categoryid),
                      const SizedBox(height: 50),
                    ],
                  ),
                );
              }).toList()),
    );
  }
}
