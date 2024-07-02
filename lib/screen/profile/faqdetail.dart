import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Faqdetail extends StatefulWidget {
  final Faq faq;
  const Faqdetail({
    super.key,
    required this.faq,
  });

  @override
  State<Faqdetail> createState() => _FaqdetailState();
}

class _FaqdetailState extends State<Faqdetail> {
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
          widget.faq.title,
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
      body: ListView.builder(
        padding: const EdgeInsets.only(
          left: horizonSpace,
          right: horizonSpace,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.faq.faqlists.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: Text(
                  widget.faq.faqlists[index].question,
                  style: textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                  ),
                ),
              ),
              Html(
                data: widget.faq.faqlists[index].answer,
                style: {
                  'html': Style(
                    textAlign: TextAlign.center,
                  ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
