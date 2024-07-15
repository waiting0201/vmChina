import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';

class Legalstatement extends StatefulWidget {
  const Legalstatement({
    super.key,
  });
  @override
  State<Legalstatement> createState() => _LegalstatementState();
}

class _LegalstatementState extends State<Legalstatement> {
  late bool _isLegalLoading = false;

  final List<Legal> _legals = [];

  @override
  void initState() {
    super.initState();
    getLegals();
  }

  Future<void> getLegals() async {
    if (!_isLegalLoading && mounted) {
      setState(() {
        _isLegalLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getlegals(null).then((value) {
        var data = json.decode(value.toString());

        log('getlegals code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _legals.addAll(
                (data["data"] as List).map((e) => Legal.fromMap(e)).toList());
            _isLegalLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getlegals isloading');
            _isLegalLoading = false;
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
        centerTitle: true,
        title: Text(
          lang.S.of(context).legalTitle,
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
      body: ListView.builder(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        padding: const EdgeInsets.only(
          top: 20,
          left: horizonSpace,
          right: horizonSpace,
          bottom: verticalSpace,
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _legals.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: Text(
                  _legals[index].title,
                  style: textTheme.titleLarge!.copyWith(
                    color: primaryColor,
                  ),
                ),
              ),
              Html(
                data: _legals[index].content,
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
