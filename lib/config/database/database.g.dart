// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RequestApiRowTable extends RequestApiRow
    with TableInfo<$RequestApiRowTable, RequestApiRowData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequestApiRowTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _isMultipartMeta = const VerificationMeta(
    'isMultipart',
  );
  @override
  late final GeneratedColumn<bool> isMultipart = GeneratedColumn<bool>(
    'is_multipart',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_multipart" IN (0, 1))',
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
    isMultipart,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'request_api_row';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequestApiRowData> instance, {
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
    if (data.containsKey('is_multipart')) {
      context.handle(
        _isMultipartMeta,
        isMultipart.isAcceptableOrUnknown(
          data['is_multipart']!,
          _isMultipartMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequestApiRowData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestApiRowData(
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
      isMultipart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_multipart'],
      )!,
    );
  }

  @override
  $RequestApiRowTable createAlias(String alias) {
    return $RequestApiRowTable(attachedDatabase, alias);
  }
}

class RequestApiRowData extends DataClass
    implements Insertable<RequestApiRowData> {
  final int id;
  final String url;
  final String method;
  final String? headers;
  final String? body;
  final int timestamp;
  final int retryCount;
  final bool isProcessing;
  final bool isMultipart;
  const RequestApiRowData({
    required this.id,
    required this.url,
    required this.method,
    this.headers,
    this.body,
    required this.timestamp,
    required this.retryCount,
    required this.isProcessing,
    required this.isMultipart,
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
    map['is_multipart'] = Variable<bool>(isMultipart);
    return map;
  }

  RequestApiRowCompanion toCompanion(bool nullToAbsent) {
    return RequestApiRowCompanion(
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
      isMultipart: Value(isMultipart),
    );
  }

  factory RequestApiRowData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestApiRowData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      method: serializer.fromJson<String>(json['method']),
      headers: serializer.fromJson<String?>(json['headers']),
      body: serializer.fromJson<String?>(json['body']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      isProcessing: serializer.fromJson<bool>(json['isProcessing']),
      isMultipart: serializer.fromJson<bool>(json['isMultipart']),
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
      'isMultipart': serializer.toJson<bool>(isMultipart),
    };
  }

  RequestApiRowData copyWith({
    int? id,
    String? url,
    String? method,
    Value<String?> headers = const Value.absent(),
    Value<String?> body = const Value.absent(),
    int? timestamp,
    int? retryCount,
    bool? isProcessing,
    bool? isMultipart,
  }) => RequestApiRowData(
    id: id ?? this.id,
    url: url ?? this.url,
    method: method ?? this.method,
    headers: headers.present ? headers.value : this.headers,
    body: body.present ? body.value : this.body,
    timestamp: timestamp ?? this.timestamp,
    retryCount: retryCount ?? this.retryCount,
    isProcessing: isProcessing ?? this.isProcessing,
    isMultipart: isMultipart ?? this.isMultipart,
  );
  RequestApiRowData copyWithCompanion(RequestApiRowCompanion data) {
    return RequestApiRowData(
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
      isMultipart: data.isMultipart.present
          ? data.isMultipart.value
          : this.isMultipart,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestApiRowData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('headers: $headers, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('retryCount: $retryCount, ')
          ..write('isProcessing: $isProcessing, ')
          ..write('isMultipart: $isMultipart')
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
    isMultipart,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestApiRowData &&
          other.id == this.id &&
          other.url == this.url &&
          other.method == this.method &&
          other.headers == this.headers &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.retryCount == this.retryCount &&
          other.isProcessing == this.isProcessing &&
          other.isMultipart == this.isMultipart);
}

class RequestApiRowCompanion extends UpdateCompanion<RequestApiRowData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> method;
  final Value<String?> headers;
  final Value<String?> body;
  final Value<int> timestamp;
  final Value<int> retryCount;
  final Value<bool> isProcessing;
  final Value<bool> isMultipart;
  const RequestApiRowCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.method = const Value.absent(),
    this.headers = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.isProcessing = const Value.absent(),
    this.isMultipart = const Value.absent(),
  });
  RequestApiRowCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String method,
    this.headers = const Value.absent(),
    this.body = const Value.absent(),
    required int timestamp,
    this.retryCount = const Value.absent(),
    this.isProcessing = const Value.absent(),
    this.isMultipart = const Value.absent(),
  }) : url = Value(url),
       method = Value(method),
       timestamp = Value(timestamp);
  static Insertable<RequestApiRowData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? method,
    Expression<String>? headers,
    Expression<String>? body,
    Expression<int>? timestamp,
    Expression<int>? retryCount,
    Expression<bool>? isProcessing,
    Expression<bool>? isMultipart,
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
      if (isMultipart != null) 'is_multipart': isMultipart,
    });
  }

  RequestApiRowCompanion copyWith({
    Value<int>? id,
    Value<String>? url,
    Value<String>? method,
    Value<String?>? headers,
    Value<String?>? body,
    Value<int>? timestamp,
    Value<int>? retryCount,
    Value<bool>? isProcessing,
    Value<bool>? isMultipart,
  }) {
    return RequestApiRowCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      isProcessing: isProcessing ?? this.isProcessing,
      isMultipart: isMultipart ?? this.isMultipart,
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
    if (isMultipart.present) {
      map['is_multipart'] = Variable<bool>(isMultipart.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestApiRowCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('headers: $headers, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('retryCount: $retryCount, ')
          ..write('isProcessing: $isProcessing, ')
          ..write('isMultipart: $isMultipart')
          ..write(')'))
        .toString();
  }
}

class $RequestFileRowTable extends RequestFileRow
    with TableInfo<$RequestFileRowTable, RequestFileRowData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequestFileRowTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _requestIdMeta = const VerificationMeta(
    'requestId',
  );
  @override
  late final GeneratedColumn<int> requestId = GeneratedColumn<int>(
    'request_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES request_api_row (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldNameMeta = const VerificationMeta(
    'fieldName',
  );
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    requestId,
    filePath,
    fieldName,
    fileName,
    mimeType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'request_file_row';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequestFileRowData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('request_id')) {
      context.handle(
        _requestIdMeta,
        requestId.isAcceptableOrUnknown(data['request_id']!, _requestIdMeta),
      );
    } else if (isInserting) {
      context.missing(_requestIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(
        _fieldNameMeta,
        fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequestFileRowData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestFileRowData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      requestId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}request_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
    );
  }

  @override
  $RequestFileRowTable createAlias(String alias) {
    return $RequestFileRowTable(attachedDatabase, alias);
  }
}

