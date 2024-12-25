import 'package:christbaumloben/services/person_service.dart';
import 'package:file_selector/file_selector.dart';
import 'package:stacked/stacked.dart';
import 'package:christbaumloben/app/app.locator.dart';
import 'package:christbaumloben/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends StreamViewModel<List<Person>> {
  final _navigationService = locator<NavigationService>();
  final _personService = locator<PersonService>();

  List<Person> get persons => data ?? [];
  bool showFilesSelection = false;
  bool showLoading = true;
  bool showNextPage = false;

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    //rebuildUi();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      showFilesSelection = true;
      showLoading = false;
      rebuildUi();
    });

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic
  }

  void addFiles() async {
    const XTypeGroup jpgsTypeGroup = XTypeGroup(
      label: 'JPEGs',
      extensions: <String>['jpg', 'jpeg'],
    );
    final List<XFile> files =
        await openFiles(acceptedTypeGroups: <XTypeGroup>[jpgsTypeGroup]);
    showFilesSelection = false;
    showNextPage = true;
    rebuildUi();
    _personService.addPersons(files);
  }

  void nextPage() {
    _navigationService.replaceWithHomeView();
  }

  @override
  Stream<List<Person>> get stream => _personService.persons;
}
