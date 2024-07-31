import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import '../widgets/library.dart';
import '../home/whatsnewdetail.dart';
import 'productlist.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  final TextEditingController _textcontroller = TextEditingController();
  final List<Category> _categorys = [];
  final List<Product> _products = [];
  final List<WhatsNew> _whatsnews = [];
  final FocusNode _searchFocusNode = FocusNode();

  late TabController _tabcontroller;
  late String _searchHint;
  late bool _isCategoryLoading = false;
  //late bool _isLoading = false;
  late bool _isSearchKeyword = false;
  late bool _isWhatsnewLoading = false;

  @override
  void initState() {
    super.initState();
    getCategorys();
    getWhatsnews();
  }

  Future<void> getCategorys() async {
    if (!_isCategoryLoading && mounted) {
      setState(() {
        _isCategoryLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getcategorylists(null, null).then((value) {
        var data = json.decode(value.toString());

        log('getcategorys code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _categorys.addAll((data["data"] as List)
                .map((e) => Category.fromMap(e))
                .toList());
            _tabcontroller =
                TabController(length: _categorys.length, vsync: this);

            _searchHint = _categorys[0].title;
            _isCategoryLoading = false;
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

  Future<void> getWhatsnews() async {
    if (!_isWhatsnewLoading && mounted) {
      setState(() {
        _isWhatsnewLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getwhatsnewlists(0, 5, null).then((value) {
        var data = json.decode(value.toString());

        log('getwhatsnews code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _whatsnews.addAll((data["data"] as List)
                .map((e) => WhatsNew.fromMap(e))
                .toList());

            _isWhatsnewLoading = false;

            log('getwhatsnews isloading: $_isWhatsnewLoading');
          });
        } else if (mounted) {
          setState(() {
            _isWhatsnewLoading = false;

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor, //頁面scroll時的顏色
        //scrolledUnderElevation: 0, //頁面scroll時，顏色不變
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          lang.S.of(context).shopTitle,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _isCategoryLoading
              ? const SizedBox()
              : Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                          left: horizonSpace,
                          right: horizonSpace,
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 17,
                        ),
                        height: 34,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _textcontroller,
                                focusNode: _searchFocusNode,
                                style: textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                  prefixIconColor: lightGreyTextColor,
                                  hintText: _isCategoryLoading
                                      ? ''
                                      : '${lang.S.of(context).shopSearchFor} $_searchHint',
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: lightGreyTextColor,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isSearchKeyword = true;
                                    /*getProducts(
                                        _categorys[_tabcontroller.index]
                                            .categoryid,
                                        null);*/
                                  });
                                },
                                onChanged: (value) {
                                  //log(value.toString());
                                  /*_hasMore = true;
                                  if (value.isNotEmpty && value.length >= 3) {
                                    getProducts(
                                        _categorys[_tabcontroller.index]
                                            .categoryid,
                                        value);
                                  } else {
                                    setState(() {
                                      _hasMore = false;
                                      _products.clear();
                                    });
                                  }*/
                                },
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Productlist(
                                          categorytitle: value,
                                          categoryid:
                                              _categorys[_tabcontroller.index]
                                                  .categoryid,
                                          q: value,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            if (_isSearchKeyword)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _textcontroller.clear();
                                    _searchFocusNode.unfocus();
                                    _isSearchKeyword = false;
                                  });
                                },
                                child: Text(
                                  lang.S.of(context).shopCancel,
                                  style: textTheme.displayMedium,
                                ),
                              ),
                          ],
                        )),
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
                            _products.clear();
                            _searchHint = _categorys[value].title;
                          });
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
      body: _isCategoryLoading
          ? Container()
          : TabBarView(
              controller: _tabcontroller,
              physics: const NeverScrollableScrollPhysics(),
              children: _categorys
                  .map(
                    (e) => SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ImageStackCard(url: e.landscapeurl!),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: ExpansionTile(
                              dense: true,
                              initiallyExpanded: false,
                              tilePadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              childrenPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              title: Text(
                                lang.S.of(context).shopWhatsNew,
                                style: textTheme.bodyMedium,
                              ),
                              children: [
                                ListView.builder(
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _whatsnews.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Whatsnewdetail(
                                                whatsnew: _whatsnews[index],
                                              ),
                                            ),
                                          );
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          _whatsnews[index].title,
                                          style: textTheme.bodyMedium,
                                        ),
                                        trailing: const Icon(
                                          IconlyLight.arrowRight2,
                                          color: darkColor,
                                          size: 16,
                                        ),
                                      ),
                                      const Divider(
                                        color: lightbackgroundColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            shrinkWrap: true,
                            itemCount: e.subcategorys!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            itemBuilder: (_, j) => ExpansionTile(
                              dense: true,
                              initiallyExpanded: false,
                              tilePadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              childrenPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              title: Text(
                                e.subcategorys![j].title,
                                style: textTheme.bodyMedium,
                              ),
                              children: [
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '${lang.S.of(context).shopSeeAll} ${capitalizeFirstLetter(e.subcategorys![j].title)}',
                                    style: textTheme.bodyMedium,
                                  ),
                                  trailing: const Icon(
                                    IconlyLight.arrowRight2,
                                    color: darkColor,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Productlist(
                                          categorytitle:
                                              '${lang.S.of(context).shopSeeAll} ${capitalizeFirstLetter(e.subcategorys![j].title)}',
                                          categoryid:
                                              _categorys[_tabcontroller.index]
                                                  .categoryid,
                                          subcategoryid:
                                              e.subcategorys![j].subcategoryid,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Divider(
                                  color: lightbackgroundColor,
                                ),
                                ListView.builder(
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  shrinkWrap: true,
                                  itemCount:
                                      e.subcategorys![j].thirdcategorys.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (_, k) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          e.subcategorys![j].thirdcategorys[k]
                                              .title,
                                          style: textTheme.bodyMedium,
                                        ),
                                        trailing: const Icon(
                                          IconlyLight.arrowRight2,
                                          color: darkColor,
                                          size: 16,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Productlist(
                                                categorytitle: e
                                                    .subcategorys![j]
                                                    .thirdcategorys[k]
                                                    .title,
                                                categoryid: e.categoryid,
                                                thirdcategoryid: e
                                                    .subcategorys![j]
                                                    .thirdcategorys[k]
                                                    .thirdcategoryid,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const Divider(
                                        color: lightbackgroundColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
