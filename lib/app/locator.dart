import 'package:dynamic_table_example/dialogueType.dart';
import 'package:dynamic_table_example/mymodel.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DialogService());
    locator.registerFactory(() => MyViewModel());
  // Register other services here if needed
}


void setupDialogUi() {
  final dialogService = locator<DialogService>();

    dialogService.registerCustomDialogBuilders({
    DialogType.fullScreen: (context, sheetRequest, completer) =>
        FullScreenAlertDialog(
          onDialogComplete: (response) => completer(response),
        ),
  });
}