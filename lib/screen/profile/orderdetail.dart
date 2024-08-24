import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Orderdetail extends StatefulWidget {
  final Order order;
  const Orderdetail({
    super.key,
    required this.order,
  });

  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  @override
  void initState() {
    super.initState();
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
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          widget.order.ordercode,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: horizonSpace,
          right: horizonSpace,
        ),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    lang.S.of(context).orderdetailCancelCaption,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
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
                      right: 20,
                      bottom: 16,
                      left: 20,
                    ),
                    child: Row(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            lang.S.of(context).orderdetailOrderInformation,
                            style: textTheme.titleMedium,
                          ),
                        ),
                        if (widget.order.orderstatus == "Processing" &&
                            widget.order.paystatus == "Unpaid") ...[
                          const Spacer(),
                          SizedBox(
                            width: 60,
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: primaryColor,
                                side: const BorderSide(color: primaryColor),
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                              ),
                              onPressed: () async {
                                HttpService httpService = HttpService();
                                await httpService
                                    .postcancelorder(widget.order.orderid)
                                    .then((value) {
                                  var data = json.decode(value.toString());
                                  if (data["statusCode"] == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(lang.S
                                            .of(context)
                                            .orderdetailCancelSuccess),
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(data["statusMessage"]),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Text(
                                lang.S.of(context).commonCancel,
                                style: textTheme.bodySmall
                                    ?.copyWith(color: whiteColor),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 20,
                    bottom: 12,
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailOrderType,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.ordertype,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailOrderDate,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.orderdate,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailPayStatus,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.paystatus,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailEstimated,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.deliverdate,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailShippingStatus,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.logisticstatus,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailOrderStatus,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.orderstatus,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailTrackingNumber,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.tracknumber == null
                                ? ''
                                : widget.order.tracknumber!,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailTracking,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            'LINK >',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Column(
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
                      right: 20,
                      bottom: 16,
                      left: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          lang.S.of(context).orderdetailProducts,
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    right: 20,
                    bottom: 4,
                    left: 20,
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
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.order.orderdetails.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image(
                                  width: 60,
                                  image: CachedNetworkImageProvider(
                                    widget.order.orderdetails[index]
                                        .productphotourl!,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.order.orderdetails[index]
                                            .brandtitle!,
                                        style: textTheme.displaySmall,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        widget.order.orderdetails[index]
                                            .producttitle,
                                        style: textTheme.displayMedium,
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${lang.S.of(context).orderdetailSize}:${widget.order.orderdetails[index].size}',
                                            style: textTheme.bodySmall,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'x${widget.order.orderdetails[index].quantity}',
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              color: lightGreyTextColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ExchangePrice(
                                            price: widget.order
                                                .orderdetails[index].price,
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              color: orangeColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: darkColor,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  lang.S.of(context).orderdetailPrice,
                                  style: textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                ExchangePrice(
                                  price: widget.order.totalprice,
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  lang.S.of(context).orderdetailFreight,
                                  style: textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                ExchangePrice(
                                  price: widget.order.freight,
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              lang.S.of(context).orderdetailTotalPrice,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            ExchangePrice(
                              price: widget.order.totalprice +
                                  widget.order.freight,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: orangeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '(${lang.S.of(context).orderdetailDuty})',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Column(
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
                      right: 20,
                      bottom: 16,
                      left: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          lang.S.of(context).orderdetailConsigneeInformation,
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 20,
                    bottom: 12,
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailName,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            '${widget.order.firstname} ${widget.order.lastname}',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (widget.order.phone != null) const SizedBox(height: 2),
                      if (widget.order.phone != null)
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).orderdetailPhone,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Text(
                              widget.order.phone!,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      if (widget.order.email != null) const SizedBox(height: 2),
                      if (widget.order.email != null)
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).orderdetailEmail,
                              style: textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            Text(
                              widget.order.email!,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailPostCode,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.postcode,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailAddress,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.order.address,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailDistrict,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.order.district ?? '',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailCity,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.city,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lang.S.of(context).orderdetailCountry,
                            style: textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Text(
                            widget.order.country,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
