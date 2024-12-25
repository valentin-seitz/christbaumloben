import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:christbaumloben/ui/common/ui_helpers.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'TANNENBAUM LOBEN',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                          visible: viewModel.showLoading,
                          child: Text('loading ...',
                              style: TextStyle(fontSize: 20))),
                      horizontalSpaceSmall,
                      Visibility(
                        visible: viewModel.showLoading,
                        child: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 6,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: viewModel.showFilesSelection,
                        child: MaterialButton(
                          color: Colors.grey.shade700,
                          onPressed: viewModel.addFiles,
                          child: const Text(
                            'Add files',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: viewModel.showNextPage,
                        child: MaterialButton(
                          color: Colors.grey.shade700,
                          onPressed: viewModel.nextPage,
                          child: Text(
                            '...mal sehen was wird',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Visibility(
                visible: viewModel.persons.isNotEmpty,
                child: Card(
                  child: ListView(
                    children: viewModel.persons
                        .map((person) => Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Von ",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      person.name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      " habe ich ${person.availableImages.length.toString()} Bilder gefunden",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Visibility(
                                        visible: person.isJoker,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(": JOKER (hier trinken alle)")
                                          ],
                                        )),
                                  ]),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
