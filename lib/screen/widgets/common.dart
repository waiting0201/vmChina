import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../language/language_provider.dart';
import '../widgets/constant.dart';
import '../widgets/library.dart';
import '../brand/homebrand.dart';
import '../brand/story.dart';
import '../brand/collection.dart';
import '../brand/collectiondetail.dart';
import '../brand/campaign.dart';
import '../brand/justforyou.dart';
import '../brand/designer.dart';
import '../brand/eventdetail.dart';
import '../category/categorydetail.dart';
import '../category/productlist.dart';
import '../category/productdetail.dart';
import '../category/sizeguide.dart';
import '../home/home.dart';
import '../home/whatsnewdetail.dart';
import '../authentication/log_in.dart';
import '../authentication/sign_up.dart';
import 'partial.dart';

class AccountSection extends StatelessWidget {
  final String? refer;
  const AccountSection({
    this.refer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: horizonSpace,
            right: horizonSpace,
          ),
          child: Center(
            child: Text(
              lang.S.of(context).commonEnterYourAccount,
              style: textTheme.titleSmall,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: horizonSpace,
            right: horizonSpace,
          ),
          child: Center(
            child: Text(
              lang.S.of(context).commonSigninOrRegister,
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
          child: Text(
            lang.S.of(context).commonSigninCaption,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: horizonSpace,
            right: horizonSpace,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
                child: Text(
                  lang.S.of(context).commonRegister,
                  style: textTheme.titleSmall?.copyWith(
                    color: darkColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: darkColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogIn(
                        refer: refer,
                      ),
                    ),
                  );
                },
                child: Text(
                  lang.S.of(context).commonSignIn,
                  style: textTheme.titleSmall?.copyWith(
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColorFilter extends StatefulWidget {
  final Function(List<String>?) onChanged;
  final List<Product> products;
  const ColorFilter({
    super.key,
    required this.onChanged,
    required this.products,
  });

  @override
  State<ColorFilter> createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  final List<String> selectedColors = [];

  late List<VColor> _colors = [];

  @override
  void initState() {
    super.initState();
    for (Product product in widget.products) {
      for (ProductColor productcolor in product.productcolors!) {
        VColor vcolor = VColor(
          colorid: productcolor.colorid,
          title: productcolor.color,
          hexcode: productcolor.hexcode,
        );
        _colors.add(vcolor);
      }
    }
    final ids = _colors.map((e) => e.colorid).toSet();
    _colors.retainWhere((e) => ids.remove(e.colorid));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return GridView.count(
      padding: const EdgeInsets.only(top: 10),
      crossAxisCount: 5,
      childAspectRatio: 1,
      children: List.generate(
        _colors.length,
        (index) {
          return GridTile(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (selectedColors.contains(_colors[index].colorid)) {
                    selectedColors.remove(_colors[index].colorid);
                  } else {
                    selectedColors.add(_colors[index].colorid);
                  }

                  widget.onChanged(
                    selectedColors,
                  );
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: hexToColor(_colors[index].hexcode),
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: selectedColors.contains(_colors[index].colorid)
                            ? primaryColor
                            : lightGreyTextColor,
                        width: selectedColors.contains(_colors[index].colorid)
                            ? 3
                            : 1,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _colors[index].title,
                      style: textTheme.bodySmall?.copyWith(
                        color: selectedColors.contains(_colors[index].colorid)
                            ? primaryColor
                            : lightGreyTextColor,
                        fontWeight:
                            selectedColors.contains(_colors[index].colorid)
                                ? FontWeight.bold
                                : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SizeFilter extends StatefulWidget {
  final BuildContext context;
  final Function(List<String>?) onChanged;
  final List<Product> products;
  final String categoryid;
  const SizeFilter({
    super.key,
    required this.context,
    required this.onChanged,
    required this.products,
    required this.categoryid,
  });

  @override
  State<SizeFilter> createState() => _SizeFilterState();
}

class _SizeFilterState extends State<SizeFilter> {
  final List<VSize> _categorysizes = [];
  final List<String> selectedSizes = [];

  late List<VSize> _sizes = [];

  @override
  void initState() {
    super.initState();
    for (Product product in widget.products) {
      for (ProductSize productsize in product.productsizes!) {
        VSize vsize = VSize(
          sizeid: productsize.sizeid,
          title: productsize.size,
        );
        _sizes.add(vsize);
      }
    }
    final ids = _sizes.map((e) => e.sizeid).toSet();
    _sizes.retainWhere((e) => ids.remove(e.sizeid));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context = widget.context;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          height: 20,
          child: TextButton(
            onPressed: () {
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
              httpService
                  .getsizelistsbycategoryid(widget.categoryid)
                  .then((value) {
                var data = json.decode(value.toString());
                if (data["statusCode"] == 200) {
                  _categorysizes.addAll((data["data"] as List)
                      .map((e) => VSize.fromMap(e))
                      .toList());
                  overlayEntry.remove();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Sizeguide(
                        sizes: _categorysizes,
                      ),
                    ),
                  );
                } else {
                  overlayEntry.remove();
                }
              });
            },
            child: Text(
              lang.S.of(context).productdetailSizeGuide,
              style: textTheme.titleSmall?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.only(top: 10),
            crossAxisCount: 7,
            childAspectRatio: 1,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              _sizes.length,
              (index) => GridTile(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedSizes.contains(_sizes[index].sizeid)) {
                        selectedSizes.remove(_sizes[index].sizeid);
                      } else {
                        selectedSizes.add(_sizes[index].sizeid);
                      }

                      widget.onChanged(
                        selectedSizes,
                      );
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 35,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: selectedSizes.contains(_sizes[index].sizeid)
                                ? primaryColor
                                : lightGreyTextColor,
                            width: selectedSizes.contains(_sizes[index].sizeid)
                                ? 3
                                : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _sizes[index].title,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  selectedSizes.contains(_sizes[index].sizeid)
                                      ? primaryColor
                                      : lightGreyTextColor,
                              fontWeight:
                                  selectedSizes.contains(_sizes[index].sizeid)
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PriceFilter extends StatefulWidget {
  final Function(double?, double?) onChanged;
  final double startValue;
  final double endValue;
  final double startlastValue;
  final double endlastValue;

  const PriceFilter({
    super.key,
    required this.onChanged,
    required this.startValue,
    required this.endValue,
    required this.startlastValue,
    required this.endlastValue,
  });

  @override
  State<PriceFilter> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  late double _startValue;
  late double _endValue;

  @override
  void initState() {
    super.initState();
    _startValue = widget.startlastValue;
    _endValue = widget.endlastValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    LanguageChangeProvider languageChangeProvider =
        Provider.of<LanguageChangeProvider>(context, listen: true);

    bool isChangeCurr = currencySign != languageChangeProvider.currsymbol;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      '$currencySign${_startValue.round().toString()}',
                    ),
                  ),
                  if (isChangeCurr)
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text('${lang.S.of(context).commonApprox} ',
                              style: textTheme.bodySmall?.copyWith(
                                color: orangeColor,
                              )),
                          ExchangePrice(
                            price: _startValue,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: orangeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      '$currencySign${_endValue.round().toString()}',
                    ),
                  ),
                  if (isChangeCurr)
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        children: [
                          Text('${lang.S.of(context).commonApprox} ',
                              style: textTheme.bodySmall?.copyWith(
                                color: orangeColor,
                              )),
                          ExchangePrice(
                            price: _endValue,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: orangeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          RangeSlider(
            min: widget.startValue,
            max: widget.endValue,
            values: RangeValues(_startValue, _endValue),
            onChanged: (RangeValues newRange) {
              setState(() {
                _startValue = newRange.start;
                _endValue = newRange.end;

                widget.onChanged(
                  newRange.start,
                  newRange.end,
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class WhatsNewHorizonSlideList extends StatefulWidget {
  const WhatsNewHorizonSlideList({
    super.key,
  });

  @override
  State<WhatsNewHorizonSlideList> createState() =>
      _WhatsNewHorizonSlideListState();
}

class _WhatsNewHorizonSlideListState extends State<WhatsNewHorizonSlideList> {
  final List<WhatsNew> _whatsnews = [];

  late bool _isWhatsnewLoading = false;

  @override
  void initState() {
    super.initState();
    getLatestWhatsNew();
  }

  Future<void> getLatestWhatsNew() async {
    if (!_isWhatsnewLoading && mounted) {
      setState(() {
        _isWhatsnewLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getwhatsnewlists(0, 10, null).then((value) {
        var data = json.decode(value.toString());

        log('getwhatsnew code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _whatsnews.addAll((data["data"] as List)
                .map((e) => WhatsNew.fromMap(e))
                .toList());
            _isWhatsnewLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getwhatsnew isloading');
            _isWhatsnewLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (context, language, child) {
        return !language.status
            ? const SizedBox()
            : SizedBox(
                height: 395,
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
                  itemExtent: 240,
                  itemCount: _whatsnews.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                      ),
                      child: WhatsNewCard(whatsnew: _whatsnews[index]),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class WhatsNewLatest extends StatefulWidget {
  const WhatsNewLatest({super.key});

  @override
  State<WhatsNewLatest> createState() => _WhatsNewLatestState();
}

class _WhatsNewLatestState extends State<WhatsNewLatest> {
  late bool _isWhatsnewLoading = false;
  late WhatsNew _whatsnew;

  @override
  void initState() {
    super.initState();
    getLatestWhatsNew();
  }

  Future<void> getLatestWhatsNew() async {
    if (!_isWhatsnewLoading && mounted) {
      setState(() {
        _isWhatsnewLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getlatestwhatsnew(null).then((value) {
        var data = json.decode(value.toString());

        log('getwhatsnew code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _whatsnew = WhatsNew.fromMap(data["data"]);
            _isWhatsnewLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getwhatsnew isloading');
            _isWhatsnewLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: horizonSpace,
        right: horizonSpace,
      ),
      child: _isWhatsnewLoading
          ? Center(
              child: Shimmer.fromColors(
                baseColor: shimmerbaseColor,
                highlightColor: shimmerhilightColor,
                child: AspectRatio(
                  aspectRatio: 4 / 3, // 16:9 aspect ratio
                  child: Container(
                    color: whiteColor,
                  ),
                ),
              ),
            )
          : InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Whatsnewdetail(
                      whatsnew: _whatsnew,
                    ),
                  ),
                );
              },
              child: ImageStackCard(
                url: _whatsnew.portraiturl!,
                width: 948,
              ),
            ),
    );
  }
}

class EventHorizonSlideList extends StatefulWidget {
  const EventHorizonSlideList({
    super.key,
  });

  @override
  State<EventHorizonSlideList> createState() => _EventHorizonSlideListState();
}

class _EventHorizonSlideListState extends State<EventHorizonSlideList> {
  final List<Event> _events = [];

  late bool _isEventLoading = false;

  @override
  void initState() {
    super.initState();
    getLatestEvent();
  }

  Future<void> getLatestEvent() async {
    if (!_isEventLoading && mounted) {
      setState(() {
        _isEventLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getlatesteventlists(null).then((value) {
        var data = json.decode(value.toString());

        log('getevent code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _events.addAll(
                (data["data"] as List).map((e) => Event.fromMap(e)).toList());
            _isEventLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getevent isloading');
            _isEventLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (context, language, child) {
        return !language.status || _events.isEmpty
            ? const SizedBox()
            : SizedBox(
                height: 448,
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
                  itemExtent: 340,
                  itemCount: _events.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Eventdetail(
                            event: _events[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                      ),
                      child: EventCard(event: _events[index]),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class ProductSizePicker extends StatefulWidget {
  final ValueChanged<int> onSelectedItemChanged;
  final List<ProductSize> productsize;

  const ProductSizePicker({
    super.key,
    required this.onSelectedItemChanged,
    required this.productsize,
  });

  @override
  State<ProductSizePicker> createState() => _ProductSizePickerState();
}

class _ProductSizePickerState extends State<ProductSizePicker> {
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 200,
      child: CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 26.0,
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedItem = index;
          });
          widget.onSelectedItemChanged(index);
        },
        scrollController:
            FixedExtentScrollController(initialItem: _selectedItem),
        children: widget.productsize
            .map(
              (e) => Text(
                e.size,
                style: textTheme.bodyLarge,
              ),
            )
            .toList(),
      ),
    );
  }
}

class BrandMenu extends StatefulWidget {
  final Brand brand;
  const BrandMenu({
    super.key,
    required this.brand,
  });

  @override
  State<BrandMenu> createState() => _BrandMenuState();
}

class _BrandMenuState extends State<BrandMenu> {
  final List<Category> _categorys = [];

  @override
  void initState() {
    super.initState();
    getCategorys();
  }

  Future<void> getCategorys() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String? brandid = pres.getString("brandid");

    if (brandid != null && brandid != widget.brand.brandid) {
      pres.remove("brandcategorys");
    }
    pres.setString("brandid", widget.brand.brandid);

    String? brandcategorys = pres.getString("brandcategorys");

    if (brandcategorys != null) {
      setState(() {
        _categorys.addAll((json.decode(brandcategorys) as List)
            .map((e) => Category.fromMap(e))
            .toList());
      });
    } else {
      HttpService httpService = HttpService();
      await httpService
          .getcategorylists(widget.brand.brandid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getcategorys code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          pres.setString("brandcategorys", json.encode(data["data"]));

          setState(() {
            _categorys.addAll((data["data"] as List)
                .map((e) => Category.fromMap(e))
                .toList());
          });
        } else if (mounted) {
          setState(() {
            log('getcategorys failed');
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          shrinkWrap: true,
          itemCount: _categorys.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (_, i) {
            return ExpansionTile(
              dense: false,
              initiallyExpanded: false,
              childrenPadding: const EdgeInsets.only(
                left: 5,
              ),
              title: Text(
                _categorys[i].title,
                style: textTheme.bodyMedium,
              ),
              children: [
                ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  itemCount: _categorys[i].subcategorys!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, j) {
                    return ExpansionTile(
                      dense: false,
                      title: Text(
                        _categorys[i].subcategorys![j].title,
                        style: textTheme.bodyMedium,
                      ),
                      childrenPadding: const EdgeInsets.only(
                        left: 5,
                      ),
                      children: [
                        ListTile(
                          dense: false,
                          title: Text(
                            '${lang.S.of(context).commonSeeAll} ${capitalizeFirstLetter(_categorys[i].subcategorys![j].title)}',
                            style: textTheme.bodyMedium,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Productlist(
                                  categorytitle:
                                      '${lang.S.of(context).commonSeeAll} ${capitalizeFirstLetter(_categorys[i].subcategorys![j].title)}',
                                  categoryid: _categorys[i].categoryid,
                                  subcategoryid: _categorys[i]
                                      .subcategorys![j]
                                      .subcategoryid,
                                  brandid: widget.brand.brandid,
                                ),
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          shrinkWrap: true,
                          itemCount: _categorys[i]
                              .subcategorys![j]
                              .thirdcategorys
                              .length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, k) {
                            return ListTile(
                              dense: false,
                              title: Text(
                                _categorys[i]
                                    .subcategorys![j]
                                    .thirdcategorys[k]
                                    .title,
                                style: textTheme.bodyMedium,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Productlist(
                                      categorytitle: _categorys[i]
                                          .subcategorys![j]
                                          .thirdcategorys[k]
                                          .title,
                                      categoryid: _categorys[i].categoryid,
                                      thirdcategoryid: _categorys[i]
                                          .subcategorys![j]
                                          .thirdcategorys[k]
                                          .thirdcategoryid,
                                      brandid: widget.brand.brandid,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                )
              ],
            );
          },
        ),
        ListTile(
          title: Text(
            lang.S.of(context).drawerBrandhome,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homebrand(
                  brand: widget.brand,
                ),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            lang.S.of(context).drawerStory,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Story(
                  brand: widget.brand,
                ),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            lang.S.of(context).drawerCampaign,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Campaigns(
                  brand: widget.brand,
                ),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            lang.S.of(context).drawerCollection,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Collections(
                  brand: widget.brand,
                ),
              ),
            );
          },
        ),
        /*ListTile(
          title: Text(
            lang.S.of(context).drawerJustforyou,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Justforyous(
                  brand: widget.brand,
                ),
              ),
            );
          },
        ),*/
        ListTile(
          title: Text(
            lang.S.of(context).drawerShareamoment,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Designers(
                  brand: widget.brand,
                ),
              ),
            );
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          leading: const Icon(IconlyBold.bookmark),
          horizontalTitleGap: 8,
          title: Text(
            lang.S.of(context).drawerAllBrands,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(
                  bottomNavIndex: 1,
                ),
              ),
              (route) => false,
            );
          },
        ),
        ListTile(
          leading: const Icon(IconlyBold.home),
          horizontalTitleGap: 8,
          title: Text(
            lang.S.of(context).drawerVMHome,
            style: textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}

class CollectionsList extends StatelessWidget {
  final List<Collection> collections;
  const CollectionsList({
    super.key,
    required this.collections,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: collections.length,
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
                  collection: collections[index],
                ),
              ),
            );
          },
          child: ImageStackCard(
            url: collections[index].portraiturl!,
            title: collections[index].subtitle,
            subtitle: collections[index].title,
            flagurl: collections[index].flagurl!,
            width: 948,
          ),
        ),
      ),
    );
  }
}

class PopularBrandsList extends StatefulWidget {
  final String categoryid;
  const PopularBrandsList({
    super.key,
    required this.categoryid,
  });

  @override
  State<PopularBrandsList> createState() => _PopularBrandsListState();
}

class _PopularBrandsListState extends State<PopularBrandsList> {
  final List<Brand> _brands = [];

  late bool _isBrandLoading = false;

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
    if (!_isBrandLoading) {
      setState(() {
        _isBrandLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getcategorypopularbrandlists(widget.categoryid, null)
          .then((value) {
        var data = json.decode(value.toString());

        log('getbrands code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          if (mounted) {
            setState(() {
              _brands.addAll(
                  (data["data"] as List).map((e) => Brand.fromMap(e)).toList());

              _isBrandLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              log('getbrands isloading');
              _isBrandLoading = false;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      shrinkWrap: true,
      itemCount: _brands.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, k) => Padding(
        padding: const EdgeInsets.only(
          left: horizonSpace,
          right: horizonSpace,
          bottom: 10,
        ),
        child: ExpansionTile(
          dense: false,
          backgroundColor: bggray100,
          collapsedBackgroundColor: bggray100,
          leading: BrandFavoriteIcon(brandid: _brands[k].brandid),
          title: Row(
            children: [
              Text(
                _brands[k].title,
                style:
                    textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              _brands[k].flagurl != null
                  ? Image(
                      image: NetworkImage(_brands[k].flagurl!),
                    )
                  : const SizedBox(),
            ],
          ),
          trailing: ImageStackCard(
            url: _brands[k].iconurl!,
            width: 40,
          ),
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
        ),
      ),
    );
  }
}

class CategorysList extends StatelessWidget {
  final List<Category> categorys;
  const CategorysList({
    super.key,
    required this.categorys,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: categorys.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(
          bottom: itemSpace,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Categorydetail(
                  category: categorys[index],
                ),
              ),
            );
          },
          child: ImageStackCard(
            url: categorys[index].landscapeurl!,
            title: categorys[index].title,
            width: 1001,
          ),
        ),
      ),
    );
  }
}

class ProductsHorizonSlideList extends StatelessWidget {
  final List<Product> products;

  const ProductsHorizonSlideList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (context, language, child) {
        return !language.status
            ? const SizedBox()
            : SizedBox(
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
                  itemExtent: 240,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
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
                      httpService
                          .getproductbyid(products[index].productid, null)
                          .then((value) {
                        var data = json.decode(value.toString());
                        if (data["statusCode"] == 200) {
                          overlayEntry.remove();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                product: Product.fromMap(data["data"]),
                              ),
                            ),
                          );
                        } else {
                          overlayEntry.remove();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                        right: 2,
                      ),
                      child: ProductCard(
                        product: products[index],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class ProductVerticalLists extends StatefulWidget {
  final String? categoryid;
  final String? subcategoryid;
  final String? thirdcategoryid;
  final String? brandid;
  final String? collectionid;
  final String? justforyouid;
  final String? whatsnewid;
  final String? eventid;
  final String? q;
  final ScrollController controller;

  const ProductVerticalLists({
    super.key,
    this.categoryid,
    this.subcategoryid,
    this.thirdcategoryid,
    this.brandid,
    this.collectionid,
    this.justforyouid,
    this.whatsnewid,
    this.eventid,
    this.q,
    required this.controller,
  });

  @override
  State<ProductVerticalLists> createState() => _ProductVerticalListsState();
}

class _ProductVerticalListsState extends State<ProductVerticalLists> {
  final List<Product> _products = [];
  final int _take = 10;

  late bool _isLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;

  @override
  void initState() {
    super.initState();
    getProducts();
    widget.controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.controller.position.pixels ==
        widget.controller.position.maxScrollExtent) {
      getProducts();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getProducts() async {
    if (_hasMore && !_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getproductlistsbyparameters(
        _skip,
        _take,
        widget.categoryid,
        widget.subcategoryid,
        widget.thirdcategoryid,
        widget.brandid,
        widget.collectionid,
        widget.justforyouid,
        widget.whatsnewid,
        widget.eventid,
        widget.q,
        null,
      )
          .then((value) {
        var data = json.decode(value.toString());

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _products.addAll(
                (data["data"] as List).map((e) => Product.fromMap(e)).toList());
            _skip = _skip + _take;
            _isLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;
          });
        } else if (mounted) {
          setState(() {
            _isLoading = false;
            _hasMore = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (context, language, child) {
        return !language.status
            ? const SizedBox()
            : GridView.count(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.only(
                  left: 13,
                  right: 13,
                ),
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.9,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  _hasMore ? _products.length + 2 : _products.length,
                  (index) {
                    if (index >= _products.length) {
                      return Shimmer.fromColors(
                        baseColor: shimmerbaseColor,
                        highlightColor: shimmerhilightColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 2,
                            left: 2,
                          ),
                          child: Container(
                            color: whiteColor,
                          ),
                        ),
                      );
                    }
                    return InkWell(
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
                        httpService
                            .getproductbyid(_products[index].productid, null)
                            .then((value) {
                          var data = json.decode(value.toString());
                          if (data["statusCode"] == 200) {
                            overlayEntry.remove();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetail(
                                  product: Product.fromMap(data["data"]),
                                ),
                              ),
                            );
                          } else {
                            overlayEntry.remove();
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 2,
                        ),
                        child: ProductCard(
                          product: _products[index],
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}

class WarnModal extends StatelessWidget {
  final String title;
  final String message;

  const WarnModal({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: whiteColor,
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: primaryColor,
        ),
      ),
      content: Text(
        message,
        style: textTheme.titleSmall,
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: darkColor,
          ),
          child: Text(
            lang.S.of(context).commonExit,
            style: textTheme.titleSmall?.copyWith(
              color: whiteColor,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class GifPhotoPlay extends StatelessWidget {
  final String pathh;
  const GifPhotoPlay({
    super.key,
    required this.pathh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            pathh,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class VideoPlay extends StatefulWidget {
  final String pathh;
  final bool isautoplay;
  final bool control;

  const VideoPlay({
    super.key,
    required this.pathh,
    required this.isautoplay,
    required this.control,
  });

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController controller;
  late bool _isEnd = false;
  late bool _isSoundOn = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.pathh))
      ..initialize().whenComplete(() {
        if (widget.isautoplay) {
          controller.play();
        }
      })
      ..setLooping(false)
      ..setVolume(0.0)
      ..addListener(() {
        if (controller.value.isInitialized &&
            controller.value.position == controller.value.duration) {
          if (mounted) {
            setState(() {
              _isEnd = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isEnd = false;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? Stack(
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Positioned(
                right: 40,
                bottom: 4,
                child: widget.control
                    ? IconButton(
                        onPressed: () {
                          if (controller.value.isPlaying) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                          setState(() {
                            _isEnd = false;
                          });
                        },
                        iconSize: 25,
                        color: primaryColor,
                        icon: Icon(controller.value.isPlaying && !_isEnd
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline),
                      )
                    : Container(),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: widget.control
                    ? IconButton(
                        onPressed: () {
                          if (_isSoundOn) {
                            controller.setVolume(0);
                          } else {
                            controller.setVolume(10);
                          }
                          setState(() {
                            _isSoundOn = _isSoundOn ? false : true;
                          });
                        },
                        iconSize: 25,
                        color: primaryColor,
                        icon: Icon(
                            _isSoundOn ? Icons.volume_mute : Icons.volume_up),
                      )
                    : Container(),
              ),
            ],
          )
        : const LoadingCircle();
  }
}

class VmPlayer extends StatelessWidget {
  final VideoPlayerController videocontroller;
  final bool iscontrol;

  const VmPlayer({
    super.key,
    required this.videocontroller,
    required this.iscontrol,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayer(videocontroller),
        Positioned(
          right: 4,
          bottom: 4,
          child: iscontrol
              ? IconButton(
                  onPressed: () {
                    if (videocontroller.value.isPlaying) {
                      videocontroller.pause();
                    } else {
                      videocontroller.play();
                    }
                  },
                  iconSize: 25,
                  color: primaryColor,
                  icon: Icon(videocontroller.value.isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline),
                )
              : Container(),
        ),
      ],
    );
  }
}
