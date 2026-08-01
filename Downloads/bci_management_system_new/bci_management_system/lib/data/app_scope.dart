import 'package:flutter/widgets.dart';

import 'data_store.dart';

/// Makes a single [DataStore] instance available anywhere below it in the
/// widget tree, without needing any third-party state management package.
class AppScope extends InheritedNotifier<DataStore> {
  const AppScope({
    super.key,
    required DataStore dataStore,
    required super.child,
  }) : super(notifier: dataStore);

  static DataStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in the widget tree');
    return scope!.notifier!;
  }
}
