import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../model/models.dart';
import '../../theme/theme_constants.dart';

class Photo extends StatefulWidget {
  final List<ProductMedia> productmedias;
  final int initialindex;
  final String tag;

  const Photo({
    super.key,
    required this.productmedias,
    required this.initialindex,
    required this.tag,
  });

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  final CarouselController _controller = CarouselController();
  final _transformationController = TransformationController();

  bool _isZoomed = false;
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
      body: _isZoomed
          ? GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isZoomed = false;
                });
              },
              child: InteractiveViewer(
                constrained: false,
                transformationController: _transformationController,
                onInteractionEnd: (_) {
                  double threshold = 1.0;

                  if (_transformationController.value.getMaxScaleOnAxis() <=
                      threshold) {
                    setState(() {
                      _isZoomed = false;
                    });
                  }
                },
                //boundaryMargin: const EdgeInsets.all(0.0),
                //minScale: 1.0,
                maxScale: 10.0,
                child: Center(
                  child:
                      Image.network(widget.productmedias[_selectedIndex].url),
                ),
              ),
            )
          : Center(
              child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  disableGesture: true,
                  carouselController: _controller,
                  itemCount: widget.productmedias.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) =>
                          GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTap: () {
                      setState(() {
                        _isZoomed = true;
                      });
                    },
                    onScaleStart: (details) {
                      setState(() {
                        _isZoomed = true;
                      });
                    },
                    onScaleUpdate: (details) {
                      setState(() {
                        _isZoomed = true;
                      });
                    },
                    child: Hero(
                      tag: widget.tag, // 每個圖像有唯一的tag
                      child: Image.network(widget.productmedias[index].url),
                    ),
                  ),
                  options: CarouselOptions(
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
                Positioned(
                  bottom: 0,
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
                ),
              ],
            )),
    );
  }
}
