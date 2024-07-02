import '../../generated/l10n.dart' as lang;
import 'package:flutter/material.dart';

import '../../theme/theme_constants.dart';
import '../home/home.dart';
import '../widgets/constant.dart';

class Emailuscomplete extends StatefulWidget {
  final String name;
  const Emailuscomplete({
    super.key,
    required this.name,
  });

  @override
  State<Emailuscomplete> createState() => _EmailuscompleteState();
}

class _EmailuscompleteState extends State<Emailuscomplete> {
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
        iconTheme: const IconThemeData(
          color: lightIconColor,
        ),
        title: Text(
          lang.S.of(context).emailuscompleteTitle,
          style: textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: horizonSpace,
              right: horizonSpace,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: verticalSpace,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    lang.S.of(context).emailuscompleteSucceeded,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    'Thank you ${widget.name}.\n${lang.S.of(context).emailuscompleteCaption}',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: lightGreyTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 20,
                    ),
                    backgroundColor: whiteColor,
                    surfaceTintColor: whiteColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    side: const BorderSide(
                      color: darkColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    lang.S.of(context).commonHome,
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
