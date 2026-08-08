import 'package:flutter/widgets.dart';

import 'bci_data_repository.dart';

/// Makes a single [BciDataRepository] instance available anywhere below it in the
/// widget tree, without needing any third-party state management package.
class AppScope extends InheritedNotifier<BciDataRepository> {
  const AppScope({
    super.key,
    required BciDataRepository dataStore,
    required super.child,
  }) : super(notifier: dataStore);

  static BciDataRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in the widget tree');
    return scope!.notifier!;
  }
}
