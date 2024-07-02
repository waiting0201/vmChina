import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../home/home.dart';

class CartEmpty extends StatefulWidget {
  const CartEmpty({super.key});

  @override
  State<CartEmpty> createState() => _CartEmptyState();
}

class _CartEmptyState extends State<CartEmpty> {
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
        automaticallyImplyLeading: false,
        title: Text(
          lang.S.of(context).cartTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_outlined,
          ),
        ),
      ),
      body: Center(
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
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Text(
                lang.S.of(context).cartEmptyCaption,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(
                      bottomNavIndex: 2,
                    ),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                lang.S.of(context).commonShopNow,
                style: textTheme.titleSmall?.copyWith(
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
