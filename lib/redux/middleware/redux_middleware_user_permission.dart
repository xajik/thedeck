/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'dart:io';

import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/redux/middleware/redux_middleware_routing.dart';

import '../../di/app_dependency.dart';
import '../../dto/key_value_entries.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareUserPermissionLocalNetwork() {
  return (store, dependency) async {
    final log = dependency.logger;
    log.i('[iOS] Request client WIFI address to emulate permission dialog');
    await dependency.networkInfo.getWifiIP();
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareVerifyUserPermissionLocalNetwork() {
  return (store, dependency) async {
    if (!Platform.isIOS) {
      return;
    }
    final log = dependency.logger;
    final dao = dependency.dao.keyValueDao;
    final key = KeyValueKeys.iOSShowAllowLocalNetworkPermission.name;
    final entity = dao.getEntity(key);
    if (entity == null) {
      log.i('[iOS] Request User to provide permission to access local network');
      SingleKeyValue<bool> singleValue = SingleKeyValue<bool>(key, true);
      final newEntity = singleValue.toEntity();
      Future.delayed(const Duration(milliseconds: 1250), () async {
        dao.save(newEntity);
        store.dispatch(middlewareRouteiOSAllowNetworkPermission());
      });
    } else {
      log.i(
          '[iOS] User has already requested to give permission to access local network');
    }
  };
}
