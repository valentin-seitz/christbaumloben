import 'package:christbaumloben/app/app.bottomsheets.dart';
import 'package:christbaumloben/app/app.dialogs.dart';
import 'package:christbaumloben/app/app.locator.dart';
import 'package:christbaumloben/ui/common/app_strings.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  List<XFile> _images = [];

  List<String> get imagesPaths => _images.map((e) => e.path).toList();
  bool get hasImages => _images.isNotEmpty;
  final PageController carouselController = PageController(
    viewportFraction: .85,
    initialPage: 0,
  );
  int currentCarouselPage = 0;
  bool carouselPageHasChanged = false;

  void loben() {
    carouselController.animateToPage(currentCarouselPage + 10,
        duration: Duration(seconds: 4), curve: Curves.decelerate);
  }

  void selectFolder() async {
    const XTypeGroup jpgsTypeGroup = XTypeGroup(
      label: 'JPEGs',
      extensions: <String>['jpg', 'jpeg'],
    );
    const XTypeGroup pngTypeGroup = XTypeGroup(
      label: 'PNGs',
      extensions: <String>['png'],
    );
    final List<XFile> files = await openFiles(acceptedTypeGroups: <XTypeGroup>[
      jpgsTypeGroup,
      pngTypeGroup,
    ]);
    if (files.length > 0) {
      _images = files;
    }
    rebuildUi();
  }

  void onPageChanged(int value) {
    carouselPageHasChanged = true;
    currentCarouselPage = value;
    rebuildUi();
  }
}
