

// database/database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';


class RequestApiRow extends Table {
  IntColumn get id => integer().autoIncrement()();
  // IntColumn get id => integer()();
  TextColumn get url => text()();
  TextColumn get method => text()();
  TextColumn get headers => text().nullable()();
  TextColumn get body => text().nullable()();
  IntColumn get timestamp => integer()();
  IntColumn get retryCount => integer().named('retry_count').withDefault(const Constant(0))();
  BoolColumn get isProcessing => boolean().named('is_procesing').withDefault(const Constant(false))();
  BoolColumn get isMultipart => boolean().withDefault(const Constant(false))();

  // @override
  // Set<Column> get primaryKey => {id};
}

// @DataClassName('RequestFileRow')
class RequestFileRow extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get requestId => integer().references(RequestApiRow, #id)();
  TextColumn get filePath => text()();
  TextColumn get fieldName => text()();
  TextColumn get fileName => text()();
  TextColumn get mimeType => text()();
}

@DriftDatabase(tables: [RequestApiRow , RequestFileRow])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}

final db = AppDatabase();

// @DataClassName('ApiCallEntity')
// class ApiCalls extends Table {
//   TextColumn get id => text()();
//   TextColumn get url => text()();
//   TextColumn get method => text()();
//   TextColumn get headers => text().nullable()();
//   TextColumn get body => text().nullable()();
//   IntColumn get timestamp => integer()();
//   IntColumn get retryCount => integer().withDefault(const Constant(0))();
//   BoolColumn get isProcessing => boolean().withDefault(const Constant(false))();

//   @override
//   Set<Column> get primaryKey => {id};
// }

// @DriftDatabase(tables: [ApiCalls])
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 1;

//   // Create a new API call
//   Future<void> createApiCall(ApiCallEntity apiCall) async {
//     await into(apiCalls).insert(apiCall);
//   }

//   // Get all queued API calls, ordered by timestamp
//   Future<List<ApiCallEntity>> getQueuedCalls() async {
//     return await (select(apiCalls)
//           ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
//         .get();
//   }

//   // Get pending calls (not being processed)
//   Future<List<ApiCallEntity>> getPendingCalls() async {
//     return await (select(apiCalls)
//           ..where((t) => t.isProcessing.equals(false))
//           ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
//         .get();
//   }

//   // Delete an API call by ID
//   Future<void> deleteApiCall(String id) async {
//     await (delete(apiCalls)..where((t) => t.id.equals(id))).go();
//   }

//   // Update retry count
//   Future<void> updateRetryCount(String id, int retryCount) async {
//     await (update(apiCalls)..where((t) => t.id.equals(id)))
//         .write(ApiCallsCompanion(retryCount: Value(retryCount)));
//   }

//   // Mark as processing
//   Future<void> markAsProcessing(String id, bool isProcessing) async {
//     await (update(apiCalls)..where((t) => t.id.equals(id)))
//         .write(ApiCallsCompanion(isProcessing: Value(isProcessing)));
//   }

//   // Clear all API calls
//   Future<void> clearAll() async {
//     await delete(apiCalls).go();
//   }
// }

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return NativeDatabase(file);
//   });
// }