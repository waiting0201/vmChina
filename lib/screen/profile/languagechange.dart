import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../language/language_provider.dart';
import '../../theme/theme_constants.dart';
import '../../model/models.dart';
import '../../model/repository.dart';

class Languagechange extends StatefulWidget {
  const Languagechange({super.key});

  @override
  State<Languagechange> createState() => _LanguagechangeState();
}

class _LanguagechangeState extends State<Languagechange> {
  final List<Language> _languages = [];

  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getLanguages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLanguages() async {
    if (!_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpService httpService = HttpService();
    await httpService.getcnlanguagelists().then((value) {
      var data = json.decode(value.toString());

      log('getlanguages code: ${data["statusCode"]}');

      if (data["statusCode"] == 200 && mounted) {
        setState(() {
          _languages.addAll(
              (data["data"] as List).map((e) => Language.fromMap(e)).toList());
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<LanguageChangeProvider>(
      builder: (context, region, child) {
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
              lang.S.of(context).meRegion,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: _isLoading
              ? const SizedBox()
              : ListView(
                  padding: const EdgeInsets.all(0.0),
                  children:
                      List<Widget>.generate(_languages.length, (int index) {
                    return ListTile(
                      title: Text(
                        '${_languages[index].langtitle} - ${_languages[index].currtitle}',
                        style: textTheme.bodyMedium,
                      ),
                      trailing: (region.currentLanguage ==
                                  _languages[index].langcode &&
                              region.currentCurrency ==
                                  _languages[index].currtitle)
                          ? const Icon(Icons.check)
                          : const Text(''),
                      onTap: () {
                        region.changeLocale(_languages[index].langcode);
                        region.changeCurrency(_languages[index].currtitle);
                        region.setRegion(_languages[index].currtitle,
                            _languages[index].langcode);
                      },
                    );
                  }),
                ),
        );
      },
    );
  }
}
