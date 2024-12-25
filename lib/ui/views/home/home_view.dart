import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:christbaumloben/ui/common/app_colors.dart';
import 'package:christbaumloben/ui/common/ui_helpers.dart';
import 'dart:io';
import 'home_viewmodel.dart';

import 'dart:ui' as ui;

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    List<Widget> renderedImages = viewModel.imagesPaths
        .map((path) => Image.file(File(path), fit: BoxFit.cover))
        .toList();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: viewModel.hasImages,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 2,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: PageView.builder(
                              onPageChanged: viewModel.onPageChanged,
                              controller: viewModel.carouselController,
                              scrollBehavior:
                                  ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                  ui.PointerDeviceKind.touch,
                                  ui.PointerDeviceKind.mouse,
                                },
                              ),
                              itemBuilder: (context, index) => AnimatedBuilder(
                                animation: viewModel.carouselController,
                                builder: (context, child) {
                                  var result = viewModel.carouselPageHasChanged
                                      ? viewModel.carouselController.page!
                                      : viewModel.currentCarouselPage * 1.0;

                                  // The horizontal position of the page between a 1 and 0
                                  var value = result - index;
                                  value =
                                      (1 - (value.abs() * .5)).clamp(0.0, 1.0);
                                  return Center(
                                    child: SizedBox(
                                      height: Curves.easeOut.transform(value) *
                                          MediaQuery.of(context).size.height,
                                      width: Curves.easeOut.transform(value) *
                                          MediaQuery.of(context).size.width,
                                      child: child,
                                    ),
                                  );
                                },
                                child: renderedImages[
                                    index % viewModel.imagesPaths.length],
                              ),
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        padding: EdgeInsets.all(30),
                        color: const Color.fromARGB(255, 30, 102, 34),
                        onPressed: viewModel.loben,
                        child: Text(
                          "LOBEN",
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
