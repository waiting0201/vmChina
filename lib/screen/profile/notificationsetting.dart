import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart' as lang;
import '../../theme/theme_constants.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import '../home/notification_provider.dart';
import 'privacy.dart';

class Notificationsetting extends StatefulWidget {
  const Notificationsetting({
    super.key,
  });

  @override
  State<Notificationsetting> createState() => _NotificationsettingState();
}

class _NotificationsettingState extends State<Notificationsetting> {
  late NotificationChangeProvider _notificationChangeProvider;
  late bool _isOrder;
  late bool _isPromote;

  @override
  void initState() {
    super.initState();
    _notificationChangeProvider =
        Provider.of<NotificationChangeProvider>(context, listen: false);
    setState(() {
      _isOrder = _notificationChangeProvider.isagree;
      _isPromote = _notificationChangeProvider.isagree;
    });
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
          lang.S.of(context).notificationTitle,
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
              Text(
                lang.S.of(context).notificationCaption,
                style: textTheme.bodySmall,
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
                    lang.S.of(context).notificationOrderUpdate,
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
                  lang.S.of(context).notificationOrderUpdateCaption,
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
                    lang.S.of(context).notificationPromotion,
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
                  lang.S.of(context).notificationPromotionCaption,
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
                        builder: (context) => const Privacy(),
                      ),
                    );
                  },
                  child: Text(
                    lang.S.of(context).notificationSeePrivacy,
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
