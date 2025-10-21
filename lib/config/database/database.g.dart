// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ApiCallTable extends ApiCall with TableInfo<$ApiCallTable, ApiCallData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiCallTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headersMeta = const VerificationMeta(
    'headers',
  );
  @override
  late final GeneratedColumn<String> headers = GeneratedColumn<String>(
    'headers',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isProcessingMeta = const VerificationMeta(
    'isProcessing',
  );
  @override
  late final GeneratedColumn<bool> isProcessing = GeneratedColumn<bool>(
    'is_procesing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_procesing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    url,
    method,
    headers,
    body,
    timestamp,
    retryCount,
    isProcessing,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_call';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApiCallData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('headers')) {
      context.handle(
        _headersMeta,
        headers.isAcceptableOrUnknown(data['headers']!, _headersMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('is_procesing')) {
      context.handle(
        _isProcessingMeta,
        isProcessing.isAcceptableOrUnknown(
          data['is_procesing']!,
          _isProcessingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApiCallData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiCallData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      headers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headers'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      isProcessing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_procesing'],
      )!,
    );
  }

  @override
  $ApiCallTable createAlias(String alias) {
    return $ApiCallTable(attachedDatabase, alias);
  }
}

class ApiCallData extends DataClass implements Insertable<ApiCallData> {
  final int id;
  final String url;
  final String method;
  final String? headers;
  final String? body;
  final int timestamp;
  final int retryCount;
  final bool isProcessing;
  const ApiCallData({
    required this.id,
    required this.url,
    required this.method,
    this.headers,
    this.body,
    required this.timestamp,
    required this.retryCount,
    required this.isProcessing,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || headers != null) {
      map['headers'] = Variable<String>(headers);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['timestamp'] = Variable<int>(timestamp);
    map['retry_count'] = Variable<int>(retryCount);
    map['is_procesing'] = Variable<bool>(isProcessing);
    return map;
  }

  ApiCallCompanion toCompanion(bool nullToAbsent) {
    return ApiCallCompanion(
      id: Value(id),
      url: Value(url),
      method: Value(method),
      headers: headers == null && nullToAbsent
          ? const Value.absent()
          : Value(headers),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      timestamp: Value(timestamp),
      retryCount: Value(retryCount),
      isProcessing: Value(isProcessing),
    );
  }

  factory ApiCallData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiCallData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      method: serializer.fromJson<String>(json['method']),
      headers: serializer.fromJson<String?>(json['headers']),
      body: serializer.fromJson<String?>(json['body']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      isProcessing: serializer.fromJson<bool>(json['isProcessing']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'method': serializer.toJson<String>(method),
      'headers': serializer.toJson<String?>(headers),
      'body': serializer.toJson<String?>(body),
      'timestamp': serializer.toJson<int>(timestamp),
      'retryCount': serializer.toJson<int>(retryCount),
      'isProcessing': serializer.toJson<bool>(isProcessing),
    };
  }

  ApiCallData copyWith({
    int? id,
    String? url,
    String? method,
    Value<String?> headers = const Value.absent(),
    Value<String?> body = const Value.absent(),
    int? timestamp,
    int? retryCount,
    bool? isProcessing,
  }) => ApiCallData(
    id: id ?? this.id,
    url: url ?? this.url,
    method: method ?? this.method,
    headers: headers.present ? headers.value : this.headers,
    body: body.present ? body.value : this.body,
    timestamp: timestamp ?? this.timestamp,
    retryCount: retryCount ?? this.retryCount,
    isProcessing: isProcessing ?? this.isProcessing,
  );
  ApiCallData copyWithCompanion(ApiCallCompanion data) {
    return ApiCallData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      method: data.method.present ? data.method.value : this.method,
      headers: data.headers.present ? data.headers.value : this.headers,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      isProcessing: data.isProcessing.present
          ? data.isProcessing.value
          : this.isProcessing,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiCallData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('headers: $headers, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('retryCount: $retryCount, ')
          ..write('isProcessing: $isProcessing')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    url,
    method,
    headers,
    body,
    timestamp,
    retryCount,
    isProcessing,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiCallData &&
          other.id == this.id &&
          other.url == this.url &&
          other.method == this.method &&
          other.headers == this.headers &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.retryCount == this.retryCount &&
          other.isProcessing == this.isProcessing);
}

class ApiCallCompanion extends UpdateCompanion<ApiCallData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> method;
  final Value<String?> headers;
  final Value<String?> body;
  final Value<int> timestamp;
  final Value<int> retryCount;
  final Value<bool> isProcessing;
  const ApiCallCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.method = const Value.absent(),
    this.headers = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.isProcessing = const Value.absent(),
  });
  ApiCallCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String method,
    this.headers = const Value.absent(),
    this.body = const Value.absent(),
    required int timestamp,
    this.retryCount = const Value.absent(),
    this.isProcessing = const Value.absent(),
  }) : url = Value(url),
       method = Value(method),
       timestamp = Value(timestamp);
  static Insertable<ApiCallData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? method,
    Expression<String>? headers,
    Expression<String>? body,
    Expression<int>? timestamp,
    Expression<int>? retryCount,
    Expression<bool>? isProcessing,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (method != null) 'method': method,
      if (headers != null) 'headers': headers,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (retryCount != null) 'retry_count': retryCount,
      if (isProcessing != null) 'is_procesing': isProcessing,
    });
  }

  ApiCallCompanion copyWith({
    Value<int>? id,
    Value<String>? url,
    Value<String>? method,
    Value<String?>? headers,
    Value<String?>? body,
    Value<int>? timestamp,
    Value<int>? retryCount,
    Value<bool>? isProcessing,
  }) {
    return ApiCallCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (headers.present) {
      map['headers'] = Variable<String>(headers.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (isProcessing.present) {
      map['is_procesing'] = Variable<bool>(isProcessing.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiCallCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('headers: $headers, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('retryCount: $retryCount, ')
          ..write('isProcessing: $isProcessing')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ApiCallTable apiCall = $ApiCallTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [apiCall];
}

typedef $$ApiCallTableCreateCompanionBuilder =
    ApiCallCompanion Function({
      Value<int> id,
      required String url,
      required String method,
      Value<String?> headers,
      Value<String?> body,
      required int timestamp,
      Value<int> retryCount,
      Value<bool> isProcessing,
    });
typedef $$ApiCallTableUpdateCompanionBuilder =
    ApiCallCompanion Function({
      Value<int> id,
      Value<String> url,
      Value<String> method,
      Value<String?> headers,
      Value<String?> body,
      Value<int> timestamp,
      Value<int> retryCount,
      Value<bool> isProcessing,
    });

class $$ApiCallTableFilterComposer
    extends Composer<_$AppDatabase, $ApiCallTable> {
  $$ApiCallTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headers => $composableBuilder(
    column: $table.headers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProcessing => $composableBuilder(
    column: $table.isProcessing,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ApiCallTableOrderingComposer
    extends Composer<_$AppDatabase, $ApiCallTable> {
  $$ApiCallTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headers => $composableBuilder(
    column: $table.headers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProcessing => $composableBuilder(
    column: $table.isProcessing,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApiCallTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApiCallTable> {
  $$ApiCallTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get headers =>
      $composableBuilder(column: $table.headers, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isProcessing => $composableBuilder(
    column: $table.isProcessing,
    builder: (column) => column,
  );
}

class $$ApiCallTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApiCallTable,
          ApiCallData,
          $$ApiCallTableFilterComposer,
          $$ApiCallTableOrderingComposer,
          $$ApiCallTableAnnotationComposer,
          $$ApiCallTableCreateCompanionBuilder,
          $$ApiCallTableUpdateCompanionBuilder,
          (
            ApiCallData,
            BaseReferences<_$AppDatabase, $ApiCallTable, ApiCallData>,
          ),
          ApiCallData,
          PrefetchHooks Function()
        > {
  $$ApiCallTableTableManager(_$AppDatabase db, $ApiCallTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiCallTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiCallTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiCallTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> headers = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<bool> isProcessing = const Value.absent(),
              }) => ApiCallCompanion(
                id: id,
                url: url,
                method: method,
                headers: headers,
                body: body,
                timestamp: timestamp,
                retryCount: retryCount,
                isProcessing: isProcessing,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String url,
                required String method,
                Value<String?> headers = const Value.absent(),
                Value<String?> body = const Value.absent(),
                required int timestamp,
                Value<int> retryCount = const Value.absent(),
                Value<bool> isProcessing = const Value.absent(),
              }) => ApiCallCompanion.insert(
                id: id,
                url: url,
                method: method,
                headers: headers,
                body: body,
                timestamp: timestamp,
                retryCount: retryCount,
                isProcessing: isProcessing,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ApiCallTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApiCallTable,
      ApiCallData,
      $$ApiCallTableFilterComposer,
      $$ApiCallTableOrderingComposer,
      $$ApiCallTableAnnotationComposer,
      $$ApiCallTableCreateCompanionBuilder,
      $$ApiCallTableUpdateCompanionBuilder,
      (ApiCallData, BaseReferences<_$AppDatabase, $ApiCallTable, ApiCallData>),
      ApiCallData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ApiCallTableTableManager get apiCall =>
      $$ApiCallTableTableManager(_db, _db.apiCall);
}
