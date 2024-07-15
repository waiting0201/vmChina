import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Lawdetail extends StatefulWidget {
  final Law law;
  const Lawdetail({
    super.key,
    required this.law,
  });

  @override
  State<Lawdetail> createState() => _LawdetailState();
}

class _LawdetailState extends State<Lawdetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        centerTitle: true,
        title: Text(
          widget.law.title,
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
            data: widget.law.content,
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
