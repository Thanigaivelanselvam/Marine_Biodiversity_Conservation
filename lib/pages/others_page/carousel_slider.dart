import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarouselSlider extends StatelessWidget {
  const ImageCarouselSlider({super.key});

  // ✅ List of carousel items (image + title + description)
  final List<Map<String, String>> items = const [
    {
      "image": "assests/images/pexels-onesecondbeforesunset-31996016.jpg",
      "title": "Coral Reef Restoration",
      "desc": "Rebuilding damaged reefs and promoting coral growth to restore marine habitats."
    },
    {
      "image": "assests/images/pexels-raden-eliasar-132128207-10303406.png",
      "title": "Ocean Cleanup Missions",
      "desc": "Removing plastic waste and debris from oceans to protect aquatic life."
    },
    {
      "image": "assests/images/pexels-ron-lach-9037205.png",
      "title": "Marine Life Research",
      "desc": "Studying ocean species and ecosystems to promote sustainable conservation."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: items.length,
        itemBuilder: (context, index, realIndex) {
          final data = items[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.asset(
                    data["image"]!,
                    fit: BoxFit.cover,
                  ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Text content
                  Positioned(
                    bottom: 20,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data["desc"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 250.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          viewportFraction: 0.95,
          initialPage: 0,
        ),
      ),
    );
  }
}
