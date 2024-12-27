import 'dart:async';
import 'dart:math';

import 'package:animated_flip_widget/animated_flip_widget.dart';
import 'package:christbaumloben/app/app.bottomsheets.dart';
import 'package:christbaumloben/app/app.dialogs.dart';
import 'package:christbaumloben/app/app.locator.dart';
import 'package:christbaumloben/services/person_service.dart';
import 'package:christbaumloben/ui/common/app_strings.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends StreamViewModel<List<Person>> {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _personService = locator<PersonService>();

  List<String> get names => data?.map((person) => person.name).toList() ?? [];
  List<Person> get persons => data ?? [];

  FlipController flipController = FlipController();
  final PageController carouselController = PageController(
    viewportFraction: .85,
    initialPage: 0,
  );
  int currentCarouselPage = 0;
  int nextCarouselPage = 0;
  bool carouselPageHasChanged = false;
  bool lobenInProgress = false;
  String chosenImagePath = "";
  Person chosenPerson = Person(name: "Dummy", availableImages: []);

  List<String> esTrinkt = [];
  String get textWerTrinkt => chosenPerson.isJoker
      ? "JOKER! Alle trinken!"
      : "Es trinkt: ${esTrinkt.join(" & ")}";

  void loben() async {
    if (lobenInProgress) return;
    lobenInProgress = true;
    // Drehen Rad
    nextCarouselPage = (currentCarouselPage + Random().nextInt(25) + 10);
    flipController = FlipController();
    // Person aussuchen
    var newChosenPerson = persons[nextCarouselPage % names.length];
    // zufälliges Bild von der Person
    chosenImagePath = newChosenPerson.availableImages[
        Random().nextInt(newChosenPerson.availableImages.length)];
    await carouselController.animateToPage(nextCarouselPage,
        duration: Duration(seconds: 4), curve: Curves.decelerate);
    await Future.delayed(Duration(seconds: 1));
    // Bild aufdecken
    flipController.flip();
    await Future.delayed(Duration(milliseconds: 400));

    // Wer muss trinken?
    chosenPerson = newChosenPerson;
    esTrinkt = _personService.getPersonsInImagePath(chosenImagePath);

    rebuildUi();
    lobenInProgress = false;
  }

  void onPageChanged(int value) {
    carouselPageHasChanged = true;
    currentCarouselPage = value;
    rebuildUi();
  }

  @override
  Stream<List<Person>> get stream => _personService.persons;
}
