import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../authentication/auth_provider.dart';
import '../authentication/log_in.dart';
import '../cart/cart_provider.dart';
import '../cart/cart.dart';
import '../cart/cartempty.dart';
import '../language/language_provider.dart';
import '../widgets/constant.dart';
import '../widgets/library.dart';
import '../brand/homebrand.dart';
import '../brand/memberplan.dart';
import '../brand/memberplanpayment.dart';
import '../home/qr_scan.dart';
import '../home/setup_provider.dart';
import '../profile/clubinsiderchangeplan.dart';
import '../profile/clubinsiderplanpayment.dart';
import '../profile/clubinsiderresumepayment.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 10.0,
        width: 10.0,
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
    );
  }
}

class CartSummary extends StatefulWidget {
  const CartSummary({
    super.key,
  });

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  late SetupChangeProvider _setupChangeProvider;

  late Setup _setup;
  late double _freight = 0;

  @override
  void initState() {
    super.initState();

    _setupChangeProvider =
        Provider.of<SetupChangeProvider>(context, listen: false);

    if (!_setupChangeProvider.isloading) {
      setState(() {
        _setup = _setupChangeProvider.setup;
        _freight = _setup.freight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<CartChangeProvider>(
      builder: (context, cart, child) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: horizonSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lang.S.of(context).cartSubtotal,
                    style: textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  ExchangePrice(
                    price: cart.getSubTotalPrice(),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 2,
                bottom: 2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lang.S.of(context).cartShippingHandling,
                    style: textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  ExchangePrice(
                    price: _freight,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lang.S.of(context).cartTotal,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ExchangePrice(
                    price: cart.getSubTotalPrice() + _freight,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '(${lang.S.of(context).cartDuty})',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreorderSummary extends StatefulWidget {
  final List<Carts> carts;
  const PreorderSummary({
    super.key,
    required this.carts,
  });

  @override
  State<PreorderSummary> createState() => _PreorderSummaryState();
}

class _PreorderSummaryState extends State<PreorderSummary> {
  late SetupChangeProvider _setupChangeProvider;

  late Setup _setup;
  late double _freight = 0;
  late double _total = 0;

  @override
  void initState() {
    super.initState();
    _total = widget.carts.fold(0, (sum, e) => sum + e.total);
    _setupChangeProvider =
        Provider.of<SetupChangeProvider>(context, listen: false);
    if (!_setupChangeProvider.isloading) {
      setState(() {
        _setup = _setupChangeProvider.setup;
        _freight = _setup.freight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: horizonSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).cartSubtotal,
                  style: textTheme.bodyMedium,
                ),
                const Spacer(),
                ExchangePrice(
                  price: _total,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).cartShippingHandling,
                  style: textTheme.bodyMedium,
                ),
                const Spacer(),
                ExchangePrice(
                  price: _freight,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).cartTotal,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ExchangePrice(
                  price: _total + _freight,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '(${lang.S.of(context).cartDuty})',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClubinsiderCard extends StatefulWidget {
  final MembershipFee membershipfee;
  final bool ismembershipfree;
  const ClubinsiderCard({
    super.key,
    required this.membershipfee,
    required this.ismembershipfree,
  });

  @override
  State<ClubinsiderCard> createState() => _ClubinsiderCardState();
}

class _ClubinsiderCardState extends State<ClubinsiderCard> {
  late bool _isBrandLoading = false;
  late bool _isExpire = false;
  late bool _isCancel = widget.membershipfee.canceldate != null &&
          widget.membershipfee.canceldate!.isNotEmpty
      ? true
      : false;

  @override
  void initState() {
    super.initState();

    _isExpire = DateTime.parse(widget.membershipfee.expiredate!)
                .compareTo(DateTime.now()) <
            0
        ? true
        : false;
  }

  Future<void> presschangeplan(String brandid, String membershipfeeid) async {
    setState(() {
      _isBrandLoading = true;
    });

    HttpService httpService = HttpService();
    await httpService.getbrandbyid(brandid, null).then((value) {
      var data = json.decode(value.toString());

      if (data["statusCode"] == 200) {
        Brand brand = Brand.fromMap(data["data"]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Clubinsiderchangeplan(
              brand: brand,
              membershipfeeid: membershipfeeid,
            ),
          ),
        );

        setState(() {
          _isBrandLoading = false;
        });
      } else {
        setState(() {
          _isBrandLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        return Card(
          elevation: 1.0,
          margin: const EdgeInsets.all(0),
          surfaceTintColor: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: darkPrimary,
                      width: 0.2,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 12,
                    bottom: 16,
                    left: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InkWell(
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
                                .getbrandbyid(
                                    widget
                                        .membershipfee.brandmemberplan!.brandid,
                                    null)
                                .then((value) {
                              var data = json.decode(value.toString());
                              if (data["statusCode"] == 200) {
                                overlayEntry.remove();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Homebrand(
                                      brand: Brand.fromMap(data["data"]),
                                    ),
                                  ),
                                );
                              } else {
                                overlayEntry.remove();
                              }
                            });
                          },
                          child: Text(
                            widget.membershipfee.brandmemberplan!.brandtitle!,
                            style: textTheme.titleMedium,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        iconSize: 20,
                        icon: const Icon(Icons.monetization_on),
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: darkColor,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  lang.S.of(context).clubinsiderPlan,
                                  style: textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                Text(
                                  widget
                                      .membershipfee.brandmemberplan!.plantitle,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                if (!_isCancel && !widget.ismembershipfree)
                                  _isBrandLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(19),
                                          child: LoadingCircle(),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            presschangeplan(
                                              widget.membershipfee
                                                  .brandmemberplan!.brandid,
                                              widget.membershipfee
                                                  .membershipfeeid,
                                            );
                                          },
                                          iconSize: 20,
                                          icon: const Icon(
                                              Icons.edit_note_outlined),
                                          color: primaryColor,
                                        ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  lang.S.of(context).clubinsiderDiscount,
                                  style: textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                Text(
                                  '${100 - (widget.membershipfee.brandmemberplan!.promote * 100)}% Off',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: darkColor,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${lang.S.of(context).clubinsiderSubscribed} : ${widget.membershipfee.orderdate}\n${lang.S.of(context).clubinsiderExpires} ${widget.membershipfee.expiredate}',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          //取消且到期
                          if (_isCancel && _isExpire)
                            TextButton(
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
                                    .getbrandbyid(
                                        widget.membershipfee.brandmemberplan!
                                            .brandid,
                                        null)
                                    .then((value) {
                                  var data = json.decode(value.toString());
                                  if (data["statusCode"] == 200) {
                                    overlayEntry.remove();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClubinsiderResumePayment(
                                          brandmemberplan: widget
                                              .membershipfee.brandmemberplan!,
                                          brand: Brand.fromMap(data["data"]),
                                          membershipfeedid: widget
                                              .membershipfee.membershipfeeid,
                                        ),
                                      ),
                                    );
                                  } else {
                                    overlayEntry.remove();
                                  }
                                });
                              },
                              child: Text(
                                lang.S.of(context).clubinsiderRenew,
                                style: textTheme.titleSmall?.copyWith(
                                  color: darkColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          //未到期
                          if (!_isExpire)
                            Text(
                              _isCancel
                                  ? '${lang.S.of(context).clubinsiderAutorenewCancelled} : ${widget.membershipfee.canceldate}'
                                  : '${lang.S.of(context).clubinsiderAutorenew} ${widget.membershipfee.expiredate}',
                              style: textTheme.bodyMedium,
                            ),
                          if (!_isExpire) const Spacer(),
                          if (!_isExpire)
                            _isCancel
                                ? IconButton(
                                    onPressed: () {
                                      OverlayEntry overlayEntry = OverlayEntry(
                                        builder: (context) => Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: const LoadingCircle(),
                                          ),
                                        ),
                                      );
                                      Overlay.of(context).insert(overlayEntry);

                                      HttpService httpService = HttpService();
                                      httpService
                                          .getbrandbyid(
                                              widget.membershipfee
                                                  .brandmemberplan!.brandid,
                                              null)
                                          .then((value) {
                                        var data =
                                            json.decode(value.toString());
                                        if (data["statusCode"] == 200) {
                                          overlayEntry.remove();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ClubinsiderResumePayment(
                                                brandmemberplan: widget
                                                    .membershipfee
                                                    .brandmemberplan!,
                                                brand:
                                                    Brand.fromMap(data["data"]),
                                                membershipfeedid: widget
                                                    .membershipfee
                                                    .membershipfeeid,
                                              ),
                                            ),
                                          );
                                        } else {
                                          overlayEntry.remove();
                                        }
                                      });
                                    },
                                    iconSize: 20,
                                    icon: const Icon(Icons.edit_note_outlined),
                                    color: primaryColor,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: whiteColor,
                                            title: Text(
                                              lang.S
                                                  .of(context)
                                                  .clubinsiderCancelTitle,
                                              style: textTheme.titleMedium
                                                  ?.copyWith(
                                                color: primaryColor,
                                              ),
                                            ),
                                            content: Text(
                                              lang.S
                                                  .of(context)
                                                  .clubinsiderCancelCaption,
                                              style: textTheme.titleSmall,
                                            ),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  lang.S.of(context).commonExit,
                                                  style: textTheme.titleSmall
                                                      ?.copyWith(
                                                    color: darkColor,
                                                  ),
                                                ),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: darkColor,
                                                ),
                                                child: Text(
                                                  lang.S
                                                      .of(context)
                                                      .commonContinue,
                                                  style: textTheme.titleSmall
                                                      ?.copyWith(
                                                    color: whiteColor,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  auth.disableautorenew(widget
                                                      .membershipfee
                                                      .membershipfeeid);
                                                  setState(() {
                                                    _isCancel = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    iconSize: 20,
                                    icon: const Icon(Icons.cancel),
                                    color: primaryColor,
                                  ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.all(0),
      surfaceTintColor: whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: darkPrimary,
                  width: 0.2,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: 12,
                bottom: 16,
                left: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      order.ordercode,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    FeatherIcons.chevronRight,
                    color: lightGreyTextColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              left: 16,
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: darkColor,
                        width: 0.2,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${lang.S.of(context).orderhistoryOrderDate} : ${order.orderdate}',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: darkColor,
                        width: 0.2,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).orderhistoryOrderStatus,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Text(
                              order.orderstatus,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).orderhistoryPaymentStatus,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Text(
                              order.paystatus,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: darkColor,
                        width: 0.2,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).orderhistorySubtotal,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            ExchangePrice(
                              price: order.totalprice,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).orderhistoryShippingHandling,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            ExchangePrice(
                              price: order.freight,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        lang.S.of(context).orderhistoryTotal,
                        style: textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      ExchangePrice(
                        price: order.totalprice + order.freight,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: orangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BrandExpendCard extends StatelessWidget {
  final Brand brand;
  const BrandExpendCard({
    super.key,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0.0,
      color: bggray100,
      margin: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ImageStackCard(
              url: brand.portraiturl!,
              width: 140,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    brand.summary ?? '',
                    textAlign: TextAlign.left,
                    style: textTheme.bodySmall,
                  ),
                ),
                OutlinedButton(
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
                    httpService.getbrandbyid(brand.brandid, null).then((value) {
                      var data = json.decode(value.toString());
                      if (data["statusCode"] == 200) {
                        overlayEntry.remove();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homebrand(
                              brand: Brand.fromMap(data["data"]),
                            ),
                          ),
                        );
                      } else {
                        overlayEntry.remove();
                      }
                    });
                  },
                  child: Text(
                    lang.S.of(context).commonSeeMore,
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubCategoryCard extends StatelessWidget {
  final Subcategory subcategory;
  const SubCategoryCard({
    super.key,
    required this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Image(
                  image: CachedNetworkImageProvider(
                    subcategory.portraiturl!,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subcategory.title,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsNewCard extends StatelessWidget {
  final WhatsNew whatsnew;
  const WhatsNewCard({
    super.key,
    required this.whatsnew,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image(
              image: CachedNetworkImageProvider(
                whatsnew.portraiturl!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  whatsnew.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  whatsnew.title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: textTheme.displayMedium,
                ),
                const SizedBox(height: 3),
                if (whatsnew.summary != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Text(
                      whatsnew.summary!,
                      maxLines: 2,
                      softWrap: true,
                      style: textTheme.displaySmall,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageStackCard(
            url: event.portraiturl!,
            title: event.subtitle,
            subtitle: event.title,
            flagurl: event.flagurl!,
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Image(
                  image: CachedNetworkImageProvider(
                    product.portraiturl!,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: ProductFavoriteIcon(
                  product: product,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          product.brandtitle.toUpperCase(),
                          maxLines: 2,
                          softWrap: true,
                          style: textTheme.displaySmall?.copyWith(
                            color: darkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image(
                        image: NetworkImage(product.flagurl!),
                        width: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    softWrap: true,
                    style: textTheme.displaySmall,
                  ),
                ),
                const SizedBox(height: 3),
                ProductPrice(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangePrice extends StatelessWidget {
  final double price;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  const ExchangePrice({
    super.key,
    required this.price,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    LanguageChangeProvider languageChangeProvider =
        Provider.of<LanguageChangeProvider>(context, listen: true);

    return Text(
      '${languageChangeProvider.currsymbol}${convertCurrency(price, languageChangeProvider.exchange)}',
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ClubInsiderPrice extends StatelessWidget {
  final List<BrandMemberPlan> brandmemberplans;
  final Product product;
  const ClubInsiderPrice({
    super.key,
    required this.brandmemberplans,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    LanguageChangeProvider languageChangeProvider =
        Provider.of<LanguageChangeProvider>(context, listen: true);

    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        bool isChangeCurr = currencySign != languageChangeProvider.currsymbol;

        return ListView.builder(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: brandmemberplans.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Text(
                  '${brandmemberplans[index].plantitle} $currencySign${(product.price * brandmemberplans[index].promote).roundToDouble().toStringAsFixed(0)}',
                  style: textTheme.titleSmall?.copyWith(color: darkColor),
                ),
                if (isChangeCurr)
                  Text(
                    ' / ${lang.S.of(context).commonApprox} ',
                    style: textTheme.bodySmall
                        ?.copyWith(color: lightGreyTextColor),
                  ),
                if (isChangeCurr)
                  ExchangePrice(
                    price: (product.price * brandmemberplans[index].promote)
                        .roundToDouble(),
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class ProductPrice extends StatelessWidget {
  final Product product;
  const ProductPrice({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    LanguageChangeProvider languageChangeProvider =
        Provider.of<LanguageChangeProvider>(context, listen: true);
    double discountprice = 0;

    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        bool isbrandmember = auth.status &&
            auth.member.membershipfees!.isNotEmpty &&
            auth.member.membershipfees!
                .any((e) => e.brandmemberplan!.brandid == product.brandid);

        //club insider price
        if (isbrandmember) {
          MembershipFee membershipfee = auth.member.membershipfees!.singleWhere(
              (e) => e.brandmemberplan!.brandid == product.brandid);

          discountprice =
              product.price * membershipfee.brandmemberplan!.promote;
          discountprice = discountprice.roundToDouble();
        }

        bool isChangeCurr = currencySign != languageChangeProvider.currsymbol;

        return isbrandmember
            ? Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '$currencySign${discountprice.toStringAsFixed(0)}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$currencySign${product.price.toStringAsFixed(0)}',
                        style: textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  if (isChangeCurr)
                    Row(
                      children: [
                        Text('${lang.S.of(context).commonApprox} ',
                            style: textTheme.bodySmall),
                        ExchangePrice(
                          price: discountprice,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$currencySign${product.price.toStringAsFixed(0)}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isChangeCurr)
                    Row(
                      children: [
                        Text('${lang.S.of(context).commonApprox} ',
                            style: textTheme.bodySmall),
                        ExchangePrice(
                          price: product.price,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                ],
              );
      },
    );
  }
}

class BrandFavoriteIcon extends StatefulWidget {
  final String brandid;
  const BrandFavoriteIcon({
    super.key,
    required this.brandid,
  });

  @override
  State<BrandFavoriteIcon> createState() => _BrandFavoriteIconState();
}

class _BrandFavoriteIconState extends State<BrandFavoriteIcon> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
  }

  Future<void> postaddmemberbrand(AuthChangeProvider auth) async {
    HttpService httpService = HttpService();
    await httpService
        .postaddmemberbrand(auth.member.memberid, widget.brandid)
        .then((value) {
      var data = json.decode(value.toString());
      if (data["statusCode"] == 200) {
        auth.refreshMember();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        _isFavorite = auth.status &&
            auth.member.memberbrands!.any((e) => e.brandid == widget.brandid);
        return IconButton(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerRight,
          onPressed: () {
            if (auth.status) {
              /*setState(() {
                _isFavorite = !_isFavorite;
              });*/
              postaddmemberbrand(auth);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogIn(),
                ),
              );
            }
          },
          icon: _isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: primaryColor,
                  size: 22,
                )
              : const Icon(
                  Icons.favorite_outline,
                  size: 22,
                ),
        );
      },
    );
  }
}

class ProductFavoriteIcon extends StatefulWidget {
  final Product product;
  const ProductFavoriteIcon({
    super.key,
    required this.product,
  });

  @override
  State<ProductFavoriteIcon> createState() => _ProductFavoriteIconState();
}

class _ProductFavoriteIconState extends State<ProductFavoriteIcon> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
  }

  Future<void> postaddmemberproduct(AuthChangeProvider auth) async {
    HttpService httpService = HttpService();
    await httpService
        .postaddmemberproduct(auth.member.memberid, widget.product.productid)
        .then((value) {
      var data = json.decode(value.toString());
      if (data["statusCode"] == 200) {
        auth.refreshMember();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        _isFavorite = auth.status &&
            auth.member.memberproducts!
                .any((e) => e.productid == widget.product.productid);
        return IconButton(
          alignment: Alignment.centerRight,
          onPressed: () {
            if (auth.status) {
              /*setState(() {
                _isFavorite = !_isFavorite;
              });*/
              postaddmemberproduct(auth);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogIn(),
                ),
              );
            }
          },
          icon: _isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: primaryColor,
                  size: 22,
                )
              : const Icon(
                  Icons.favorite_outline,
                  size: 22,
                ),
        );
      },
    );
  }
}

class ScanIcon extends StatelessWidget {
  const ScanIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QRScan(),
        ),
      ),
      icon: const Icon(
        IconlyBold.scan,
        color: lightIconColor,
      ),
    );
  }
}

class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<CartChangeProvider>(
      builder: (context, cart, child) => Stack(
        children: [
          IconButton(
            icon: const Icon(
              IconlyLight.bag2,
              size: 22,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    cart.itemcount != 0 ? const Cart() : const CartEmpty(),
              ),
            ),
          ),
          if (cart.itemcount != 0)
            Positioned(
              right: 5,
              top: 5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '${cart.itemcount}',
                  style: textTheme.bodySmall?.copyWith(
                    color: whiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MemberPlanSubscribeButton extends StatelessWidget {
  final BrandMemberPlan plan;
  final Brand brand;
  final double? totalspend;
  const MemberPlanSubscribeButton({
    required this.plan,
    required this.brand,
    this.totalspend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    late MembershipFee membershipfee;
    late bool isbrandmember = false;
    late bool isvip = false;

    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        isbrandmember = auth.status &&
            auth.member.membershipfees!.isNotEmpty &&
            auth.member.membershipfees!.any((e) =>
                e.brandmemberplan!.brandid == brand.brandid &&
                e.brandmemberplan!.brandmemberplanid == plan.brandmemberplanid);

        if (auth.status &&
            auth.member.membershipfees!.isNotEmpty &&
            auth.member.membershipfees!
                .any((e) => e.brandmemberplan!.brandid == brand.brandid)) {
          membershipfee = auth.member.membershipfees!
              .singleWhere((e) => e.brandmemberplan!.brandid == brand.brandid);
          if (membershipfee.brandmemberplan!.plantitle == 'VIP') {
            isvip = true;
          }
        }

        return isbrandmember
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: orangeColor,
                  side: const BorderSide(color: orangeColor),
                ),
                onPressed: () {},
                child: Text(
                  lang.S.of(context).commonCurrentPlan,
                  style: textTheme.titleSmall?.copyWith(
                    color: whiteColor,
                  ),
                ),
              )
            : auth.status && totalspend != null && totalspend! < plan.totalspend
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: disablegrayColor,
                      side: const BorderSide(color: disablegrayColor),
                    ),
                    onPressed: () {},
                    child: Text(
                      lang.S.of(context).commonNotQualified,
                      style: textTheme.titleSmall?.copyWith(
                        color: whiteColor,
                      ),
                    ),
                  )
                : isvip
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: disablegrayColor,
                          side: const BorderSide(color: disablegrayColor),
                        ),
                        onPressed: () {},
                        child: Text(
                          lang.S.of(context).commonSubscribe,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: primaryColor,
                          side: const BorderSide(color: primaryColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => auth.status
                                  ? MemberPlanPayment(
                                      brandmemberplan: plan,
                                      brand: brand,
                                    )
                                  : const LogIn(),
                            ),
                          );
                        },
                        child: Text(
                          lang.S.of(context).commonSubscribe,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      );
      },
    );
  }
}

class ClubinsiderPlanSubscribeButton extends StatelessWidget {
  final BrandMemberPlan plan;
  final Brand brand;
  final String membershipfeeid;
  final double? totalspend;
  const ClubinsiderPlanSubscribeButton({
    required this.plan,
    required this.brand,
    required this.membershipfeeid,
    this.totalspend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    late MembershipFee membershipfee;
    late bool isbrandmember = false;
    late bool isvip = false;

    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        isbrandmember = auth.status &&
            auth.member.membershipfees!.isNotEmpty &&
            auth.member.membershipfees!.any((e) =>
                e.brandmemberplan!.brandid == brand.brandid &&
                e.brandmemberplan!.brandmemberplanid == plan.brandmemberplanid);

        if (auth.status &&
            auth.member.membershipfees!.isNotEmpty &&
            auth.member.membershipfees!
                .any((e) => e.brandmemberplan!.brandid == brand.brandid)) {
          membershipfee = auth.member.membershipfees!
              .singleWhere((e) => e.brandmemberplan!.brandid == brand.brandid);
          if (membershipfee.brandmemberplan!.plantitle == 'VIP') {
            isvip = true;
          }
        }

        return isbrandmember
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: orangeColor,
                  side: const BorderSide(color: orangeColor),
                ),
                onPressed: () {},
                child: Text(
                  lang.S.of(context).commonCurrentPlan,
                  style: textTheme.titleSmall?.copyWith(
                    color: whiteColor,
                  ),
                ),
              )
            : auth.status && totalspend != null && totalspend! < plan.totalspend
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: disablegrayColor,
                      side: const BorderSide(color: disablegrayColor),
                    ),
                    onPressed: () {},
                    child: Text(
                      lang.S.of(context).commonNotQualified,
                      style: textTheme.titleSmall?.copyWith(
                        color: whiteColor,
                      ),
                    ),
                  )
                : isvip
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: disablegrayColor,
                          side: const BorderSide(color: disablegrayColor),
                        ),
                        onPressed: () {},
                        child: Text(
                          lang.S.of(context).commonSubscribe,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: primaryColor,
                          side: const BorderSide(color: primaryColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => auth.status
                                  ? ClubinsiderPlanPayment(
                                      brandmemberplan: plan,
                                      brand: brand,
                                      membershipfeedid: membershipfeeid,
                                    )
                                  : const LogIn(),
                            ),
                          );
                        },
                        child: Text(
                          lang.S.of(context).commonSubscribe,
                          style: textTheme.titleSmall?.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      );
      },
    );
  }
}

class MemberPlanIcon extends StatelessWidget {
  final Brand brand;
  const MemberPlanIcon({
    required this.brand,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    late MembershipFee membershipfee;
    late Color bgcolor;

    return Consumer<AuthChangeProvider>(
      builder: (context, auth, child) {
        bool isbrandmember = auth.status &&
            auth.member.membershipfees!.isNotEmpty &&
            auth.member.membershipfees!
                .any((e) => e.brandmemberplan!.brandid == brand.brandid);

        if (isbrandmember) {
          membershipfee = auth.member.membershipfees!
              .singleWhere((e) => e.brandmemberplan!.brandid == brand.brandid);
          if (membershipfee.brandmemberplan!.plantitle == 'VIP') {
            bgcolor = redColor;
          } else if (membershipfee.brandmemberplan!.plantitle == 'STANDARD') {
            bgcolor = primaryColor;
          } else {
            bgcolor = infoColor;
          }
        }

        return isbrandmember
            ? OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: bgcolor,
                  surfaceTintColor: whiteColor,
                  side: BorderSide(color: bgcolor),
                ),
                child: Text(
                  membershipfee.brandmemberplan!.plantitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberPlan(
                        brand: brand,
                      ),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.0),
                ),
                backgroundColor: primaryColor,
                child: const Icon(
                  IconlyLight.addUser,
                  size: 36.0,
                  color: Colors.white,
                ),
              );
      },
    );
  }
}

class ImageStackCard extends StatelessWidget {
  final String url;
  final String? title;
  final String? subtitle;
  final String? flagurl;
  final double? width;

  const ImageStackCard({
    super.key,
    required this.url,
    this.title,
    this.subtitle,
    this.flagurl,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: CachedNetworkImageProvider(
              url,
            ),
            width: width,
          ),
          Positioned(
            left: 0,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: horizonSpace,
                    ),
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        subtitle!,
                        maxLines: 2,
                        softWrap: true,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: horizonSpace,
                    ),
                    child: Row(
                      children: [
                        Text(
                          title!,
                          style: textTheme.labelMedium
                              ?.copyWith(color: whiteColor),
                        ),
                        const SizedBox(width: 5),
                        flagurl != null
                            ? Image(
                                image: NetworkImage(flagurl!),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
