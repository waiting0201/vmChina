import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import 'lawdetail.dart';

class Privacysetting extends StatefulWidget {
  const Privacysetting({
    super.key,
  });

  @override
  State<Privacysetting> createState() => _PrivacysettingState();
}

class _PrivacysettingState extends State<Privacysetting> {
  late bool _isOrder = true;
  late bool _isPromote = true;
  late bool _isPrivacyLoading = false;
  late Law _law;

  @override
  void initState() {
    super.initState();
    getPrivacy();
  }

  Future<void> getPrivacy() async {
    if (!_isPrivacyLoading && mounted) {
      setState(() {
        _isPrivacyLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getlawbyid(1, null).then((value) {
        var data = json.decode(value.toString());

        log('getPrivacy code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _law = Law.fromMap(data["data"]);
            _isPrivacyLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getPrivacy isloading');
            _isPrivacyLoading = false;
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
          lang.S.of(context).privacyTitle,
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
            left: horizonSpace,
            right: horizonSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Divider(
                  color: lightbackgroundColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    lang.S.of(context).privacyCookie,
                    style: textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isOrder,
                    onChanged: (value) {
                      setState(() {
                        _isOrder = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: Text(
                  lang.S.of(context).privacyCookieCaption,
                  style: textTheme.bodySmall,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Divider(
                  color: lightbackgroundColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    lang.S.of(context).privacyPersonal,
                    style: textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Switch(
                    value: _isPromote,
                    onChanged: (value) {
                      setState(() {
                        _isPromote = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: Text(
                  lang.S.of(context).privacyPersonalCaption,
                  style: textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Lawdetail(law: _law),
                      ),
                    );
                  },
                  child: Text(
                    lang.S.of(context).privacySeePrivacy,
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
