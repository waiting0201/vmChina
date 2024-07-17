import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../model/models.dart';
import '../../theme/theme_constants.dart';

class Photoview extends StatefulWidget {
  final List<ProductMedia> productmedias;
  final int initialindex;
  final String tag;

  const Photoview({
    super.key,
    required this.productmedias,
    required this.initialindex,
    required this.tag,
  });

  @override
  State<Photoview> createState() => _PhotoviewState();
}

class _PhotoviewState extends State<Photoview> {
  final CarouselController _controller = CarouselController();
  final _transformationController = TransformationController();

  bool _isZooming = false;
  int _selectedIndex = 0; // index of the selected photo

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialindex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  //main檔MaterialApp的context
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 44,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            disableGesture: true,
            carouselController: _controller,
            itemCount: widget.productmedias.length,
            itemBuilder: (BuildContext context, int index, int realIndex) =>
                InteractiveViewer(
              transformationController: _transformationController,
              onInteractionStart: (details) {
                setState(() {
                  _isZooming = true;
                });
              },
              onInteractionEnd: (details) {
                if (_transformationController.value.getMaxScaleOnAxis() <=
                    1.0) {
                  setState(() {
                    _isZooming = false;
                  });
                }
              },
              minScale: 1.0,
              maxScale: 10.0,
              child: Hero(
                tag: widget.tag, // 每個圖像有唯一的tag
                child: Image.network(widget.productmedias[index].url),
              ),
            ),
            options: CarouselOptions(
              scrollPhysics: _isZooming
                  ? const NeverScrollableScrollPhysics()
                  : const PageScrollPhysics(),
              height: MediaQuery.of(context).size.height, // 使用螢幕高度
              initialPage: _selectedIndex,
              enableInfiniteScroll: false,
              aspectRatio: 3 / 4,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          !_isZooming
              ? Positioned(
                  bottom: 50,
                  child: Row(
                    children: widget.productmedias
                        .asMap()
                        .entries
                        .map(
                          (entry) => Container(
                            width: 35.0,
                            height: 3.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 0.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: _selectedIndex == entry.key
                                  ? darkColor
                                  : lightbackgroundColor,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
