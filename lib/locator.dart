import 'package:get_it/get_it.dart';

import 'data/providers/db/db_interface/user_local_database_interface.dart';
import 'data/providers/db/db_interface/words_local_database_interface.dart';
import 'data/providers/db/sqlflite_db/sqflite_db.dart';
import 'data/providers/storage_secured/storage_secured.dart';
import 'data/providers/storage_secured/storage_secured_interface/storage_secure_interface.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<StorageSecInterface>(() => StorageSecured());
  locator.registerLazySingleton<WordsLocalDatabaseInterface>(
      () => SqfliteDb.instance);
  locator
      .registerLazySingleton<UserLocalDatabaseInterface<Map<String, dynamic>>>(
          () => SqfliteDb.instance);
  // locator.registerLazySingleton<SharedPref>(() => SharedPref());
}
