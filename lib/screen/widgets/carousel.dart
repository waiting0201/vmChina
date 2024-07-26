import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/models.dart';
import '../../model/repository.dart';
import '../../theme/theme_constants.dart';
import '../widgets/common.dart';
import '../widgets/constant.dart';
import '../widgets/partial.dart';
import '../brand/homebrand.dart';
import '../brand/collectiondetail.dart';

class CurrentBrandsCarousel extends StatefulWidget {
  const CurrentBrandsCarousel({
    super.key,
  });

  @override
  State<CurrentBrandsCarousel> createState() => _CurrentBrandsCarouselState();
}

class _CurrentBrandsCarouselState extends State<CurrentBrandsCarousel> {
  final CarouselController _carouselController = CarouselController();
  final List<Brand> _brands = [];

  late bool _isBrandLoading = false;
  late int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getShopCurrentBrands();
  }

  Future<void> getShopCurrentBrands() async {
    if (!_isBrandLoading && mounted) {
      setState(() {
        _isBrandLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getpublishstatusbrandlists(1, null).then((value) {
        var data = json.decode(value.toString());

        log('getbrand code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _brands.addAll(
                (data["data"] as List).map((e) => Brand.fromMap(e)).toList());
            _isBrandLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getbrand isloading');
            _isBrandLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    //debugInvertOversizedImages = true;

    return _isBrandLoading
        ? Shimmer.fromColors(
            baseColor: shimmerbaseColor,
            highlightColor: shimmerhilightColor,
            child: Container(
              height: 360,
              color: whiteColor,
            ),
          )
        : _brands.isEmpty
            ? const SizedBox()
            : Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      aspectRatio: 3 / 4,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                    carouselController: _carouselController,
                    itemCount: _brands.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) =>
                            InkWell(
                      onTap: () {
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
                            .getbrandbyid(_brands[index].brandid, null)
                            .then((value) {
                          var data = json.decode(value.toString());
                          if (data["statusCode"] == 200) {
                            overlayEntry.remove();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homebrand(
                                  brand: Brand.fromMap(data["data"]),
                                ),
                              ),
                            );
                          } else {
                            overlayEntry.remove();
                          }
                        });
                      },
                      child: ImageStackCard(
                        url: _brands[index].portraiturl!,
                        title: _brands[index].title,
                        subtitle: 'Discover',
                        flagurl: _brands[index].flagurl!,
                        width: 948,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      alignment: Alignment.center,
                      width: 35,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        '${_selectedIndex + 1} / ${_brands.length}',
                        style: textTheme.bodySmall
                            ?.copyWith(fontSize: 10, color: whiteColor),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Row(
                      children: _brands
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
              );
  }
}

class ComingBrandsCarousel extends StatefulWidget {
  const ComingBrandsCarousel({
    super.key,
  });

  @override
  State<ComingBrandsCarousel> createState() => _ComingBrandsCarouselState();
}

class _ComingBrandsCarouselState extends State<ComingBrandsCarousel> {
  final CarouselController _carouselController = CarouselController();
  final List<Brand> _brands = [];

  late bool _isBrandLoading = false;
  late int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getShopCurrentBrands();
  }

  Future<void> getShopCurrentBrands() async {
    if (!_isBrandLoading && mounted) {
      setState(() {
        _isBrandLoading = true;
      });

      HttpService httpService = HttpService();
      await httpService.getpublishstatusbrandlists(2, null).then((value) {
        var data = json.decode(value.toString());

        log('getbrand code: ${data["statusCode"]}');

        if (data["statusCode"] == 200 && mounted) {
          setState(() {
            _brands.addAll(
                (data["data"] as List).map((e) => Brand.fromMap(e)).toList());
            _isBrandLoading = false;
          });
        } else if (mounted) {
          setState(() {
            log('getbrand isloading');
            _isBrandLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return _isBrandLoading
        ? Shimmer.fromColors(
            baseColor: shimmerbaseColor,
            highlightColor: shimmerhilightColor,
            child: Container(
              height: 360,
              color: whiteColor,
            ),
          )
        : _brands.isEmpty
            ? const SizedBox()
            : Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      aspectRatio: 3 / 4,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                    carouselController: _carouselController,
                    itemCount: _brands.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) =>
                            ImageStackCard(
                      url: _brands[index].portraiturl!,
                      title: _brands[index].title,
                      subtitle: 'Discover',
                      flagurl: _brands[index].flagurl!,
                      width: 948,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      alignment: Alignment.center,
                      width: 35,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        '${_selectedIndex + 1} / ${_brands.length}',
                        style: textTheme.bodySmall
                            ?.copyWith(fontSize: 10, color: whiteColor),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Text(
                      'COMING SOON',
                      style: textTheme.titleLarge?.copyWith(color: whiteColor),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Row(
                      children: _brands
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
              );
  }
}

class HomebannerCarousel extends StatefulWidget {
  final List<Homebanner> homebanners;

  const HomebannerCarousel({
    super.key,
    required this.homebanners,
  });

  @override
  State<HomebannerCarousel> createState() => _HomebannerCarouselState();
}

class _HomebannerCarouselState extends State<HomebannerCarousel> {
  final CarouselController _carouselController = CarouselController();
  final List<VideoPlayerController> _videoControllers = [];
  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (Homebanner homebanner in widget.homebanners) {
      //log('video ${homebanner.videourl}');
      VideoPlayerController videoplayercontroller =
          VideoPlayerController.networkUrl(Uri.parse(homebanner.videourl))
            ..setLooping(false)
            ..setVolume(0.0);
      _videoControllers.add(videoplayercontroller);
    }

    _videoControllers[0].initialize().whenComplete(() {
      _videoControllers[0].play();
      _videoControllers[0].addListener(() {
        if (_videoControllers[0].value.isCompleted) {
          _videoControllers[0].removeListener(() {});
          _carouselController.nextPage();
        }
      });

      log('homebanner start $_currentIndex');
    });
  }

  @override
  void dispose() {
    for (VideoPlayerController controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.homebanners.length,
      itemBuilder: (BuildContext context, int index, int realIndex) => InkWell(
        onTap: () {
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
              .getbrandbyid(widget.homebanners[index].brandid, null)
              .then((value) {
            var data = json.decode(value.toString());
            if (data["statusCode"] == 200) {
              overlayEntry.remove();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homebrand(
                    brand: Brand.fromMap(data["data"]),
                  ),
                ),
              );
            } else {
              overlayEntry.remove();
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            VmPlayer(
              videocontroller: _videoControllers[index],
              iscontrol: false,
            ),
            /*Text(
              widget.homebanners[index].title,
              style: textTheme.labelMedium,
            ),*/
            Positioned(
              left: 0,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: horizonSpace,
                    ),
                    child: Text(
                      'Discover',
                      style: textTheme.bodySmall
                          ?.copyWith(fontSize: 10, color: whiteColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: horizonSpace,
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.homebanners[index].title,
                          style: textTheme.labelMedium
                              ?.copyWith(color: whiteColor),
                        ),
                        const SizedBox(width: 5),
                        Image(
                          image:
                              NetworkImage(widget.homebanners[index].flagurl),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      options: CarouselOptions(
        viewportFraction: 1,
        aspectRatio: 3 / 4,
        onPageChanged: (index, reason) {
          log('homebanner onchange $index');

          log('homebanner change on playing $_currentIndex and pause');
          _videoControllers[_currentIndex].removeListener(() {});
          _videoControllers[_currentIndex].pause();

          log('homebanner change to $index');
          setState(() {
            _currentIndex = index;
          });

          if (_videoControllers[index].value.isInitialized) {
            _videoControllers[index].play();
            _videoControllers[index].addListener(() {
              if (_videoControllers[index].value.isCompleted) {
                _videoControllers[index].removeListener(() {});
                setState(() {
                  _currentIndex = index;
                });

                _carouselController.nextPage();
              }
            });

            log('homebanner changed and play $index');
          } else {
            //開始load
            _videoControllers[index].initialize().whenComplete(() {
              _videoControllers[index].play();
              _videoControllers[index].addListener(() {
                if (_videoControllers[index].value.isCompleted) {
                  _videoControllers[index].removeListener(() {});
                  setState(() {
                    _currentIndex = index;
                  });

                  _carouselController.nextPage();
                }
              });

              log('homebanner init changed and play $index');
            });
          }
        },
      ),
    );
  }
}

class DesignervideoCarousel extends StatefulWidget {
  final List<DesignerVideo> designervideos;

  const DesignervideoCarousel({
    super.key,
    required this.designervideos,
  });

  @override
  State<DesignervideoCarousel> createState() => _DesignervideoCarouselState();
}

class _DesignervideoCarouselState extends State<DesignervideoCarousel> {
  final CarouselController _carouselController = CarouselController();
  final List<VideoPlayerController> _videoControllers = [];
  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (DesignerVideo designervideo in widget.designervideos) {
      VideoPlayerController videoplayercontroller =
          VideoPlayerController.networkUrl(Uri.parse(designervideo.videourl))
            ..setLooping(false)
            ..setVolume(0.0);
      _videoControllers.add(videoplayercontroller);
    }

    _videoControllers[0].initialize().whenComplete(() {
      _videoControllers[0].play();
      _videoControllers[0].addListener(() {
        if (_videoControllers[0].value.isCompleted) {
          _videoControllers[0].removeListener(() {});
          _carouselController.nextPage();
        }
      });
    });
  }

  @override
  void dispose() {
    for (VideoPlayerController controller in _videoControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.designervideos.length,
      itemBuilder: (BuildContext context, int index, int realIndex) => InkWell(
        onTap: () {
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
              .getbrandbyid(widget.designervideos[index].brandid, null)
              .then((value) {
            var data = json.decode(value.toString());
            if (data["statusCode"] == 200) {
              overlayEntry.remove();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homebrand(
                    brand: Brand.fromMap(data["data"]),
                  ),
                ),
              );
            } else {
              overlayEntry.remove();
            }
          });
        },
        child: VmPlayer(
          videocontroller: _videoControllers[index],
          iscontrol: false,
        ),
      ),
      options: CarouselOptions(
        viewportFraction: 1,
        aspectRatio: 16 / 9,
        onPageChanged: (index, reason) {
          _videoControllers[_currentIndex].removeListener(() {});
          _videoControllers[_currentIndex].pause();

          setState(() {
            _currentIndex = index;
          });

          if (_videoControllers[index].value.isInitialized) {
            _videoControllers[index].play();
            _videoControllers[index].addListener(() {
              if (_videoControllers[index].value.isCompleted) {
                _videoControllers[index].removeListener(() {});
                setState(() {
                  _currentIndex = index;
                });

                _carouselController.nextPage();
              }
            });
          } else {
            _videoControllers[index].initialize().whenComplete(() {
              _videoControllers[index].play();
              _videoControllers[index].addListener(() {
                if (_videoControllers[index].value.isCompleted) {
                  _videoControllers[index].removeListener(() {});
                  setState(() {
                    _currentIndex = index;
                  });

                  _carouselController.nextPage();
                }
              });
            });
          }
        },
      ),
    );
  }
}

class CollectionvideoCarousel extends StatefulWidget {
  final List<Collection> collections;

  const CollectionvideoCarousel({
    super.key,
    required this.collections,
  });

  @override
  State<CollectionvideoCarousel> createState() =>
      _CollectionvideoCarouselState();
}

class _CollectionvideoCarouselState extends State<CollectionvideoCarousel> {
  final CarouselController _carouselController = CarouselController();
  final List<VideoPlayerController> _videoControllers = [];
  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (Collection video in widget.collections) {
      VideoPlayerController videoplayercontroller =
          VideoPlayerController.networkUrl(Uri.parse(video.videourl!))
            ..setLooping(false)
            ..setVolume(0.0);
      _videoControllers.add(videoplayercontroller);
    }

    _videoControllers[0].initialize().whenComplete(() {
      _videoControllers[0].play();
      _videoControllers[0].addListener(() {
        if (_videoControllers[0].value.isCompleted) {
          _videoControllers[0].removeListener(() {});
          _carouselController.nextPage();
        }
      });
    });
  }

  @override
  void dispose() {
    for (VideoPlayerController controller in _videoControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: widget.collections.length,
      itemBuilder: (BuildContext context, int index, int realIndex) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Collectiondetail(
                collection: widget.collections[index],
              ),
            ),
          );
        },
        child: VmPlayer(
          videocontroller: _videoControllers[index],
          iscontrol: false,
        ),
      ),
      options: CarouselOptions(
        viewportFraction: 1,
        aspectRatio: 16 / 9,
        onPageChanged: (index, reason) {
          _videoControllers[_currentIndex].removeListener(() {});
          _videoControllers[_currentIndex].pause();

          setState(() {
            _currentIndex = index;
          });

          if (_videoControllers[index].value.isInitialized) {
            _videoControllers[index].play();
            _videoControllers[index].addListener(() {
              if (_videoControllers[index].value.isCompleted) {
                _videoControllers[index].removeListener(() {});
                setState(() {
                  _currentIndex = index;
                });

                _carouselController.nextPage();
              }
            });
          } else {
            _videoControllers[index].initialize().whenComplete(() {
              _videoControllers[index].play();
              _videoControllers[index].addListener(() {
                if (_videoControllers[index].value.isCompleted) {
                  _videoControllers[index].removeListener(() {});
                  setState(() {
                    _currentIndex = index;
                  });

                  _carouselController.nextPage();
                }
              });
            });
          }
        },
      ),
    );
  }
}
