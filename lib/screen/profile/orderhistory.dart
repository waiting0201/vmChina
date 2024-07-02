import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../screen/authentication/auth_provider.dart';
import '../../theme/theme_constants.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import '../home/home.dart';
import 'orderdetail.dart';

class Orderhistory extends StatefulWidget {
  const Orderhistory({super.key});

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {
  final List<Order> _orders = [];
  final int _take = 10;

  late bool _isLoading = false;
  late bool _hasMore = true;
  late int _skip = 0;
  late Member _member;

  @override
  void initState() {
    super.initState();
    _member = Provider.of<AuthChangeProvider>(context, listen: false).member;

    getOrders();
  }

  Future<void> getOrders() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService
          .getorderlistsbymemberid(_member.memberid, _skip, _take)
          .then((value) {
        var data = json.decode(value.toString());

        log('getorders code: ${data["statusCode"]}');

        if (data["statusCode"] == 200) {
          setState(() {
            _orders.addAll(
                (data["data"] as List).map((e) => Order.fromMap(e)).toList());
            _skip = _skip + _take;
            _isLoading = false;
            if ((data["data"] as List).length < _take) _hasMore = false;

            log('getorders isloading: $_isLoading');
            log('getorders skip: $_skip');
          });
        } else {
          setState(() {
            _isLoading = false;
            _hasMore = false;

            log('getorders isloading: $_isLoading');
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
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).meOrderHistory,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: !_isLoading && _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    IconlyLight.buy,
                    size: 100,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50,
                      right: 50,
                    ),
                    child: Text(
                      lang.S.of(context).orderhistoryEmptyCaption,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                      lang.S.of(context).commonShopNow,
                      style: textTheme.titleSmall?.copyWith(
                        color: whiteColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(
                            bottomNavIndex: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 500) {
                  //load more here
                  getOrders();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: horizonSpace,
                  right: horizonSpace,
                  bottom: verticalSpace,
                ),
                itemCount: _hasMore ? _orders.length + 1 : _orders.length,
                itemBuilder: (context, index) {
                  if (index >= _orders.length) {
                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: shimmerbaseColor,
                        highlightColor: shimmerhilightColor,
                        child: Container(
                          color: whiteColor,
                        ),
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Orderdetail(
                            order: _orders[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: OrderCard(
                        order: _orders[index],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
