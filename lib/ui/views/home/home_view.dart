import 'dart:math';

import 'package:animated_flip_widget/animated_flip_widget.dart';
import 'package:animated_flip_widget/animated_flip_widget/flip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.textWerTrinkt,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Flexible(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child: Visibility(
                      visible: true,
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
                            value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

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
                          child: AnimatedFlipWidget(
                            front: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(200.0),
                              child: Transform.rotate(
                                angle:
                                    Random(index).nextDouble() * pi - 0.5 * pi,
                                child: Image.asset(index % 2 == 0
                                    ? "assets/platte.png"
                                    : "assets/vino.png"),
                              ),
                            )),
                            back: Center(
                                child: Image.file(
                                    File(viewModel.chosenImagePath),
                                    fit: BoxFit.contain)),
                            controller: index == viewModel.nextCarouselPage
                                ? viewModel.flipController
                                : FlipController(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        padding: EdgeInsets.all(30),
                        color: const Color.fromARGB(255, 30, 102, 34),
                        onPressed: () => viewModel.loben(),
                        child: Text(
                          "loben",
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        )),
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
