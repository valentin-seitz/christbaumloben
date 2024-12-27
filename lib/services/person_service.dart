import 'dart:io';
import 'dart:math';

import 'package:file_selector/file_selector.dart';
import 'package:rxdart/rxdart.dart';

class Person {
  final String name;
  final List<String> availableImages;
  bool get isJoker => name == "Amelie";
  Person({required this.name, required this.availableImages});
}

class PersonService {
  final BehaviorSubject<List<Person>> _persons = BehaviorSubject.seeded([]);
  Stream<List<Person>> get persons => _persons.stream;
  Map<String, List<String>> _personsInImage = {};
  List<String> getPersonsInImagePath(path) {
    return _personsInImage[path] ?? [];
  }

  addPersons(List<XFile> files) {
    Set<String> person_names = {};
    for (var image_file in files) {
      var image_file_name = image_file.path.split("/").last.split(".").first;
      var p_names = image_file_name.split("__");
      for (var p_name in p_names) {
        person_names.add(p_name.split("_").first);
      }
    }
    Map<String, List<String>> person_map = {};

    person_names.forEach((name) => person_map[name] = []);
    files.forEach((file) => _personsInImage[file.path] = []);

    for (var image_file in files) {
      var image_file_name = image_file.path.split("/").last.split(".").first;
      var clean_p_names = image_file_name
          .split("__")
          .map((name) => name.split("_").first)
          .toList();
      _personsInImage[image_file.path] = clean_p_names;
      for (var p_name in person_names) {
        if (clean_p_names.contains(p_name)) {
          person_map[p_name]!.add(image_file.path);
        }
      }
    }

    person_map.forEach((name, files) {
      _persons
          .add([..._persons.value, Person(availableImages: files, name: name)]);
    });
  }
}