class RequestFileRowData extends DataClass
    implements Insertable<RequestFileRowData> {
  final int id;
  final int requestId;
  final String filePath;
  final String fieldName;
  final String fileName;
  final String mimeType;
  const RequestFileRowData({
    required this.id,
    required this.requestId,
    required this.filePath,
    required this.fieldName,
    required this.fileName,
    required this.mimeType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['request_id'] = Variable<int>(requestId);
    map['file_path'] = Variable<String>(filePath);
    map['field_name'] = Variable<String>(fieldName);
    map['file_name'] = Variable<String>(fileName);
    map['mime_type'] = Variable<String>(mimeType);
    return map;
  }

  RequestFileRowCompanion toCompanion(bool nullToAbsent) {
    return RequestFileRowCompanion(
      id: Value(id),
      requestId: Value(requestId),
      filePath: Value(filePath),
      fieldName: Value(fieldName),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
    );
  }

  factory RequestFileRowData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestFileRowData(
      id: serializer.fromJson<int>(json['id']),
      requestId: serializer.fromJson<int>(json['requestId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      fileName: serializer.fromJson<String>(json['fileName']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'requestId': serializer.toJson<int>(requestId),
      'filePath': serializer.toJson<String>(filePath),
      'fieldName': serializer.toJson<String>(fieldName),
      'fileName': serializer.toJson<String>(fileName),
      'mimeType': serializer.toJson<String>(mimeType),
    };
  }

  RequestFileRowData copyWith({
    int? id,
    int? requestId,
    String? filePath,
    String? fieldName,
    String? fileName,
    String? mimeType,
  }) => RequestFileRowData(
    id: id ?? this.id,
    requestId: requestId ?? this.requestId,
    filePath: filePath ?? this.filePath,
    fieldName: fieldName ?? this.fieldName,
    fileName: fileName ?? this.fileName,
    mimeType: mimeType ?? this.mimeType,
  );
  RequestFileRowData copyWithCompanion(RequestFileRowCompanion data) {
    return RequestFileRowData(
      id: data.id.present ? data.id.value : this.id,
      requestId: data.requestId.present ? data.requestId.value : this.requestId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestFileRowData(')
          ..write('id: $id, ')
          ..write('requestId: $requestId, ')
          ..write('filePath: $filePath, ')
          ..write('fieldName: $fieldName, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, requestId, filePath, fieldName, fileName, mimeType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestFileRowData &&
          other.id == this.id &&
          other.requestId == this.requestId &&
          other.filePath == this.filePath &&
          other.fieldName == this.fieldName &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType);
}

class RequestFileRowCompanion extends UpdateCompanion<RequestFileRowData> {
  final Value<int> id;
  final Value<int> requestId;
  final Value<String> filePath;
  final Value<String> fieldName;
  final Value<String> fileName;
  final Value<String> mimeType;
  const RequestFileRowCompanion({
    this.id = const Value.absent(),
    this.requestId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
  });
  RequestFileRowCompanion.insert({
    this.id = const Value.absent(),
    required int requestId,
    required String filePath,
    required String fieldName,
    required String fileName,
    required String mimeType,
  }) : requestId = Value(requestId),
       filePath = Value(filePath),
       fieldName = Value(fieldName),
       fileName = Value(fileName),
       mimeType = Value(mimeType);
  static Insertable<RequestFileRowData> custom({
    Expression<int>? id,
    Expression<int>? requestId,
    Expression<String>? filePath,
    Expression<String>? fieldName,
    Expression<String>? fileName,
    Expression<String>? mimeType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (requestId != null) 'request_id': requestId,
      if (filePath != null) 'file_path': filePath,
      if (fieldName != null) 'field_name': fieldName,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
    });
  }

  RequestFileRowCompanion copyWith({
    Value<int>? id,
    Value<int>? requestId,
    Value<String>? filePath,
    Value<String>? fieldName,
    Value<String>? fileName,
    Value<String>? mimeType,
  }) {
    return RequestFileRowCompanion(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      filePath: filePath ?? this.filePath,
      fieldName: fieldName ?? this.fieldName,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (requestId.present) {
      map['request_id'] = Variable<int>(requestId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestFileRowCompanion(')
          ..write('id: $id, ')
          ..write('requestId: $requestId, ')
          ..write('filePath: $filePath, ')
          ..write('fieldName: $fieldName, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RequestApiRowTable requestApiRow = $RequestApiRowTable(this);
  late final $RequestFileRowTable requestFileRow = $RequestFileRowTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    requestApiRow,
    requestFileRow,
  ];
}

typedef $$RequestApiRowTableCreateCompanionBuilder =
    RequestApiRowCompanion Function({
      Value<int> id,
      required String url,
      required String method,
      Value<String?> headers,
      Value<String?> body,
      required int timestamp,
      Value<int> retryCount,
      Value<bool> isProcessing,
      Value<bool> isMultipart,
    });
typedef $$RequestApiRowTableUpdateCompanionBuilder =
    RequestApiRowCompanion Function({
      Value<int> id,
      Value<String> url,
      Value<String> method,
      Value<String?> headers,
      Value<String?> body,
      Value<int> timestamp,
      Value<int> retryCount,
      Value<bool> isProcessing,
      Value<bool> isMultipart,
    });

final class $$RequestApiRowTableReferences
    extends
        BaseReferences<_$AppDatabase, $RequestApiRowTable, RequestApiRowData> {
  $$RequestApiRowTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$RequestFileRowTable, List<RequestFileRowData>>
  _requestFileRowRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.requestFileRow,
    aliasName: $_aliasNameGenerator(
      db.requestApiRow.id,
      db.requestFileRow.requestId,
    ),
  );

  $$RequestFileRowTableProcessedTableManager get requestFileRowRefs {
    final manager = $$RequestFileRowTableTableManager(
      $_db,
      $_db.requestFileRow,
    ).filter((f) => f.requestId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_requestFileRowRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RequestApiRowTableFilterComposer
    extends Composer<_$AppDatabase, $RequestApiRowTable> {
  $$RequestApiRowTableFilterComposer({
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

  ColumnFilters<bool> get isMultipart => $composableBuilder(
    column: $table.isMultipart,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> requestFileRowRefs(
    Expression<bool> Function($$RequestFileRowTableFilterComposer f) f,
  ) {
    final $$RequestFileRowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestFileRow,
      getReferencedColumn: (t) => t.requestId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestFileRowTableFilterComposer(
            $db: $db,
            $table: $db.requestFileRow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RequestApiRowTableOrderingComposer
    extends Composer<_$AppDatabase, $RequestApiRowTable> {
  $$RequestApiRowTableOrderingComposer({
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

  ColumnOrderings<bool> get isMultipart => $composableBuilder(
    column: $table.isMultipart,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RequestApiRowTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequestApiRowTable> {
  $$RequestApiRowTableAnnotationComposer({
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

  GeneratedColumn<bool> get isMultipart => $composableBuilder(
    column: $table.isMultipart,
    builder: (column) => column,
  );

  Expression<T> requestFileRowRefs<T extends Object>(
    Expression<T> Function($$RequestFileRowTableAnnotationComposer a) f,
  ) {
    final $$RequestFileRowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.requestFileRow,
      getReferencedColumn: (t) => t.requestId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestFileRowTableAnnotationComposer(
            $db: $db,
            $table: $db.requestFileRow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RequestApiRowTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequestApiRowTable,
          RequestApiRowData,
          $$RequestApiRowTableFilterComposer,
          $$RequestApiRowTableOrderingComposer,
          $$RequestApiRowTableAnnotationComposer,
          $$RequestApiRowTableCreateCompanionBuilder,
          $$RequestApiRowTableUpdateCompanionBuilder,
          (RequestApiRowData, $$RequestApiRowTableReferences),
          RequestApiRowData,
          PrefetchHooks Function({bool requestFileRowRefs})
        > {
  $$RequestApiRowTableTableManager(_$AppDatabase db, $RequestApiRowTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequestApiRowTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequestApiRowTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequestApiRowTableAnnotationComposer($db: db, $table: table),
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
                Value<bool> isMultipart = const Value.absent(),
              }) => RequestApiRowCompanion(
                id: id,
                url: url,
                method: method,
                headers: headers,
                body: body,
                timestamp: timestamp,
                retryCount: retryCount,
                isProcessing: isProcessing,
                isMultipart: isMultipart,
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
                Value<bool> isMultipart = const Value.absent(),
              }) => RequestApiRowCompanion.insert(
                id: id,
                url: url,
                method: method,
                headers: headers,
                body: body,
                timestamp: timestamp,
                retryCount: retryCount,
                isProcessing: isProcessing,
                isMultipart: isMultipart,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RequestApiRowTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({requestFileRowRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (requestFileRowRefs) db.requestFileRow,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (requestFileRowRefs)
                    await $_getPrefetchedData<
                      RequestApiRowData,
                      $RequestApiRowTable,
                      RequestFileRowData
                    >(
                      currentTable: table,
                      referencedTable: $$RequestApiRowTableReferences
                          ._requestFileRowRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RequestApiRowTableReferences(
                            db,
                            table,
                            p0,
                          ).requestFileRowRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.requestId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RequestApiRowTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequestApiRowTable,
      RequestApiRowData,
      $$RequestApiRowTableFilterComposer,
      $$RequestApiRowTableOrderingComposer,
      $$RequestApiRowTableAnnotationComposer,
      $$RequestApiRowTableCreateCompanionBuilder,
      $$RequestApiRowTableUpdateCompanionBuilder,
      (RequestApiRowData, $$RequestApiRowTableReferences),
      RequestApiRowData,
      PrefetchHooks Function({bool requestFileRowRefs})
    >;
typedef $$RequestFileRowTableCreateCompanionBuilder =
    RequestFileRowCompanion Function({
      Value<int> id,
      required int requestId,
      required String filePath,
      required String fieldName,
      required String fileName,
      required String mimeType,
    });
typedef $$RequestFileRowTableUpdateCompanionBuilder =
    RequestFileRowCompanion Function({
      Value<int> id,
      Value<int> requestId,
      Value<String> filePath,
      Value<String> fieldName,
      Value<String> fileName,
      Value<String> mimeType,
    });

final class $$RequestFileRowTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RequestFileRowTable,
          RequestFileRowData
        > {
  $$RequestFileRowTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RequestApiRowTable _requestIdTable(_$AppDatabase db) =>
      db.requestApiRow.createAlias(
        $_aliasNameGenerator(db.requestFileRow.requestId, db.requestApiRow.id),
      );

  $$RequestApiRowTableProcessedTableManager get requestId {
    final $_column = $_itemColumn<int>('request_id')!;

    final manager = $$RequestApiRowTableTableManager(
      $_db,
      $_db.requestApiRow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_requestIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RequestFileRowTableFilterComposer
    extends Composer<_$AppDatabase, $RequestFileRowTable> {
  $$RequestFileRowTableFilterComposer({
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

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  $$RequestApiRowTableFilterComposer get requestId {
    final $$RequestApiRowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requestId,
      referencedTable: $db.requestApiRow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestApiRowTableFilterComposer(
            $db: $db,
            $table: $db.requestApiRow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestFileRowTableOrderingComposer
    extends Composer<_$AppDatabase, $RequestFileRowTable> {
  $$RequestFileRowTableOrderingComposer({
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

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  $$RequestApiRowTableOrderingComposer get requestId {
    final $$RequestApiRowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requestId,
      referencedTable: $db.requestApiRow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestApiRowTableOrderingComposer(
            $db: $db,
            $table: $db.requestApiRow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestFileRowTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequestFileRowTable> {
  $$RequestFileRowTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  $$RequestApiRowTableAnnotationComposer get requestId {
    final $$RequestApiRowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.requestId,
      referencedTable: $db.requestApiRow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RequestApiRowTableAnnotationComposer(
            $db: $db,
            $table: $db.requestApiRow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RequestFileRowTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequestFileRowTable,
          RequestFileRowData,
          $$RequestFileRowTableFilterComposer,
          $$RequestFileRowTableOrderingComposer,
          $$RequestFileRowTableAnnotationComposer,
          $$RequestFileRowTableCreateCompanionBuilder,
          $$RequestFileRowTableUpdateCompanionBuilder,
          (RequestFileRowData, $$RequestFileRowTableReferences),
          RequestFileRowData,
          PrefetchHooks Function({bool requestId})
        > {
  $$RequestFileRowTableTableManager(
    _$AppDatabase db,
    $RequestFileRowTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequestFileRowTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequestFileRowTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequestFileRowTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> requestId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fieldName = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
              }) => RequestFileRowCompanion(
                id: id,
                requestId: requestId,
                filePath: filePath,
                fieldName: fieldName,
                fileName: fileName,
                mimeType: mimeType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int requestId,
                required String filePath,
                required String fieldName,
                required String fileName,
                required String mimeType,
              }) => RequestFileRowCompanion.insert(
                id: id,
                requestId: requestId,
                filePath: filePath,
                fieldName: fieldName,
                fileName: fileName,
                mimeType: mimeType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RequestFileRowTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({requestId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (requestId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.requestId,
                                referencedTable: $$RequestFileRowTableReferences
                                    ._requestIdTable(db),
                                referencedColumn:
                                    $$RequestFileRowTableReferences
                                        ._requestIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RequestFileRowTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequestFileRowTable,
      RequestFileRowData,
      $$RequestFileRowTableFilterComposer,
      $$RequestFileRowTableOrderingComposer,
      $$RequestFileRowTableAnnotationComposer,
      $$RequestFileRowTableCreateCompanionBuilder,
      $$RequestFileRowTableUpdateCompanionBuilder,
      (RequestFileRowData, $$RequestFileRowTableReferences),
      RequestFileRowData,
      PrefetchHooks Function({bool requestId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RequestApiRowTableTableManager get requestApiRow =>
      $$RequestApiRowTableTableManager(_db, _db.requestApiRow);
  $$RequestFileRowTableTableManager get requestFileRow =>
      $$RequestFileRowTableTableManager(_db, _db.requestFileRow);
}
