import 'package:flutter/material.dart';

import '../../generated/l10n.dart' as lang;
import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';

class Sizetable extends StatefulWidget {
  final List<VSize> sizes;

  const Sizetable({
    super.key,
    required this.sizes,
  });

  @override
  State<Sizetable> createState() => _SizetableState();
}

class _SizetableState extends State<Sizetable> {
  final headers = ['#', 'US', 'EU', 'JP'];

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
          lang.S.of(context).sizeguideTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          style: IconButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            backgroundColor: whiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Text(
                lang.S.of(context).sizeguideCaption,
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: Table(
                border: TableBorder.all(
                  color: primaryColor,
                ),
                children: [
                  TableRow(
                    children: headers.map((header) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          header,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                  ...widget.sizes.map((row) {
                    return TableRow(
                      children: headers.map((header) {
                        String s = '';
                        if (header == "#") {
                          s = row.title;
                        } else if (header == "US") {
                          s = row.us ?? '';
                        } else if (header == "EU") {
                          s = row.eu ?? '';
                        } else if (header == "JP") {
                          s = row.jp ?? '';
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            s,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
