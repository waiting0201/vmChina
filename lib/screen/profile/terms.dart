import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Terms extends StatelessWidget {
  const Terms({
    super.key,
  });

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
        centerTitle: true,
        title: Text(
          lang.S.of(context).termTitle,
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
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        actions: const [
          CartIcon(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: horizonSpace,
            right: horizonSpace,
            bottom: verticalSpace,
          ),
          child: Html(
            data: '',
            style: {
              'html': Style(
                textAlign: TextAlign.center,
              ),
            },
          ),
        ),
      ),
    );
  }
}
