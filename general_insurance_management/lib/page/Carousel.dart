import 'dart:async';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  // Carousel image URLs
  static const List<String> _imageUrls = [
    "https://cdn-icons-png.flaticon.com/128/4246/4246578.png",
    "https://cdn-icons-png.flaticon.com/128/1973/1973044.png",
    "https://cdn-icons-png.flaticon.com/128/2769/2769474.png",
    "https://cdn-icons-png.flaticon.com/128/4599/4599244.png",
    "https://cdn-icons-png.flaticon.com/128/3555/3555505.png"
  ];

  // Corresponding routes for each image
  static const List<String> _imageRoutes = [
    '/viewfirepolicy',
    '/viewfirebill',
    '/viewfiremoneyreceipt',
    '/viewmarinepolicy',
    '/viewmarinebill',
  ];

  // Carousel colors for each image background
  static const List<Color> _colors = [
    Colors.redAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _carouselIndex = (_carouselIndex + 1) % _imageUrls.length;
      });
      _pageController.animateToPage(
        _carouselIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget buildCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _carouselIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, _imageRoutes[index]);
              },
              child: Container(
                color: _colors[index % _colors.length],
                child: Center(
                  child: Image.network(
                    _imageUrls[index],
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCarousel();
  }
}



