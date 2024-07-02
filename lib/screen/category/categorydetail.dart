import 'package:flutter/material.dart';

import '../../model/models.dart';
import '../../theme/theme_constants.dart';
import '../widgets/partial.dart';
import '../widgets/constant.dart';
import 'productlist.dart';

class Categorydetail extends StatefulWidget {
  final Category category;
  const Categorydetail({
    super.key,
    required this.category,
  });

  @override
  State<Categorydetail> createState() => _CategorydetailState();
}

class _CategorydetailState extends State<Categorydetail> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
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
          widget.category.title,
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
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: ImageStackCard(
                url: widget.category.landscapeurl!,
              ),
            ),
            widget.category.summary != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: verticalSpace,
                      left: 50,
                      right: 50,
                    ),
                    child: Text(
                      widget.category.summary!,
                      textAlign: TextAlign.center,
                      style: textTheme.titleSmall,
                    ),
                  )
                : Container(),
            //________________________________________________________subcategorys
            Padding(
              padding: const EdgeInsets.only(
                top: verticalSpace,
                left: horizonSpace,
                right: horizonSpace,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.category.subcategorys!.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: itemSpace,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Productlist(
                            categorytitle:
                                widget.category.subcategorys![index].title,
                            categoryid: widget.category.categoryid,
                            subcategoryid: widget
                                .category.subcategorys![index].subcategoryid,
                          ),
                        ),
                      );
                    },
                    child: ImageStackCard(
                      url: widget.category.subcategorys![index].landscapeurl!,
                      title: widget.category.subcategorys![index].title,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
