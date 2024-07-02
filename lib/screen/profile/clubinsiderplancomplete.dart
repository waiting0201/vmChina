import 'dart:convert';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../../model/repository.dart';
import '../../model/models.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../brand/homebrand.dart';

class ClubinsiderPlanComplete extends StatefulWidget {
  final BrandMemberPlan brandmemberplan;
  final Brand brand;
  final bool result;
  const ClubinsiderPlanComplete({
    required this.brandmemberplan,
    required this.brand,
    required this.result,
    super.key,
  });

  @override
  State<ClubinsiderPlanComplete> createState() =>
      _ClubinsiderPlanCompleteState();
}

class _ClubinsiderPlanCompleteState extends State<ClubinsiderPlanComplete> {

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
          lang.S.of(context).memberplanpaymentcompleteTitle,
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
                widget.result
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 100.0,
                          )
                        : const Icon(Icons.warning_rounded,
                            color: Colors.amber, size: 100.0),
                Padding(
                  padding: const EdgeInsets.only(
                    top: verticalSpace,
                    left: horizonSpace,
                    right: horizonSpace,
                  ),
                  child: Text(
                    widget.result
                            ? lang.S
                                .of(context)
                                .memberplanpaymentcompleteSucceeded
                            : lang.S.of(context).memberplanpaymentcompleteWrong,
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
                    widget.result
                            ? lang.S
                                .of(context)
                                .memberplanpaymentcompleteSucceededCaption(
                                    widget.brand.title,
                                    widget.brandmemberplan.plantitle)
                            : lang.S
                                .of(context)
                                .memberplanpaymentcompleteWrongCaption,
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
                        builder: (context) => const Profile(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    lang.S.of(context).memberplanpaymentcompleteViewProfile,
                    style: textTheme.titleSmall?.copyWith(
                      color: whiteColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    lang.S.of(context).commonHome,
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    OverlayEntry overlayEntry = OverlayEntry(
                      builder: (context) => Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const LoadingCircle(),
                        ),
                      ),
                    );
                    Overlay.of(context).insert(overlayEntry);

                    HttpService httpService = HttpService();
                    httpService
                        .getbrandbyid(widget.brand.brandid, null)
                        .then((value) {
                      var data = json.decode(value.toString());
                      if (data["statusCode"] == 200) {
                        overlayEntry.remove();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homebrand(
                              brand: Brand.fromMap(data["data"]),
                            ),
                          ),
                          (route) => false,
                        );
                      } else {
                        overlayEntry.remove();
                      }
                    });
                  },
                  child: Text(
                    lang.S.of(context).commonContinueBrowsing,
                    style: textTheme.titleSmall?.copyWith(
                      color: darkColor,
                      decoration: TextDecoration.underline,
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
