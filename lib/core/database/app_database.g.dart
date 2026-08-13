// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _assignedHalaqaIdsMeta =
      const VerificationMeta('assignedHalaqaIds');
  @override
  late final GeneratedColumn<String> assignedHalaqaIds =
      GeneratedColumn<String>('assigned_halaqa_ids', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        username,
        role,
        active,
        assignedHalaqaIds,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('assigned_halaqa_ids')) {
      context.handle(
          _assignedHalaqaIdsMeta,
          assignedHalaqaIds.isAcceptableOrUnknown(
              data['assigned_halaqa_ids']!, _assignedHalaqaIdsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      assignedHalaqaIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}assigned_halaqa_ids'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String fullName;
  final String username;
  final String role;
  final bool active;
  final String assignedHalaqaIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.fullName,
      required this.username,
      required this.role,
      required this.active,
      required this.assignedHalaqaIds,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['username'] = Variable<String>(username);
    map['role'] = Variable<String>(role);
    map['active'] = Variable<bool>(active);
    map['assigned_halaqa_ids'] = Variable<String>(assignedHalaqaIds);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      username: Value(username),
      role: Value(role),
      active: Value(active),
      assignedHalaqaIds: Value(assignedHalaqaIds),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      username: serializer.fromJson<String>(json['username']),
      role: serializer.fromJson<String>(json['role']),
      active: serializer.fromJson<bool>(json['active']),
      assignedHalaqaIds: serializer.fromJson<String>(json['assignedHalaqaIds']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'username': serializer.toJson<String>(username),
      'role': serializer.toJson<String>(role),
      'active': serializer.toJson<bool>(active),
      'assignedHalaqaIds': serializer.toJson<String>(assignedHalaqaIds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {String? id,
          String? fullName,
          String? username,
          String? role,
          bool? active,
          String? assignedHalaqaIds,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        username: username ?? this.username,
        role: role ?? this.role,
        active: active ?? this.active,
        assignedHalaqaIds: assignedHalaqaIds ?? this.assignedHalaqaIds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      username: data.username.present ? data.username.value : this.username,
      role: data.role.present ? data.role.value : this.role,
      active: data.active.present ? data.active.value : this.active,
      assignedHalaqaIds: data.assignedHalaqaIds.present
          ? data.assignedHalaqaIds.value
          : this.assignedHalaqaIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('role: $role, ')
          ..write('active: $active, ')
          ..write('assignedHalaqaIds: $assignedHalaqaIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, username, role, active,
      assignedHalaqaIds, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.username == this.username &&
          other.role == this.role &&
          other.active == this.active &&
          other.assignedHalaqaIds == this.assignedHalaqaIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> username;
  final Value<String> role;
  final Value<bool> active;
  final Value<String> assignedHalaqaIds;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.username = const Value.absent(),
    this.role = const Value.absent(),
    this.active = const Value.absent(),
    this.assignedHalaqaIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String fullName,
    required String username,
    required String role,
    this.active = const Value.absent(),
    this.assignedHalaqaIds = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        username = Value(username),
        role = Value(role),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? username,
    Expression<String>? role,
    Expression<bool>? active,
    Expression<String>? assignedHalaqaIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (username != null) 'username': username,
      if (role != null) 'role': role,
      if (active != null) 'active': active,
      if (assignedHalaqaIds != null) 'assigned_halaqa_ids': assignedHalaqaIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String>? username,
      Value<String>? role,
      Value<bool>? active,
      Value<String>? assignedHalaqaIds,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      role: role ?? this.role,
      active: active ?? this.active,
      assignedHalaqaIds: assignedHalaqaIds ?? this.assignedHalaqaIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (assignedHalaqaIds.present) {
      map['assigned_halaqa_ids'] = Variable<String>(assignedHalaqaIds.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('username: $username, ')
          ..write('role: $role, ')
          ..write('active: $active, ')
          ..write('assignedHalaqaIds: $assignedHalaqaIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HalaqasTable extends Halaqas with TableInfo<$HalaqasTable, Halaqa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HalaqasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _teacherIdsMeta =
      const VerificationMeta('teacherIds');
  @override
  late final GeneratedColumn<String> teacherIds = GeneratedColumn<String>(
      'teacher_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _supervisorIdMeta =
      const VerificationMeta('supervisorId');
  @override
  late final GeneratedColumn<String> supervisorId = GeneratedColumn<String>(
      'supervisor_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(25));
  static const VerificationMeta _scheduleDescriptionMeta =
      const VerificationMeta('scheduleDescription');
  @override
  late final GeneratedColumn<String> scheduleDescription =
      GeneratedColumn<String>('schedule_description', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        level,
        teacherIds,
        supervisorId,
        capacity,
        scheduleDescription,
        active
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'halaqas';
  @override
  VerificationContext validateIntegrity(Insertable<Halaqa> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('teacher_ids')) {
      context.handle(
          _teacherIdsMeta,
          teacherIds.isAcceptableOrUnknown(
              data['teacher_ids']!, _teacherIdsMeta));
    }
    if (data.containsKey('supervisor_id')) {
      context.handle(
          _supervisorIdMeta,
          supervisorId.isAcceptableOrUnknown(
              data['supervisor_id']!, _supervisorIdMeta));
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('schedule_description')) {
      context.handle(
          _scheduleDescriptionMeta,
          scheduleDescription.isAcceptableOrUnknown(
              data['schedule_description']!, _scheduleDescriptionMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Halaqa map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Halaqa(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      teacherIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_ids'])!,
      supervisorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supervisor_id'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      scheduleDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}schedule_description'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $HalaqasTable createAlias(String alias) {
    return $HalaqasTable(attachedDatabase, alias);
  }
}

class Halaqa extends DataClass implements Insertable<Halaqa> {
  final String id;
  final String name;
  final String level;
  final String teacherIds;
  final String supervisorId;
  final int capacity;
  final String scheduleDescription;
  final bool active;
  const Halaqa(
      {required this.id,
      required this.name,
      required this.level,
      required this.teacherIds,
      required this.supervisorId,
      required this.capacity,
      required this.scheduleDescription,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['level'] = Variable<String>(level);
    map['teacher_ids'] = Variable<String>(teacherIds);
    map['supervisor_id'] = Variable<String>(supervisorId);
    map['capacity'] = Variable<int>(capacity);
    map['schedule_description'] = Variable<String>(scheduleDescription);
    map['active'] = Variable<bool>(active);
    return map;
  }

  HalaqasCompanion toCompanion(bool nullToAbsent) {
    return HalaqasCompanion(
      id: Value(id),
      name: Value(name),
      level: Value(level),
      teacherIds: Value(teacherIds),
      supervisorId: Value(supervisorId),
      capacity: Value(capacity),
      scheduleDescription: Value(scheduleDescription),
      active: Value(active),
    );
  }

  factory Halaqa.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Halaqa(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<String>(json['level']),
      teacherIds: serializer.fromJson<String>(json['teacherIds']),
      supervisorId: serializer.fromJson<String>(json['supervisorId']),
      capacity: serializer.fromJson<int>(json['capacity']),
      scheduleDescription:
          serializer.fromJson<String>(json['scheduleDescription']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<String>(level),
      'teacherIds': serializer.toJson<String>(teacherIds),
      'supervisorId': serializer.toJson<String>(supervisorId),
      'capacity': serializer.toJson<int>(capacity),
      'scheduleDescription': serializer.toJson<String>(scheduleDescription),
      'active': serializer.toJson<bool>(active),
    };
  }

  Halaqa copyWith(
          {String? id,
          String? name,
          String? level,
          String? teacherIds,
          String? supervisorId,
          int? capacity,
          String? scheduleDescription,
          bool? active}) =>
      Halaqa(
        id: id ?? this.id,
        name: name ?? this.name,
        level: level ?? this.level,
        teacherIds: teacherIds ?? this.teacherIds,
        supervisorId: supervisorId ?? this.supervisorId,
        capacity: capacity ?? this.capacity,
        scheduleDescription: scheduleDescription ?? this.scheduleDescription,
        active: active ?? this.active,
      );
  Halaqa copyWithCompanion(HalaqasCompanion data) {
    return Halaqa(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      teacherIds:
          data.teacherIds.present ? data.teacherIds.value : this.teacherIds,
      supervisorId: data.supervisorId.present
          ? data.supervisorId.value
          : this.supervisorId,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      scheduleDescription: data.scheduleDescription.present
          ? data.scheduleDescription.value
          : this.scheduleDescription,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Halaqa(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('teacherIds: $teacherIds, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('capacity: $capacity, ')
          ..write('scheduleDescription: $scheduleDescription, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, level, teacherIds, supervisorId,
      capacity, scheduleDescription, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Halaqa &&
          other.id == this.id &&
          other.name == this.name &&
          other.level == this.level &&
          other.teacherIds == this.teacherIds &&
          other.supervisorId == this.supervisorId &&
          other.capacity == this.capacity &&
          other.scheduleDescription == this.scheduleDescription &&
          other.active == this.active);
}

class HalaqasCompanion extends UpdateCompanion<Halaqa> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> level;
  final Value<String> teacherIds;
  final Value<String> supervisorId;
  final Value<int> capacity;
  final Value<String> scheduleDescription;
  final Value<bool> active;
  final Value<int> rowid;
  const HalaqasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.teacherIds = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.capacity = const Value.absent(),
    this.scheduleDescription = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HalaqasCompanion.insert({
    required String id,
    required String name,
    this.level = const Value.absent(),
    this.teacherIds = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.capacity = const Value.absent(),
    this.scheduleDescription = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Halaqa> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? level,
    Expression<String>? teacherIds,
    Expression<String>? supervisorId,
    Expression<int>? capacity,
    Expression<String>? scheduleDescription,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (teacherIds != null) 'teacher_ids': teacherIds,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (capacity != null) 'capacity': capacity,
      if (scheduleDescription != null)
        'schedule_description': scheduleDescription,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HalaqasCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? level,
      Value<String>? teacherIds,
      Value<String>? supervisorId,
      Value<int>? capacity,
      Value<String>? scheduleDescription,
      Value<bool>? active,
      Value<int>? rowid}) {
    return HalaqasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      teacherIds: teacherIds ?? this.teacherIds,
      supervisorId: supervisorId ?? this.supervisorId,
      capacity: capacity ?? this.capacity,
      scheduleDescription: scheduleDescription ?? this.scheduleDescription,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (teacherIds.present) {
      map['teacher_ids'] = Variable<String>(teacherIds.value);
    }
    if (supervisorId.present) {
      map['supervisor_id'] = Variable<String>(supervisorId.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (scheduleDescription.present) {
      map['schedule_description'] = Variable<String>(scheduleDescription.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HalaqasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('teacherIds: $teacherIds, ')
          ..write('supervisorId: $supervisorId, ')
          ..write('capacity: $capacity, ')
          ..write('scheduleDescription: $scheduleDescription, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentCodeMeta =
      const VerificationMeta('studentCode');
  @override
  late final GeneratedColumn<String> studentCode = GeneratedColumn<String>(
      'student_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _halaqaIdMeta =
      const VerificationMeta('halaqaId');
  @override
  late final GeneratedColumn<String> halaqaId = GeneratedColumn<String>(
      'halaqa_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _joinDateMeta =
      const VerificationMeta('joinDate');
  @override
  late final GeneratedColumn<DateTime> joinDate = GeneratedColumn<DateTime>(
      'join_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _internalNotesMeta =
      const VerificationMeta('internalNotes');
  @override
  late final GeneratedColumn<String> internalNotes = GeneratedColumn<String>(
      'internal_notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentCode,
        fullName,
        halaqaId,
        level,
        active,
        joinDate,
        internalNotes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_code')) {
      context.handle(
          _studentCodeMeta,
          studentCode.isAcceptableOrUnknown(
              data['student_code']!, _studentCodeMeta));
    } else if (isInserting) {
      context.missing(_studentCodeMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('halaqa_id')) {
      context.handle(_halaqaIdMeta,
          halaqaId.isAcceptableOrUnknown(data['halaqa_id']!, _halaqaIdMeta));
    } else if (isInserting) {
      context.missing(_halaqaIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('join_date')) {
      context.handle(_joinDateMeta,
          joinDate.isAcceptableOrUnknown(data['join_date']!, _joinDateMeta));
    } else if (isInserting) {
      context.missing(_joinDateMeta);
    }
    if (data.containsKey('internal_notes')) {
      context.handle(
          _internalNotesMeta,
          internalNotes.isAcceptableOrUnknown(
              data['internal_notes']!, _internalNotesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_code'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      halaqaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}halaqa_id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      joinDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}join_date'])!,
      internalNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}internal_notes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String studentCode;
  final String fullName;
  final String halaqaId;
  final String level;
  final bool active;
  final DateTime joinDate;
  final String internalNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Student(
      {required this.id,
      required this.studentCode,
      required this.fullName,
      required this.halaqaId,
      required this.level,
      required this.active,
      required this.joinDate,
      required this.internalNotes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_code'] = Variable<String>(studentCode);
    map['full_name'] = Variable<String>(fullName);
    map['halaqa_id'] = Variable<String>(halaqaId);
    map['level'] = Variable<String>(level);
    map['active'] = Variable<bool>(active);
    map['join_date'] = Variable<DateTime>(joinDate);
    map['internal_notes'] = Variable<String>(internalNotes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      studentCode: Value(studentCode),
      fullName: Value(fullName),
      halaqaId: Value(halaqaId),
      level: Value(level),
      active: Value(active),
      joinDate: Value(joinDate),
      internalNotes: Value(internalNotes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      studentCode: serializer.fromJson<String>(json['studentCode']),
      fullName: serializer.fromJson<String>(json['fullName']),
      halaqaId: serializer.fromJson<String>(json['halaqaId']),
      level: serializer.fromJson<String>(json['level']),
      active: serializer.fromJson<bool>(json['active']),
      joinDate: serializer.fromJson<DateTime>(json['joinDate']),
      internalNotes: serializer.fromJson<String>(json['internalNotes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentCode': serializer.toJson<String>(studentCode),
      'fullName': serializer.toJson<String>(fullName),
      'halaqaId': serializer.toJson<String>(halaqaId),
      'level': serializer.toJson<String>(level),
      'active': serializer.toJson<bool>(active),
      'joinDate': serializer.toJson<DateTime>(joinDate),
      'internalNotes': serializer.toJson<String>(internalNotes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Student copyWith(
          {String? id,
          String? studentCode,
          String? fullName,
          String? halaqaId,
          String? level,
          bool? active,
          DateTime? joinDate,
          String? internalNotes,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Student(
        id: id ?? this.id,
        studentCode: studentCode ?? this.studentCode,
        fullName: fullName ?? this.fullName,
        halaqaId: halaqaId ?? this.halaqaId,
        level: level ?? this.level,
        active: active ?? this.active,
        joinDate: joinDate ?? this.joinDate,
        internalNotes: internalNotes ?? this.internalNotes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      studentCode:
          data.studentCode.present ? data.studentCode.value : this.studentCode,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      halaqaId: data.halaqaId.present ? data.halaqaId.value : this.halaqaId,
      level: data.level.present ? data.level.value : this.level,
      active: data.active.present ? data.active.value : this.active,
      joinDate: data.joinDate.present ? data.joinDate.value : this.joinDate,
      internalNotes: data.internalNotes.present
          ? data.internalNotes.value
          : this.internalNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('studentCode: $studentCode, ')
          ..write('fullName: $fullName, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('level: $level, ')
          ..write('active: $active, ')
          ..write('joinDate: $joinDate, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentCode, fullName, halaqaId, level,
      active, joinDate, internalNotes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.studentCode == this.studentCode &&
          other.fullName == this.fullName &&
          other.halaqaId == this.halaqaId &&
          other.level == this.level &&
          other.active == this.active &&
          other.joinDate == this.joinDate &&
          other.internalNotes == this.internalNotes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> studentCode;
  final Value<String> fullName;
  final Value<String> halaqaId;
  final Value<String> level;
  final Value<bool> active;
  final Value<DateTime> joinDate;
  final Value<String> internalNotes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.studentCode = const Value.absent(),
    this.fullName = const Value.absent(),
    this.halaqaId = const Value.absent(),
    this.level = const Value.absent(),
    this.active = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.internalNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String studentCode,
    required String fullName,
    required String halaqaId,
    this.level = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime joinDate,
    this.internalNotes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentCode = Value(studentCode),
        fullName = Value(fullName),
        halaqaId = Value(halaqaId),
        joinDate = Value(joinDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? studentCode,
    Expression<String>? fullName,
    Expression<String>? halaqaId,
    Expression<String>? level,
    Expression<bool>? active,
    Expression<DateTime>? joinDate,
    Expression<String>? internalNotes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentCode != null) 'student_code': studentCode,
      if (fullName != null) 'full_name': fullName,
      if (halaqaId != null) 'halaqa_id': halaqaId,
      if (level != null) 'level': level,
      if (active != null) 'active': active,
      if (joinDate != null) 'join_date': joinDate,
      if (internalNotes != null) 'internal_notes': internalNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentCode,
      Value<String>? fullName,
      Value<String>? halaqaId,
      Value<String>? level,
      Value<bool>? active,
      Value<DateTime>? joinDate,
      Value<String>? internalNotes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return StudentsCompanion(
      id: id ?? this.id,
      studentCode: studentCode ?? this.studentCode,
      fullName: fullName ?? this.fullName,
      halaqaId: halaqaId ?? this.halaqaId,
      level: level ?? this.level,
      active: active ?? this.active,
      joinDate: joinDate ?? this.joinDate,
      internalNotes: internalNotes ?? this.internalNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentCode.present) {
      map['student_code'] = Variable<String>(studentCode.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (halaqaId.present) {
      map['halaqa_id'] = Variable<String>(halaqaId.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (joinDate.present) {
      map['join_date'] = Variable<DateTime>(joinDate.value);
    }
    if (internalNotes.present) {
      map['internal_notes'] = Variable<String>(internalNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('studentCode: $studentCode, ')
          ..write('fullName: $fullName, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('level: $level, ')
          ..write('active: $active, ')
          ..write('joinDate: $joinDate, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyRecordsTable extends DailyRecords
    with TableInfo<$DailyRecordsTable, DailyRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _halaqaIdMeta =
      const VerificationMeta('halaqaId');
  @override
  late final GeneratedColumn<String> halaqaId = GeneratedColumn<String>(
      'halaqa_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherIdMeta =
      const VerificationMeta('teacherId');
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
      'teacher_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekdayMeta =
      const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
      'weekday', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isFridayMeta =
      const VerificationMeta('isFriday');
  @override
  late final GeneratedColumn<bool> isFriday = GeneratedColumn<bool>(
      'is_friday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_friday" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _newFromSurahMeta =
      const VerificationMeta('newFromSurah');
  @override
  late final GeneratedColumn<int> newFromSurah = GeneratedColumn<int>(
      'new_from_surah', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _newFromAyahMeta =
      const VerificationMeta('newFromAyah');
  @override
  late final GeneratedColumn<int> newFromAyah = GeneratedColumn<int>(
      'new_from_ayah', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _newToSurahMeta =
      const VerificationMeta('newToSurah');
  @override
  late final GeneratedColumn<int> newToSurah = GeneratedColumn<int>(
      'new_to_surah', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _newToAyahMeta =
      const VerificationMeta('newToAyah');
  @override
  late final GeneratedColumn<int> newToAyah = GeneratedColumn<int>(
      'new_to_ayah', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _newPagesMeta =
      const VerificationMeta('newPages');
  @override
  late final GeneratedColumn<double> newPages = GeneratedColumn<double>(
      'new_pages', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
      'grade', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _repetitionMeta =
      const VerificationMeta('repetition');
  @override
  late final GeneratedColumn<int> repetition = GeneratedColumn<int>(
      'repetition', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recentFromPageMeta =
      const VerificationMeta('recentFromPage');
  @override
  late final GeneratedColumn<int> recentFromPage = GeneratedColumn<int>(
      'recent_from_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recentToPageMeta =
      const VerificationMeta('recentToPage');
  @override
  late final GeneratedColumn<int> recentToPage = GeneratedColumn<int>(
      'recent_to_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minorFromPageMeta =
      const VerificationMeta('minorFromPage');
  @override
  late final GeneratedColumn<int> minorFromPage = GeneratedColumn<int>(
      'minor_from_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minorToPageMeta =
      const VerificationMeta('minorToPage');
  @override
  late final GeneratedColumn<int> minorToPage = GeneratedColumn<int>(
      'minor_to_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _majorFromPageMeta =
      const VerificationMeta('majorFromPage');
  @override
  late final GeneratedColumn<int> majorFromPage = GeneratedColumn<int>(
      'major_from_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _majorToPageMeta =
      const VerificationMeta('majorToPage');
  @override
  late final GeneratedColumn<int> majorToPage = GeneratedColumn<int>(
      'major_to_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        halaqaId,
        teacherId,
        date,
        dateKey,
        weekday,
        isFriday,
        newFromSurah,
        newFromAyah,
        newToSurah,
        newToAyah,
        newPages,
        grade,
        repetition,
        recentFromPage,
        recentToPage,
        minorFromPage,
        minorToPage,
        majorFromPage,
        majorToPage,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_records';
  @override
  VerificationContext validateIntegrity(Insertable<DailyRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('halaqa_id')) {
      context.handle(_halaqaIdMeta,
          halaqaId.isAcceptableOrUnknown(data['halaqa_id']!, _halaqaIdMeta));
    } else if (isInserting) {
      context.missing(_halaqaIdMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(_teacherIdMeta,
          teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta,
          weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('is_friday')) {
      context.handle(_isFridayMeta,
          isFriday.isAcceptableOrUnknown(data['is_friday']!, _isFridayMeta));
    }
    if (data.containsKey('new_from_surah')) {
      context.handle(
          _newFromSurahMeta,
          newFromSurah.isAcceptableOrUnknown(
              data['new_from_surah']!, _newFromSurahMeta));
    }
    if (data.containsKey('new_from_ayah')) {
      context.handle(
          _newFromAyahMeta,
          newFromAyah.isAcceptableOrUnknown(
              data['new_from_ayah']!, _newFromAyahMeta));
    }
    if (data.containsKey('new_to_surah')) {
      context.handle(
          _newToSurahMeta,
          newToSurah.isAcceptableOrUnknown(
              data['new_to_surah']!, _newToSurahMeta));
    }
    if (data.containsKey('new_to_ayah')) {
      context.handle(
          _newToAyahMeta,
          newToAyah.isAcceptableOrUnknown(
              data['new_to_ayah']!, _newToAyahMeta));
    }
    if (data.containsKey('new_pages')) {
      context.handle(_newPagesMeta,
          newPages.isAcceptableOrUnknown(data['new_pages']!, _newPagesMeta));
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    }
    if (data.containsKey('repetition')) {
      context.handle(
          _repetitionMeta,
          repetition.isAcceptableOrUnknown(
              data['repetition']!, _repetitionMeta));
    }
    if (data.containsKey('recent_from_page')) {
      context.handle(
          _recentFromPageMeta,
          recentFromPage.isAcceptableOrUnknown(
              data['recent_from_page']!, _recentFromPageMeta));
    }
    if (data.containsKey('recent_to_page')) {
      context.handle(
          _recentToPageMeta,
          recentToPage.isAcceptableOrUnknown(
              data['recent_to_page']!, _recentToPageMeta));
    }
    if (data.containsKey('minor_from_page')) {
      context.handle(
          _minorFromPageMeta,
          minorFromPage.isAcceptableOrUnknown(
              data['minor_from_page']!, _minorFromPageMeta));
    }
    if (data.containsKey('minor_to_page')) {
      context.handle(
          _minorToPageMeta,
          minorToPage.isAcceptableOrUnknown(
              data['minor_to_page']!, _minorToPageMeta));
    }
    if (data.containsKey('major_from_page')) {
      context.handle(
          _majorFromPageMeta,
          majorFromPage.isAcceptableOrUnknown(
              data['major_from_page']!, _majorFromPageMeta));
    }
    if (data.containsKey('major_to_page')) {
      context.handle(
          _majorToPageMeta,
          majorToPage.isAcceptableOrUnknown(
              data['major_to_page']!, _majorToPageMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {studentId, dateKey},
      ];
  @override
  DailyRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      halaqaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}halaqa_id'])!,
      teacherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      weekday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekday'])!,
      isFriday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_friday'])!,
      newFromSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_from_surah'])!,
      newFromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_from_ayah'])!,
      newToSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_to_surah'])!,
      newToAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}new_to_ayah'])!,
      newPages: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}new_pages'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade'])!,
      repetition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetition'])!,
      recentFromPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recent_from_page'])!,
      recentToPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recent_to_page'])!,
      minorFromPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minor_from_page'])!,
      minorToPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minor_to_page'])!,
      majorFromPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}major_from_page'])!,
      majorToPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}major_to_page'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DailyRecordsTable createAlias(String alias) {
    return $DailyRecordsTable(attachedDatabase, alias);
  }
}

class DailyRecord extends DataClass implements Insertable<DailyRecord> {
  final String id;
  final String studentId;
  final String halaqaId;
  final String teacherId;
  final DateTime date;
  final String dateKey;
  final int weekday;
  final bool isFriday;
  final int newFromSurah;
  final int newFromAyah;
  final int newToSurah;
  final int newToAyah;
  final double newPages;
  final String grade;
  final int repetition;
  final int recentFromPage;
  final int recentToPage;
  final int minorFromPage;
  final int minorToPage;
  final int majorFromPage;
  final int majorToPage;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyRecord(
      {required this.id,
      required this.studentId,
      required this.halaqaId,
      required this.teacherId,
      required this.date,
      required this.dateKey,
      required this.weekday,
      required this.isFriday,
      required this.newFromSurah,
      required this.newFromAyah,
      required this.newToSurah,
      required this.newToAyah,
      required this.newPages,
      required this.grade,
      required this.repetition,
      required this.recentFromPage,
      required this.recentToPage,
      required this.minorFromPage,
      required this.minorToPage,
      required this.majorFromPage,
      required this.majorToPage,
      required this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['halaqa_id'] = Variable<String>(halaqaId);
    map['teacher_id'] = Variable<String>(teacherId);
    map['date'] = Variable<DateTime>(date);
    map['date_key'] = Variable<String>(dateKey);
    map['weekday'] = Variable<int>(weekday);
    map['is_friday'] = Variable<bool>(isFriday);
    map['new_from_surah'] = Variable<int>(newFromSurah);
    map['new_from_ayah'] = Variable<int>(newFromAyah);
    map['new_to_surah'] = Variable<int>(newToSurah);
    map['new_to_ayah'] = Variable<int>(newToAyah);
    map['new_pages'] = Variable<double>(newPages);
    map['grade'] = Variable<String>(grade);
    map['repetition'] = Variable<int>(repetition);
    map['recent_from_page'] = Variable<int>(recentFromPage);
    map['recent_to_page'] = Variable<int>(recentToPage);
    map['minor_from_page'] = Variable<int>(minorFromPage);
    map['minor_to_page'] = Variable<int>(minorToPage);
    map['major_from_page'] = Variable<int>(majorFromPage);
    map['major_to_page'] = Variable<int>(majorToPage);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyRecordsCompanion toCompanion(bool nullToAbsent) {
    return DailyRecordsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      halaqaId: Value(halaqaId),
      teacherId: Value(teacherId),
      date: Value(date),
      dateKey: Value(dateKey),
      weekday: Value(weekday),
      isFriday: Value(isFriday),
      newFromSurah: Value(newFromSurah),
      newFromAyah: Value(newFromAyah),
      newToSurah: Value(newToSurah),
      newToAyah: Value(newToAyah),
      newPages: Value(newPages),
      grade: Value(grade),
      repetition: Value(repetition),
      recentFromPage: Value(recentFromPage),
      recentToPage: Value(recentToPage),
      minorFromPage: Value(minorFromPage),
      minorToPage: Value(minorToPage),
      majorFromPage: Value(majorFromPage),
      majorToPage: Value(majorToPage),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyRecord(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      halaqaId: serializer.fromJson<String>(json['halaqaId']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      date: serializer.fromJson<DateTime>(json['date']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      weekday: serializer.fromJson<int>(json['weekday']),
      isFriday: serializer.fromJson<bool>(json['isFriday']),
      newFromSurah: serializer.fromJson<int>(json['newFromSurah']),
      newFromAyah: serializer.fromJson<int>(json['newFromAyah']),
      newToSurah: serializer.fromJson<int>(json['newToSurah']),
      newToAyah: serializer.fromJson<int>(json['newToAyah']),
      newPages: serializer.fromJson<double>(json['newPages']),
      grade: serializer.fromJson<String>(json['grade']),
      repetition: serializer.fromJson<int>(json['repetition']),
      recentFromPage: serializer.fromJson<int>(json['recentFromPage']),
      recentToPage: serializer.fromJson<int>(json['recentToPage']),
      minorFromPage: serializer.fromJson<int>(json['minorFromPage']),
      minorToPage: serializer.fromJson<int>(json['minorToPage']),
      majorFromPage: serializer.fromJson<int>(json['majorFromPage']),
      majorToPage: serializer.fromJson<int>(json['majorToPage']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'halaqaId': serializer.toJson<String>(halaqaId),
      'teacherId': serializer.toJson<String>(teacherId),
      'date': serializer.toJson<DateTime>(date),
      'dateKey': serializer.toJson<String>(dateKey),
      'weekday': serializer.toJson<int>(weekday),
      'isFriday': serializer.toJson<bool>(isFriday),
      'newFromSurah': serializer.toJson<int>(newFromSurah),
      'newFromAyah': serializer.toJson<int>(newFromAyah),
      'newToSurah': serializer.toJson<int>(newToSurah),
      'newToAyah': serializer.toJson<int>(newToAyah),
      'newPages': serializer.toJson<double>(newPages),
      'grade': serializer.toJson<String>(grade),
      'repetition': serializer.toJson<int>(repetition),
      'recentFromPage': serializer.toJson<int>(recentFromPage),
      'recentToPage': serializer.toJson<int>(recentToPage),
      'minorFromPage': serializer.toJson<int>(minorFromPage),
      'minorToPage': serializer.toJson<int>(minorToPage),
      'majorFromPage': serializer.toJson<int>(majorFromPage),
      'majorToPage': serializer.toJson<int>(majorToPage),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyRecord copyWith(
          {String? id,
          String? studentId,
          String? halaqaId,
          String? teacherId,
          DateTime? date,
          String? dateKey,
          int? weekday,
          bool? isFriday,
          int? newFromSurah,
          int? newFromAyah,
          int? newToSurah,
          int? newToAyah,
          double? newPages,
          String? grade,
          int? repetition,
          int? recentFromPage,
          int? recentToPage,
          int? minorFromPage,
          int? minorToPage,
          int? majorFromPage,
          int? majorToPage,
          String? notes,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DailyRecord(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        halaqaId: halaqaId ?? this.halaqaId,
        teacherId: teacherId ?? this.teacherId,
        date: date ?? this.date,
        dateKey: dateKey ?? this.dateKey,
        weekday: weekday ?? this.weekday,
        isFriday: isFriday ?? this.isFriday,
        newFromSurah: newFromSurah ?? this.newFromSurah,
        newFromAyah: newFromAyah ?? this.newFromAyah,
        newToSurah: newToSurah ?? this.newToSurah,
        newToAyah: newToAyah ?? this.newToAyah,
        newPages: newPages ?? this.newPages,
        grade: grade ?? this.grade,
        repetition: repetition ?? this.repetition,
        recentFromPage: recentFromPage ?? this.recentFromPage,
        recentToPage: recentToPage ?? this.recentToPage,
        minorFromPage: minorFromPage ?? this.minorFromPage,
        minorToPage: minorToPage ?? this.minorToPage,
        majorFromPage: majorFromPage ?? this.majorFromPage,
        majorToPage: majorToPage ?? this.majorToPage,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyRecord copyWithCompanion(DailyRecordsCompanion data) {
    return DailyRecord(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      halaqaId: data.halaqaId.present ? data.halaqaId.value : this.halaqaId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      date: data.date.present ? data.date.value : this.date,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      isFriday: data.isFriday.present ? data.isFriday.value : this.isFriday,
      newFromSurah: data.newFromSurah.present
          ? data.newFromSurah.value
          : this.newFromSurah,
      newFromAyah:
          data.newFromAyah.present ? data.newFromAyah.value : this.newFromAyah,
      newToSurah:
          data.newToSurah.present ? data.newToSurah.value : this.newToSurah,
      newToAyah: data.newToAyah.present ? data.newToAyah.value : this.newToAyah,
      newPages: data.newPages.present ? data.newPages.value : this.newPages,
      grade: data.grade.present ? data.grade.value : this.grade,
      repetition:
          data.repetition.present ? data.repetition.value : this.repetition,
      recentFromPage: data.recentFromPage.present
          ? data.recentFromPage.value
          : this.recentFromPage,
      recentToPage: data.recentToPage.present
          ? data.recentToPage.value
          : this.recentToPage,
      minorFromPage: data.minorFromPage.present
          ? data.minorFromPage.value
          : this.minorFromPage,
      minorToPage:
          data.minorToPage.present ? data.minorToPage.value : this.minorToPage,
      majorFromPage: data.majorFromPage.present
          ? data.majorFromPage.value
          : this.majorFromPage,
      majorToPage:
          data.majorToPage.present ? data.majorToPage.value : this.majorToPage,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecord(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('teacherId: $teacherId, ')
          ..write('date: $date, ')
          ..write('dateKey: $dateKey, ')
          ..write('weekday: $weekday, ')
          ..write('isFriday: $isFriday, ')
          ..write('newFromSurah: $newFromSurah, ')
          ..write('newFromAyah: $newFromAyah, ')
          ..write('newToSurah: $newToSurah, ')
          ..write('newToAyah: $newToAyah, ')
          ..write('newPages: $newPages, ')
          ..write('grade: $grade, ')
          ..write('repetition: $repetition, ')
          ..write('recentFromPage: $recentFromPage, ')
          ..write('recentToPage: $recentToPage, ')
          ..write('minorFromPage: $minorFromPage, ')
          ..write('minorToPage: $minorToPage, ')
          ..write('majorFromPage: $majorFromPage, ')
          ..write('majorToPage: $majorToPage, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        studentId,
        halaqaId,
        teacherId,
        date,
        dateKey,
        weekday,
        isFriday,
        newFromSurah,
        newFromAyah,
        newToSurah,
        newToAyah,
        newPages,
        grade,
        repetition,
        recentFromPage,
        recentToPage,
        minorFromPage,
        minorToPage,
        majorFromPage,
        majorToPage,
        notes,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyRecord &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.halaqaId == this.halaqaId &&
          other.teacherId == this.teacherId &&
          other.date == this.date &&
          other.dateKey == this.dateKey &&
          other.weekday == this.weekday &&
          other.isFriday == this.isFriday &&
          other.newFromSurah == this.newFromSurah &&
          other.newFromAyah == this.newFromAyah &&
          other.newToSurah == this.newToSurah &&
          other.newToAyah == this.newToAyah &&
          other.newPages == this.newPages &&
          other.grade == this.grade &&
          other.repetition == this.repetition &&
          other.recentFromPage == this.recentFromPage &&
          other.recentToPage == this.recentToPage &&
          other.minorFromPage == this.minorFromPage &&
          other.minorToPage == this.minorToPage &&
          other.majorFromPage == this.majorFromPage &&
          other.majorToPage == this.majorToPage &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyRecordsCompanion extends UpdateCompanion<DailyRecord> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> halaqaId;
  final Value<String> teacherId;
  final Value<DateTime> date;
  final Value<String> dateKey;
  final Value<int> weekday;
  final Value<bool> isFriday;
  final Value<int> newFromSurah;
  final Value<int> newFromAyah;
  final Value<int> newToSurah;
  final Value<int> newToAyah;
  final Value<double> newPages;
  final Value<String> grade;
  final Value<int> repetition;
  final Value<int> recentFromPage;
  final Value<int> recentToPage;
  final Value<int> minorFromPage;
  final Value<int> minorToPage;
  final Value<int> majorFromPage;
  final Value<int> majorToPage;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyRecordsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.halaqaId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.date = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.weekday = const Value.absent(),
    this.isFriday = const Value.absent(),
    this.newFromSurah = const Value.absent(),
    this.newFromAyah = const Value.absent(),
    this.newToSurah = const Value.absent(),
    this.newToAyah = const Value.absent(),
    this.newPages = const Value.absent(),
    this.grade = const Value.absent(),
    this.repetition = const Value.absent(),
    this.recentFromPage = const Value.absent(),
    this.recentToPage = const Value.absent(),
    this.minorFromPage = const Value.absent(),
    this.minorToPage = const Value.absent(),
    this.majorFromPage = const Value.absent(),
    this.majorToPage = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyRecordsCompanion.insert({
    required String id,
    required String studentId,
    required String halaqaId,
    this.teacherId = const Value.absent(),
    required DateTime date,
    required String dateKey,
    required int weekday,
    this.isFriday = const Value.absent(),
    this.newFromSurah = const Value.absent(),
    this.newFromAyah = const Value.absent(),
    this.newToSurah = const Value.absent(),
    this.newToAyah = const Value.absent(),
    this.newPages = const Value.absent(),
    this.grade = const Value.absent(),
    this.repetition = const Value.absent(),
    this.recentFromPage = const Value.absent(),
    this.recentToPage = const Value.absent(),
    this.minorFromPage = const Value.absent(),
    this.minorToPage = const Value.absent(),
    this.majorFromPage = const Value.absent(),
    this.majorToPage = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        halaqaId = Value(halaqaId),
        date = Value(date),
        dateKey = Value(dateKey),
        weekday = Value(weekday),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DailyRecord> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? halaqaId,
    Expression<String>? teacherId,
    Expression<DateTime>? date,
    Expression<String>? dateKey,
    Expression<int>? weekday,
    Expression<bool>? isFriday,
    Expression<int>? newFromSurah,
    Expression<int>? newFromAyah,
    Expression<int>? newToSurah,
    Expression<int>? newToAyah,
    Expression<double>? newPages,
    Expression<String>? grade,
    Expression<int>? repetition,
    Expression<int>? recentFromPage,
    Expression<int>? recentToPage,
    Expression<int>? minorFromPage,
    Expression<int>? minorToPage,
    Expression<int>? majorFromPage,
    Expression<int>? majorToPage,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (halaqaId != null) 'halaqa_id': halaqaId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (date != null) 'date': date,
      if (dateKey != null) 'date_key': dateKey,
      if (weekday != null) 'weekday': weekday,
      if (isFriday != null) 'is_friday': isFriday,
      if (newFromSurah != null) 'new_from_surah': newFromSurah,
      if (newFromAyah != null) 'new_from_ayah': newFromAyah,
      if (newToSurah != null) 'new_to_surah': newToSurah,
      if (newToAyah != null) 'new_to_ayah': newToAyah,
      if (newPages != null) 'new_pages': newPages,
      if (grade != null) 'grade': grade,
      if (repetition != null) 'repetition': repetition,
      if (recentFromPage != null) 'recent_from_page': recentFromPage,
      if (recentToPage != null) 'recent_to_page': recentToPage,
      if (minorFromPage != null) 'minor_from_page': minorFromPage,
      if (minorToPage != null) 'minor_to_page': minorToPage,
      if (majorFromPage != null) 'major_from_page': majorFromPage,
      if (majorToPage != null) 'major_to_page': majorToPage,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<String>? halaqaId,
      Value<String>? teacherId,
      Value<DateTime>? date,
      Value<String>? dateKey,
      Value<int>? weekday,
      Value<bool>? isFriday,
      Value<int>? newFromSurah,
      Value<int>? newFromAyah,
      Value<int>? newToSurah,
      Value<int>? newToAyah,
      Value<double>? newPages,
      Value<String>? grade,
      Value<int>? repetition,
      Value<int>? recentFromPage,
      Value<int>? recentToPage,
      Value<int>? minorFromPage,
      Value<int>? minorToPage,
      Value<int>? majorFromPage,
      Value<int>? majorToPage,
      Value<String>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DailyRecordsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      halaqaId: halaqaId ?? this.halaqaId,
      teacherId: teacherId ?? this.teacherId,
      date: date ?? this.date,
      dateKey: dateKey ?? this.dateKey,
      weekday: weekday ?? this.weekday,
      isFriday: isFriday ?? this.isFriday,
      newFromSurah: newFromSurah ?? this.newFromSurah,
      newFromAyah: newFromAyah ?? this.newFromAyah,
      newToSurah: newToSurah ?? this.newToSurah,
      newToAyah: newToAyah ?? this.newToAyah,
      newPages: newPages ?? this.newPages,
      grade: grade ?? this.grade,
      repetition: repetition ?? this.repetition,
      recentFromPage: recentFromPage ?? this.recentFromPage,
      recentToPage: recentToPage ?? this.recentToPage,
      minorFromPage: minorFromPage ?? this.minorFromPage,
      minorToPage: minorToPage ?? this.minorToPage,
      majorFromPage: majorFromPage ?? this.majorFromPage,
      majorToPage: majorToPage ?? this.majorToPage,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (halaqaId.present) {
      map['halaqa_id'] = Variable<String>(halaqaId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (isFriday.present) {
      map['is_friday'] = Variable<bool>(isFriday.value);
    }
    if (newFromSurah.present) {
      map['new_from_surah'] = Variable<int>(newFromSurah.value);
    }
    if (newFromAyah.present) {
      map['new_from_ayah'] = Variable<int>(newFromAyah.value);
    }
    if (newToSurah.present) {
      map['new_to_surah'] = Variable<int>(newToSurah.value);
    }
    if (newToAyah.present) {
      map['new_to_ayah'] = Variable<int>(newToAyah.value);
    }
    if (newPages.present) {
      map['new_pages'] = Variable<double>(newPages.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (repetition.present) {
      map['repetition'] = Variable<int>(repetition.value);
    }
    if (recentFromPage.present) {
      map['recent_from_page'] = Variable<int>(recentFromPage.value);
    }
    if (recentToPage.present) {
      map['recent_to_page'] = Variable<int>(recentToPage.value);
    }
    if (minorFromPage.present) {
      map['minor_from_page'] = Variable<int>(minorFromPage.value);
    }
    if (minorToPage.present) {
      map['minor_to_page'] = Variable<int>(minorToPage.value);
    }
    if (majorFromPage.present) {
      map['major_from_page'] = Variable<int>(majorFromPage.value);
    }
    if (majorToPage.present) {
      map['major_to_page'] = Variable<int>(majorToPage.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyRecordsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('teacherId: $teacherId, ')
          ..write('date: $date, ')
          ..write('dateKey: $dateKey, ')
          ..write('weekday: $weekday, ')
          ..write('isFriday: $isFriday, ')
          ..write('newFromSurah: $newFromSurah, ')
          ..write('newFromAyah: $newFromAyah, ')
          ..write('newToSurah: $newToSurah, ')
          ..write('newToAyah: $newToAyah, ')
          ..write('newPages: $newPages, ')
          ..write('grade: $grade, ')
          ..write('repetition: $repetition, ')
          ..write('recentFromPage: $recentFromPage, ')
          ..write('recentToPage: $recentToPage, ')
          ..write('minorFromPage: $minorFromPage, ')
          ..write('minorToPage: $minorToPage, ')
          ..write('majorFromPage: $majorFromPage, ')
          ..write('majorToPage: $majorToPage, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyPlansTable extends WeeklyPlans
    with TableInfo<$WeeklyPlansTable, WeeklyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _halaqaIdMeta =
      const VerificationMeta('halaqaId');
  @override
  late final GeneratedColumn<String> halaqaId = GeneratedColumn<String>(
      'halaqa_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekStartKeyMeta =
      const VerificationMeta('weekStartKey');
  @override
  late final GeneratedColumn<String> weekStartKey = GeneratedColumn<String>(
      'week_start_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requiredNewPagesMeta =
      const VerificationMeta('requiredNewPages');
  @override
  late final GeneratedColumn<double> requiredNewPages = GeneratedColumn<double>(
      'required_new_pages', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _requiredRecentPagesMeta =
      const VerificationMeta('requiredRecentPages');
  @override
  late final GeneratedColumn<double> requiredRecentPages =
      GeneratedColumn<double>('required_recent_pages', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _requiredMinorPagesMeta =
      const VerificationMeta('requiredMinorPages');
  @override
  late final GeneratedColumn<double> requiredMinorPages =
      GeneratedColumn<double>('required_minor_pages', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _requiredMajorPagesMeta =
      const VerificationMeta('requiredMajorPages');
  @override
  late final GeneratedColumn<double> requiredMajorPages =
      GeneratedColumn<double>('required_major_pages', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _requiredFridayPagesMeta =
      const VerificationMeta('requiredFridayPages');
  @override
  late final GeneratedColumn<double> requiredFridayPages =
      GeneratedColumn<double>('required_friday_pages', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        halaqaId,
        weekStartKey,
        requiredNewPages,
        requiredRecentPages,
        requiredMinorPages,
        requiredMajorPages,
        requiredFridayPages,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_plans';
  @override
  VerificationContext validateIntegrity(Insertable<WeeklyPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('halaqa_id')) {
      context.handle(_halaqaIdMeta,
          halaqaId.isAcceptableOrUnknown(data['halaqa_id']!, _halaqaIdMeta));
    } else if (isInserting) {
      context.missing(_halaqaIdMeta);
    }
    if (data.containsKey('week_start_key')) {
      context.handle(
          _weekStartKeyMeta,
          weekStartKey.isAcceptableOrUnknown(
              data['week_start_key']!, _weekStartKeyMeta));
    } else if (isInserting) {
      context.missing(_weekStartKeyMeta);
    }
    if (data.containsKey('required_new_pages')) {
      context.handle(
          _requiredNewPagesMeta,
          requiredNewPages.isAcceptableOrUnknown(
              data['required_new_pages']!, _requiredNewPagesMeta));
    }
    if (data.containsKey('required_recent_pages')) {
      context.handle(
          _requiredRecentPagesMeta,
          requiredRecentPages.isAcceptableOrUnknown(
              data['required_recent_pages']!, _requiredRecentPagesMeta));
    }
    if (data.containsKey('required_minor_pages')) {
      context.handle(
          _requiredMinorPagesMeta,
          requiredMinorPages.isAcceptableOrUnknown(
              data['required_minor_pages']!, _requiredMinorPagesMeta));
    }
    if (data.containsKey('required_major_pages')) {
      context.handle(
          _requiredMajorPagesMeta,
          requiredMajorPages.isAcceptableOrUnknown(
              data['required_major_pages']!, _requiredMajorPagesMeta));
    }
    if (data.containsKey('required_friday_pages')) {
      context.handle(
          _requiredFridayPagesMeta,
          requiredFridayPages.isAcceptableOrUnknown(
              data['required_friday_pages']!, _requiredFridayPagesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {studentId, weekStartKey},
      ];
  @override
  WeeklyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      halaqaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}halaqa_id'])!,
      weekStartKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}week_start_key'])!,
      requiredNewPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}required_new_pages'])!,
      requiredRecentPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}required_recent_pages'])!,
      requiredMinorPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}required_minor_pages'])!,
      requiredMajorPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}required_major_pages'])!,
      requiredFridayPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}required_friday_pages'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WeeklyPlansTable createAlias(String alias) {
    return $WeeklyPlansTable(attachedDatabase, alias);
  }
}

class WeeklyPlan extends DataClass implements Insertable<WeeklyPlan> {
  final String id;
  final String studentId;
  final String halaqaId;
  final String weekStartKey;
  final double requiredNewPages;
  final double requiredRecentPages;
  final double requiredMinorPages;
  final double requiredMajorPages;
  final double requiredFridayPages;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WeeklyPlan(
      {required this.id,
      required this.studentId,
      required this.halaqaId,
      required this.weekStartKey,
      required this.requiredNewPages,
      required this.requiredRecentPages,
      required this.requiredMinorPages,
      required this.requiredMajorPages,
      required this.requiredFridayPages,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['halaqa_id'] = Variable<String>(halaqaId);
    map['week_start_key'] = Variable<String>(weekStartKey);
    map['required_new_pages'] = Variable<double>(requiredNewPages);
    map['required_recent_pages'] = Variable<double>(requiredRecentPages);
    map['required_minor_pages'] = Variable<double>(requiredMinorPages);
    map['required_major_pages'] = Variable<double>(requiredMajorPages);
    map['required_friday_pages'] = Variable<double>(requiredFridayPages);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WeeklyPlansCompanion toCompanion(bool nullToAbsent) {
    return WeeklyPlansCompanion(
      id: Value(id),
      studentId: Value(studentId),
      halaqaId: Value(halaqaId),
      weekStartKey: Value(weekStartKey),
      requiredNewPages: Value(requiredNewPages),
      requiredRecentPages: Value(requiredRecentPages),
      requiredMinorPages: Value(requiredMinorPages),
      requiredMajorPages: Value(requiredMajorPages),
      requiredFridayPages: Value(requiredFridayPages),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WeeklyPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyPlan(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      halaqaId: serializer.fromJson<String>(json['halaqaId']),
      weekStartKey: serializer.fromJson<String>(json['weekStartKey']),
      requiredNewPages: serializer.fromJson<double>(json['requiredNewPages']),
      requiredRecentPages:
          serializer.fromJson<double>(json['requiredRecentPages']),
      requiredMinorPages:
          serializer.fromJson<double>(json['requiredMinorPages']),
      requiredMajorPages:
          serializer.fromJson<double>(json['requiredMajorPages']),
      requiredFridayPages:
          serializer.fromJson<double>(json['requiredFridayPages']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'halaqaId': serializer.toJson<String>(halaqaId),
      'weekStartKey': serializer.toJson<String>(weekStartKey),
      'requiredNewPages': serializer.toJson<double>(requiredNewPages),
      'requiredRecentPages': serializer.toJson<double>(requiredRecentPages),
      'requiredMinorPages': serializer.toJson<double>(requiredMinorPages),
      'requiredMajorPages': serializer.toJson<double>(requiredMajorPages),
      'requiredFridayPages': serializer.toJson<double>(requiredFridayPages),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeeklyPlan copyWith(
          {String? id,
          String? studentId,
          String? halaqaId,
          String? weekStartKey,
          double? requiredNewPages,
          double? requiredRecentPages,
          double? requiredMinorPages,
          double? requiredMajorPages,
          double? requiredFridayPages,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WeeklyPlan(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        halaqaId: halaqaId ?? this.halaqaId,
        weekStartKey: weekStartKey ?? this.weekStartKey,
        requiredNewPages: requiredNewPages ?? this.requiredNewPages,
        requiredRecentPages: requiredRecentPages ?? this.requiredRecentPages,
        requiredMinorPages: requiredMinorPages ?? this.requiredMinorPages,
        requiredMajorPages: requiredMajorPages ?? this.requiredMajorPages,
        requiredFridayPages: requiredFridayPages ?? this.requiredFridayPages,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WeeklyPlan copyWithCompanion(WeeklyPlansCompanion data) {
    return WeeklyPlan(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      halaqaId: data.halaqaId.present ? data.halaqaId.value : this.halaqaId,
      weekStartKey: data.weekStartKey.present
          ? data.weekStartKey.value
          : this.weekStartKey,
      requiredNewPages: data.requiredNewPages.present
          ? data.requiredNewPages.value
          : this.requiredNewPages,
      requiredRecentPages: data.requiredRecentPages.present
          ? data.requiredRecentPages.value
          : this.requiredRecentPages,
      requiredMinorPages: data.requiredMinorPages.present
          ? data.requiredMinorPages.value
          : this.requiredMinorPages,
      requiredMajorPages: data.requiredMajorPages.present
          ? data.requiredMajorPages.value
          : this.requiredMajorPages,
      requiredFridayPages: data.requiredFridayPages.present
          ? data.requiredFridayPages.value
          : this.requiredFridayPages,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlan(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('weekStartKey: $weekStartKey, ')
          ..write('requiredNewPages: $requiredNewPages, ')
          ..write('requiredRecentPages: $requiredRecentPages, ')
          ..write('requiredMinorPages: $requiredMinorPages, ')
          ..write('requiredMajorPages: $requiredMajorPages, ')
          ..write('requiredFridayPages: $requiredFridayPages, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      studentId,
      halaqaId,
      weekStartKey,
      requiredNewPages,
      requiredRecentPages,
      requiredMinorPages,
      requiredMajorPages,
      requiredFridayPages,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyPlan &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.halaqaId == this.halaqaId &&
          other.weekStartKey == this.weekStartKey &&
          other.requiredNewPages == this.requiredNewPages &&
          other.requiredRecentPages == this.requiredRecentPages &&
          other.requiredMinorPages == this.requiredMinorPages &&
          other.requiredMajorPages == this.requiredMajorPages &&
          other.requiredFridayPages == this.requiredFridayPages &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeeklyPlansCompanion extends UpdateCompanion<WeeklyPlan> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> halaqaId;
  final Value<String> weekStartKey;
  final Value<double> requiredNewPages;
  final Value<double> requiredRecentPages;
  final Value<double> requiredMinorPages;
  final Value<double> requiredMajorPages;
  final Value<double> requiredFridayPages;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeeklyPlansCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.halaqaId = const Value.absent(),
    this.weekStartKey = const Value.absent(),
    this.requiredNewPages = const Value.absent(),
    this.requiredRecentPages = const Value.absent(),
    this.requiredMinorPages = const Value.absent(),
    this.requiredMajorPages = const Value.absent(),
    this.requiredFridayPages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyPlansCompanion.insert({
    required String id,
    required String studentId,
    required String halaqaId,
    required String weekStartKey,
    this.requiredNewPages = const Value.absent(),
    this.requiredRecentPages = const Value.absent(),
    this.requiredMinorPages = const Value.absent(),
    this.requiredMajorPages = const Value.absent(),
    this.requiredFridayPages = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        halaqaId = Value(halaqaId),
        weekStartKey = Value(weekStartKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<WeeklyPlan> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? halaqaId,
    Expression<String>? weekStartKey,
    Expression<double>? requiredNewPages,
    Expression<double>? requiredRecentPages,
    Expression<double>? requiredMinorPages,
    Expression<double>? requiredMajorPages,
    Expression<double>? requiredFridayPages,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (halaqaId != null) 'halaqa_id': halaqaId,
      if (weekStartKey != null) 'week_start_key': weekStartKey,
      if (requiredNewPages != null) 'required_new_pages': requiredNewPages,
      if (requiredRecentPages != null)
        'required_recent_pages': requiredRecentPages,
      if (requiredMinorPages != null)
        'required_minor_pages': requiredMinorPages,
      if (requiredMajorPages != null)
        'required_major_pages': requiredMajorPages,
      if (requiredFridayPages != null)
        'required_friday_pages': requiredFridayPages,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyPlansCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<String>? halaqaId,
      Value<String>? weekStartKey,
      Value<double>? requiredNewPages,
      Value<double>? requiredRecentPages,
      Value<double>? requiredMinorPages,
      Value<double>? requiredMajorPages,
      Value<double>? requiredFridayPages,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WeeklyPlansCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      halaqaId: halaqaId ?? this.halaqaId,
      weekStartKey: weekStartKey ?? this.weekStartKey,
      requiredNewPages: requiredNewPages ?? this.requiredNewPages,
      requiredRecentPages: requiredRecentPages ?? this.requiredRecentPages,
      requiredMinorPages: requiredMinorPages ?? this.requiredMinorPages,
      requiredMajorPages: requiredMajorPages ?? this.requiredMajorPages,
      requiredFridayPages: requiredFridayPages ?? this.requiredFridayPages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (halaqaId.present) {
      map['halaqa_id'] = Variable<String>(halaqaId.value);
    }
    if (weekStartKey.present) {
      map['week_start_key'] = Variable<String>(weekStartKey.value);
    }
    if (requiredNewPages.present) {
      map['required_new_pages'] = Variable<double>(requiredNewPages.value);
    }
    if (requiredRecentPages.present) {
      map['required_recent_pages'] =
          Variable<double>(requiredRecentPages.value);
    }
    if (requiredMinorPages.present) {
      map['required_minor_pages'] = Variable<double>(requiredMinorPages.value);
    }
    if (requiredMajorPages.present) {
      map['required_major_pages'] = Variable<double>(requiredMajorPages.value);
    }
    if (requiredFridayPages.present) {
      map['required_friday_pages'] =
          Variable<double>(requiredFridayPages.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlansCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('weekStartKey: $weekStartKey, ')
          ..write('requiredNewPages: $requiredNewPages, ')
          ..write('requiredRecentPages: $requiredRecentPages, ')
          ..write('requiredMinorPages: $requiredMinorPages, ')
          ..write('requiredMajorPages: $requiredMajorPages, ')
          ..write('requiredFridayPages: $requiredFridayPages, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentTransfersTable extends StudentTransfers
    with TableInfo<$StudentTransfersTable, StudentTransfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentTransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
      'student_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromHalaqaIdMeta =
      const VerificationMeta('fromHalaqaId');
  @override
  late final GeneratedColumn<String> fromHalaqaId = GeneratedColumn<String>(
      'from_halaqa_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toHalaqaIdMeta =
      const VerificationMeta('toHalaqaId');
  @override
  late final GeneratedColumn<String> toHalaqaId = GeneratedColumn<String>(
      'to_halaqa_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transferredAtMeta =
      const VerificationMeta('transferredAt');
  @override
  late final GeneratedColumn<DateTime> transferredAt =
      GeneratedColumn<DateTime>('transferred_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _byUserMeta = const VerificationMeta('byUser');
  @override
  late final GeneratedColumn<String> byUser = GeneratedColumn<String>(
      'by_user', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, fromHalaqaId, toHalaqaId, transferredAt, byUser];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_transfers';
  @override
  VerificationContext validateIntegrity(Insertable<StudentTransfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('from_halaqa_id')) {
      context.handle(
          _fromHalaqaIdMeta,
          fromHalaqaId.isAcceptableOrUnknown(
              data['from_halaqa_id']!, _fromHalaqaIdMeta));
    } else if (isInserting) {
      context.missing(_fromHalaqaIdMeta);
    }
    if (data.containsKey('to_halaqa_id')) {
      context.handle(
          _toHalaqaIdMeta,
          toHalaqaId.isAcceptableOrUnknown(
              data['to_halaqa_id']!, _toHalaqaIdMeta));
    } else if (isInserting) {
      context.missing(_toHalaqaIdMeta);
    }
    if (data.containsKey('transferred_at')) {
      context.handle(
          _transferredAtMeta,
          transferredAt.isAcceptableOrUnknown(
              data['transferred_at']!, _transferredAtMeta));
    } else if (isInserting) {
      context.missing(_transferredAtMeta);
    }
    if (data.containsKey('by_user')) {
      context.handle(_byUserMeta,
          byUser.isAcceptableOrUnknown(data['by_user']!, _byUserMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentTransfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      fromHalaqaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_halaqa_id'])!,
      toHalaqaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_halaqa_id'])!,
      transferredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transferred_at'])!,
      byUser: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}by_user'])!,
    );
  }

  @override
  $StudentTransfersTable createAlias(String alias) {
    return $StudentTransfersTable(attachedDatabase, alias);
  }
}

class StudentTransfer extends DataClass implements Insertable<StudentTransfer> {
  final String id;
  final String studentId;
  final String fromHalaqaId;
  final String toHalaqaId;
  final DateTime transferredAt;
  final String byUser;
  const StudentTransfer(
      {required this.id,
      required this.studentId,
      required this.fromHalaqaId,
      required this.toHalaqaId,
      required this.transferredAt,
      required this.byUser});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['from_halaqa_id'] = Variable<String>(fromHalaqaId);
    map['to_halaqa_id'] = Variable<String>(toHalaqaId);
    map['transferred_at'] = Variable<DateTime>(transferredAt);
    map['by_user'] = Variable<String>(byUser);
    return map;
  }

  StudentTransfersCompanion toCompanion(bool nullToAbsent) {
    return StudentTransfersCompanion(
      id: Value(id),
      studentId: Value(studentId),
      fromHalaqaId: Value(fromHalaqaId),
      toHalaqaId: Value(toHalaqaId),
      transferredAt: Value(transferredAt),
      byUser: Value(byUser),
    );
  }

  factory StudentTransfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentTransfer(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      fromHalaqaId: serializer.fromJson<String>(json['fromHalaqaId']),
      toHalaqaId: serializer.fromJson<String>(json['toHalaqaId']),
      transferredAt: serializer.fromJson<DateTime>(json['transferredAt']),
      byUser: serializer.fromJson<String>(json['byUser']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'fromHalaqaId': serializer.toJson<String>(fromHalaqaId),
      'toHalaqaId': serializer.toJson<String>(toHalaqaId),
      'transferredAt': serializer.toJson<DateTime>(transferredAt),
      'byUser': serializer.toJson<String>(byUser),
    };
  }

  StudentTransfer copyWith(
          {String? id,
          String? studentId,
          String? fromHalaqaId,
          String? toHalaqaId,
          DateTime? transferredAt,
          String? byUser}) =>
      StudentTransfer(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        fromHalaqaId: fromHalaqaId ?? this.fromHalaqaId,
        toHalaqaId: toHalaqaId ?? this.toHalaqaId,
        transferredAt: transferredAt ?? this.transferredAt,
        byUser: byUser ?? this.byUser,
      );
  StudentTransfer copyWithCompanion(StudentTransfersCompanion data) {
    return StudentTransfer(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      fromHalaqaId: data.fromHalaqaId.present
          ? data.fromHalaqaId.value
          : this.fromHalaqaId,
      toHalaqaId:
          data.toHalaqaId.present ? data.toHalaqaId.value : this.toHalaqaId,
      transferredAt: data.transferredAt.present
          ? data.transferredAt.value
          : this.transferredAt,
      byUser: data.byUser.present ? data.byUser.value : this.byUser,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentTransfer(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('fromHalaqaId: $fromHalaqaId, ')
          ..write('toHalaqaId: $toHalaqaId, ')
          ..write('transferredAt: $transferredAt, ')
          ..write('byUser: $byUser')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, studentId, fromHalaqaId, toHalaqaId, transferredAt, byUser);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentTransfer &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.fromHalaqaId == this.fromHalaqaId &&
          other.toHalaqaId == this.toHalaqaId &&
          other.transferredAt == this.transferredAt &&
          other.byUser == this.byUser);
}

class StudentTransfersCompanion extends UpdateCompanion<StudentTransfer> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> fromHalaqaId;
  final Value<String> toHalaqaId;
  final Value<DateTime> transferredAt;
  final Value<String> byUser;
  final Value<int> rowid;
  const StudentTransfersCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.fromHalaqaId = const Value.absent(),
    this.toHalaqaId = const Value.absent(),
    this.transferredAt = const Value.absent(),
    this.byUser = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentTransfersCompanion.insert({
    required String id,
    required String studentId,
    required String fromHalaqaId,
    required String toHalaqaId,
    required DateTime transferredAt,
    this.byUser = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        fromHalaqaId = Value(fromHalaqaId),
        toHalaqaId = Value(toHalaqaId),
        transferredAt = Value(transferredAt);
  static Insertable<StudentTransfer> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? fromHalaqaId,
    Expression<String>? toHalaqaId,
    Expression<DateTime>? transferredAt,
    Expression<String>? byUser,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (fromHalaqaId != null) 'from_halaqa_id': fromHalaqaId,
      if (toHalaqaId != null) 'to_halaqa_id': toHalaqaId,
      if (transferredAt != null) 'transferred_at': transferredAt,
      if (byUser != null) 'by_user': byUser,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentTransfersCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<String>? fromHalaqaId,
      Value<String>? toHalaqaId,
      Value<DateTime>? transferredAt,
      Value<String>? byUser,
      Value<int>? rowid}) {
    return StudentTransfersCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      fromHalaqaId: fromHalaqaId ?? this.fromHalaqaId,
      toHalaqaId: toHalaqaId ?? this.toHalaqaId,
      transferredAt: transferredAt ?? this.transferredAt,
      byUser: byUser ?? this.byUser,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (fromHalaqaId.present) {
      map['from_halaqa_id'] = Variable<String>(fromHalaqaId.value);
    }
    if (toHalaqaId.present) {
      map['to_halaqa_id'] = Variable<String>(toHalaqaId.value);
    }
    if (transferredAt.present) {
      map['transferred_at'] = Variable<DateTime>(transferredAt.value);
    }
    if (byUser.present) {
      map['by_user'] = Variable<String>(byUser.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentTransfersCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('fromHalaqaId: $fromHalaqaId, ')
          ..write('toHalaqaId: $toHalaqaId, ')
          ..write('transferredAt: $transferredAt, ')
          ..write('byUser: $byUser, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $HalaqasTable halaqas = $HalaqasTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $DailyRecordsTable dailyRecords = $DailyRecordsTable(this);
  late final $WeeklyPlansTable weeklyPlans = $WeeklyPlansTable(this);
  late final $StudentTransfersTable studentTransfers =
      $StudentTransfersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, halaqas, students, dailyRecords, weeklyPlans, studentTransfers];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String fullName,
  required String username,
  required String role,
  Value<bool> active,
  Value<String> assignedHalaqaIds,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> username,
  Value<String> role,
  Value<bool> active,
  Value<String> assignedHalaqaIds,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedHalaqaIds => $composableBuilder(
      column: $table.assignedHalaqaIds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedHalaqaIds => $composableBuilder(
      column: $table.assignedHalaqaIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get assignedHalaqaIds => $composableBuilder(
      column: $table.assignedHalaqaIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<String> assignedHalaqaIds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            fullName: fullName,
            username: username,
            role: role,
            active: active,
            assignedHalaqaIds: assignedHalaqaIds,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            required String username,
            required String role,
            Value<bool> active = const Value.absent(),
            Value<String> assignedHalaqaIds = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            fullName: fullName,
            username: username,
            role: role,
            active: active,
            assignedHalaqaIds: assignedHalaqaIds,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$HalaqasTableCreateCompanionBuilder = HalaqasCompanion Function({
  required String id,
  required String name,
  Value<String> level,
  Value<String> teacherIds,
  Value<String> supervisorId,
  Value<int> capacity,
  Value<String> scheduleDescription,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$HalaqasTableUpdateCompanionBuilder = HalaqasCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> level,
  Value<String> teacherIds,
  Value<String> supervisorId,
  Value<int> capacity,
  Value<String> scheduleDescription,
  Value<bool> active,
  Value<int> rowid,
});

class $$HalaqasTableFilterComposer
    extends Composer<_$AppDatabase, $HalaqasTable> {
  $$HalaqasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get teacherIds => $composableBuilder(
      column: $table.teacherIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleDescription => $composableBuilder(
      column: $table.scheduleDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$HalaqasTableOrderingComposer
    extends Composer<_$AppDatabase, $HalaqasTable> {
  $$HalaqasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get teacherIds => $composableBuilder(
      column: $table.teacherIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleDescription => $composableBuilder(
      column: $table.scheduleDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$HalaqasTableAnnotationComposer
    extends Composer<_$AppDatabase, $HalaqasTable> {
  $$HalaqasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get teacherIds => $composableBuilder(
      column: $table.teacherIds, builder: (column) => column);

  GeneratedColumn<String> get supervisorId => $composableBuilder(
      column: $table.supervisorId, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get scheduleDescription => $composableBuilder(
      column: $table.scheduleDescription, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$HalaqasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HalaqasTable,
    Halaqa,
    $$HalaqasTableFilterComposer,
    $$HalaqasTableOrderingComposer,
    $$HalaqasTableAnnotationComposer,
    $$HalaqasTableCreateCompanionBuilder,
    $$HalaqasTableUpdateCompanionBuilder,
    (Halaqa, BaseReferences<_$AppDatabase, $HalaqasTable, Halaqa>),
    Halaqa,
    PrefetchHooks Function()> {
  $$HalaqasTableTableManager(_$AppDatabase db, $HalaqasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HalaqasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HalaqasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HalaqasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> teacherIds = const Value.absent(),
            Value<String> supervisorId = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<String> scheduleDescription = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HalaqasCompanion(
            id: id,
            name: name,
            level: level,
            teacherIds: teacherIds,
            supervisorId: supervisorId,
            capacity: capacity,
            scheduleDescription: scheduleDescription,
            active: active,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> level = const Value.absent(),
            Value<String> teacherIds = const Value.absent(),
            Value<String> supervisorId = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<String> scheduleDescription = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HalaqasCompanion.insert(
            id: id,
            name: name,
            level: level,
            teacherIds: teacherIds,
            supervisorId: supervisorId,
            capacity: capacity,
            scheduleDescription: scheduleDescription,
            active: active,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HalaqasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HalaqasTable,
    Halaqa,
    $$HalaqasTableFilterComposer,
    $$HalaqasTableOrderingComposer,
    $$HalaqasTableAnnotationComposer,
    $$HalaqasTableCreateCompanionBuilder,
    $$HalaqasTableUpdateCompanionBuilder,
    (Halaqa, BaseReferences<_$AppDatabase, $HalaqasTable, Halaqa>),
    Halaqa,
    PrefetchHooks Function()>;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  required String id,
  required String studentCode,
  required String fullName,
  required String halaqaId,
  Value<String> level,
  Value<bool> active,
  required DateTime joinDate,
  Value<String> internalNotes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> id,
  Value<String> studentCode,
  Value<String> fullName,
  Value<String> halaqaId,
  Value<String> level,
  Value<bool> active,
  Value<DateTime> joinDate,
  Value<String> internalNotes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentCode => $composableBuilder(
      column: $table.studentCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get halaqaId => $composableBuilder(
      column: $table.halaqaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinDate => $composableBuilder(
      column: $table.joinDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get internalNotes => $composableBuilder(
      column: $table.internalNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentCode => $composableBuilder(
      column: $table.studentCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get halaqaId => $composableBuilder(
      column: $table.halaqaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinDate => $composableBuilder(
      column: $table.joinDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get internalNotes => $composableBuilder(
      column: $table.internalNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentCode => $composableBuilder(
      column: $table.studentCode, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get halaqaId =>
      $composableBuilder(column: $table.halaqaId, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get joinDate =>
      $composableBuilder(column: $table.joinDate, builder: (column) => column);

  GeneratedColumn<String> get internalNotes => $composableBuilder(
      column: $table.internalNotes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentCode = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> halaqaId = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime> joinDate = const Value.absent(),
            Value<String> internalNotes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            studentCode: studentCode,
            fullName: fullName,
            halaqaId: halaqaId,
            level: level,
            active: active,
            joinDate: joinDate,
            internalNotes: internalNotes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentCode,
            required String fullName,
            required String halaqaId,
            Value<String> level = const Value.absent(),
            Value<bool> active = const Value.absent(),
            required DateTime joinDate,
            Value<String> internalNotes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion.insert(
            id: id,
            studentCode: studentCode,
            fullName: fullName,
            halaqaId: halaqaId,
            level: level,
            active: active,
            joinDate: joinDate,
            internalNotes: internalNotes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()>;
typedef $$DailyRecordsTableCreateCompanionBuilder = DailyRecordsCompanion
    Function({
  required String id,
  required String studentId,
  required String halaqaId,
  Value<String> teacherId,
  required DateTime date,
  required String dateKey,
  required int weekday,
  Value<bool> isFriday,
  Value<int> newFromSurah,
  Value<int> newFromAyah,
  Value<int> newToSurah,
  Value<int> newToAyah,
  Value<double> newPages,
  Value<String> grade,
  Value<int> repetition,
  Value<int> recentFromPage,
  Value<int> recentToPage,
  Value<int> minorFromPage,
  Value<int> minorToPage,
  Value<int> majorFromPage,
  Value<int> majorToPage,
  Value<String> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DailyRecordsTableUpdateCompanionBuilder = DailyRecordsCompanion
    Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> halaqaId,
  Value<String> teacherId,
  Value<DateTime> date,
  Value<String> dateKey,
  Value<int> weekday,
  Value<bool> isFriday,
  Value<int> newFromSurah,
  Value<int> newFromAyah,
  Value<int> newToSurah,
  Value<int> newToAyah,
  Value<double> newPages,
  Value<String> grade,
  Value<int> repetition,
  Value<int> recentFromPage,
  Value<int> recentToPage,
  Value<int> minorFromPage,
  Value<int> minorToPage,
  Value<int> majorFromPage,
  Value<int> majorToPage,
  Value<String> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DailyRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get halaqaId => $composableBuilder(
      column: $table.halaqaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get teacherId => $composableBuilder(
      column: $table.teacherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFriday => $composableBuilder(
      column: $table.isFriday, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newFromSurah => $composableBuilder(
      column: $table.newFromSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newFromAyah => $composableBuilder(
      column: $table.newFromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newToSurah => $composableBuilder(
      column: $table.newToSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get newToAyah => $composableBuilder(
      column: $table.newToAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get newPages => $composableBuilder(
      column: $table.newPages, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetition => $composableBuilder(
      column: $table.repetition, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recentFromPage => $composableBuilder(
      column: $table.recentFromPage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recentToPage => $composableBuilder(
      column: $table.recentToPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minorFromPage => $composableBuilder(
      column: $table.minorFromPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minorToPage => $composableBuilder(
      column: $table.minorToPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get majorFromPage => $composableBuilder(
      column: $table.majorFromPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get majorToPage => $composableBuilder(
      column: $table.majorToPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DailyRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get halaqaId => $composableBuilder(
      column: $table.halaqaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get teacherId => $composableBuilder(
      column: $table.teacherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekday => $composableBuilder(
      column: $table.weekday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFriday => $composableBuilder(
      column: $table.isFriday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newFromSurah => $composableBuilder(
      column: $table.newFromSurah,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newFromAyah => $composableBuilder(
      column: $table.newFromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newToSurah => $composableBuilder(
      column: $table.newToSurah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get newToAyah => $composableBuilder(
      column: $table.newToAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get newPages => $composableBuilder(
      column: $table.newPages, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetition => $composableBuilder(
      column: $table.repetition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recentFromPage => $composableBuilder(
      column: $table.recentFromPage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recentToPage => $composableBuilder(
      column: $table.recentToPage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minorFromPage => $composableBuilder(
      column: $table.minorFromPage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minorToPage => $composableBuilder(
      column: $table.minorToPage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get majorFromPage => $composableBuilder(
      column: $table.majorFromPage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get majorToPage => $composableBuilder(
      column: $table.majorToPage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DailyRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyRecordsTable> {
  $$DailyRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get halaqaId =>
      $composableBuilder(column: $table.halaqaId, builder: (column) => column);

  GeneratedColumn<String> get teacherId =>
      $composableBuilder(column: $table.teacherId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<bool> get isFriday =>
      $composableBuilder(column: $table.isFriday, builder: (column) => column);

  GeneratedColumn<int> get newFromSurah => $composableBuilder(
      column: $table.newFromSurah, builder: (column) => column);

  GeneratedColumn<int> get newFromAyah => $composableBuilder(
      column: $table.newFromAyah, builder: (column) => column);

  GeneratedColumn<int> get newToSurah => $composableBuilder(
      column: $table.newToSurah, builder: (column) => column);

  GeneratedColumn<int> get newToAyah =>
      $composableBuilder(column: $table.newToAyah, builder: (column) => column);

  GeneratedColumn<double> get newPages =>
      $composableBuilder(column: $table.newPages, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<int> get repetition => $composableBuilder(
      column: $table.repetition, builder: (column) => column);

  GeneratedColumn<int> get recentFromPage => $composableBuilder(
      column: $table.recentFromPage, builder: (column) => column);

  GeneratedColumn<int> get recentToPage => $composableBuilder(
      column: $table.recentToPage, builder: (column) => column);

  GeneratedColumn<int> get minorFromPage => $composableBuilder(
      column: $table.minorFromPage, builder: (column) => column);

  GeneratedColumn<int> get minorToPage => $composableBuilder(
      column: $table.minorToPage, builder: (column) => column);

  GeneratedColumn<int> get majorFromPage => $composableBuilder(
      column: $table.majorFromPage, builder: (column) => column);

  GeneratedColumn<int> get majorToPage => $composableBuilder(
      column: $table.majorToPage, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyRecordsTable,
    DailyRecord,
    $$DailyRecordsTableFilterComposer,
    $$DailyRecordsTableOrderingComposer,
    $$DailyRecordsTableAnnotationComposer,
    $$DailyRecordsTableCreateCompanionBuilder,
    $$DailyRecordsTableUpdateCompanionBuilder,
    (
      DailyRecord,
      BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord>
    ),
    DailyRecord,
    PrefetchHooks Function()> {
  $$DailyRecordsTableTableManager(_$AppDatabase db, $DailyRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> halaqaId = const Value.absent(),
            Value<String> teacherId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<int> weekday = const Value.absent(),
            Value<bool> isFriday = const Value.absent(),
            Value<int> newFromSurah = const Value.absent(),
            Value<int> newFromAyah = const Value.absent(),
            Value<int> newToSurah = const Value.absent(),
            Value<int> newToAyah = const Value.absent(),
            Value<double> newPages = const Value.absent(),
            Value<String> grade = const Value.absent(),
            Value<int> repetition = const Value.absent(),
            Value<int> recentFromPage = const Value.absent(),
            Value<int> recentToPage = const Value.absent(),
            Value<int> minorFromPage = const Value.absent(),
            Value<int> minorToPage = const Value.absent(),
            Value<int> majorFromPage = const Value.absent(),
            Value<int> majorToPage = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyRecordsCompanion(
            id: id,
            studentId: studentId,
            halaqaId: halaqaId,
            teacherId: teacherId,
            date: date,
            dateKey: dateKey,
            weekday: weekday,
            isFriday: isFriday,
            newFromSurah: newFromSurah,
            newFromAyah: newFromAyah,
            newToSurah: newToSurah,
            newToAyah: newToAyah,
            newPages: newPages,
            grade: grade,
            repetition: repetition,
            recentFromPage: recentFromPage,
            recentToPage: recentToPage,
            minorFromPage: minorFromPage,
            minorToPage: minorToPage,
            majorFromPage: majorFromPage,
            majorToPage: majorToPage,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required String halaqaId,
            Value<String> teacherId = const Value.absent(),
            required DateTime date,
            required String dateKey,
            required int weekday,
            Value<bool> isFriday = const Value.absent(),
            Value<int> newFromSurah = const Value.absent(),
            Value<int> newFromAyah = const Value.absent(),
            Value<int> newToSurah = const Value.absent(),
            Value<int> newToAyah = const Value.absent(),
            Value<double> newPages = const Value.absent(),
            Value<String> grade = const Value.absent(),
            Value<int> repetition = const Value.absent(),
            Value<int> recentFromPage = const Value.absent(),
            Value<int> recentToPage = const Value.absent(),
            Value<int> minorFromPage = const Value.absent(),
            Value<int> minorToPage = const Value.absent(),
            Value<int> majorFromPage = const Value.absent(),
            Value<int> majorToPage = const Value.absent(),
            Value<String> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyRecordsCompanion.insert(
            id: id,
            studentId: studentId,
            halaqaId: halaqaId,
            teacherId: teacherId,
            date: date,
            dateKey: dateKey,
            weekday: weekday,
            isFriday: isFriday,
            newFromSurah: newFromSurah,
            newFromAyah: newFromAyah,
            newToSurah: newToSurah,
            newToAyah: newToAyah,
            newPages: newPages,
            grade: grade,
            repetition: repetition,
            recentFromPage: recentFromPage,
            recentToPage: recentToPage,
            minorFromPage: minorFromPage,
            minorToPage: minorToPage,
            majorFromPage: majorFromPage,
            majorToPage: majorToPage,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyRecordsTable,
    DailyRecord,
    $$DailyRecordsTableFilterComposer,
    $$DailyRecordsTableOrderingComposer,
    $$DailyRecordsTableAnnotationComposer,
    $$DailyRecordsTableCreateCompanionBuilder,
    $$DailyRecordsTableUpdateCompanionBuilder,
    (
      DailyRecord,
      BaseReferences<_$AppDatabase, $DailyRecordsTable, DailyRecord>
    ),
    DailyRecord,
    PrefetchHooks Function()>;
typedef $$WeeklyPlansTableCreateCompanionBuilder = WeeklyPlansCompanion
    Function({
  required String id,
  required String studentId,
  required String halaqaId,
  required String weekStartKey,
  Value<double> requiredNewPages,
  Value<double> requiredRecentPages,
  Value<double> requiredMinorPages,
  Value<double> requiredMajorPages,
  Value<double> requiredFridayPages,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WeeklyPlansTableUpdateCompanionBuilder = WeeklyPlansCompanion
    Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> halaqaId,
  Value<String> weekStartKey,
  Value<double> requiredNewPages,
  Value<double> requiredRecentPages,
  Value<double> requiredMinorPages,
  Value<double> requiredMajorPages,
  Value<double> requiredFridayPages,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WeeklyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTable> {
  $$WeeklyPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get halaqaId => $composableBuilder(
      column: $table.halaqaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekStartKey => $composableBuilder(
      column: $table.weekStartKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get requiredNewPages => $composableBuilder(
      column: $table.requiredNewPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get requiredRecentPages => $composableBuilder(
      column: $table.requiredRecentPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get requiredMinorPages => $composableBuilder(
      column: $table.requiredMinorPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get requiredMajorPages => $composableBuilder(
      column: $table.requiredMajorPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get requiredFridayPages => $composableBuilder(
      column: $table.requiredFridayPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$WeeklyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTable> {
  $$WeeklyPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get halaqaId => $composableBuilder(
      column: $table.halaqaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekStartKey => $composableBuilder(
      column: $table.weekStartKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get requiredNewPages => $composableBuilder(
      column: $table.requiredNewPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get requiredRecentPages => $composableBuilder(
      column: $table.requiredRecentPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get requiredMinorPages => $composableBuilder(
      column: $table.requiredMinorPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get requiredMajorPages => $composableBuilder(
      column: $table.requiredMajorPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get requiredFridayPages => $composableBuilder(
      column: $table.requiredFridayPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WeeklyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTable> {
  $$WeeklyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get halaqaId =>
      $composableBuilder(column: $table.halaqaId, builder: (column) => column);

  GeneratedColumn<String> get weekStartKey => $composableBuilder(
      column: $table.weekStartKey, builder: (column) => column);

  GeneratedColumn<double> get requiredNewPages => $composableBuilder(
      column: $table.requiredNewPages, builder: (column) => column);

  GeneratedColumn<double> get requiredRecentPages => $composableBuilder(
      column: $table.requiredRecentPages, builder: (column) => column);

  GeneratedColumn<double> get requiredMinorPages => $composableBuilder(
      column: $table.requiredMinorPages, builder: (column) => column);

  GeneratedColumn<double> get requiredMajorPages => $composableBuilder(
      column: $table.requiredMajorPages, builder: (column) => column);

  GeneratedColumn<double> get requiredFridayPages => $composableBuilder(
      column: $table.requiredFridayPages, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WeeklyPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeeklyPlansTable,
    WeeklyPlan,
    $$WeeklyPlansTableFilterComposer,
    $$WeeklyPlansTableOrderingComposer,
    $$WeeklyPlansTableAnnotationComposer,
    $$WeeklyPlansTableCreateCompanionBuilder,
    $$WeeklyPlansTableUpdateCompanionBuilder,
    (WeeklyPlan, BaseReferences<_$AppDatabase, $WeeklyPlansTable, WeeklyPlan>),
    WeeklyPlan,
    PrefetchHooks Function()> {
  $$WeeklyPlansTableTableManager(_$AppDatabase db, $WeeklyPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> halaqaId = const Value.absent(),
            Value<String> weekStartKey = const Value.absent(),
            Value<double> requiredNewPages = const Value.absent(),
            Value<double> requiredRecentPages = const Value.absent(),
            Value<double> requiredMinorPages = const Value.absent(),
            Value<double> requiredMajorPages = const Value.absent(),
            Value<double> requiredFridayPages = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeeklyPlansCompanion(
            id: id,
            studentId: studentId,
            halaqaId: halaqaId,
            weekStartKey: weekStartKey,
            requiredNewPages: requiredNewPages,
            requiredRecentPages: requiredRecentPages,
            requiredMinorPages: requiredMinorPages,
            requiredMajorPages: requiredMajorPages,
            requiredFridayPages: requiredFridayPages,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required String halaqaId,
            required String weekStartKey,
            Value<double> requiredNewPages = const Value.absent(),
            Value<double> requiredRecentPages = const Value.absent(),
            Value<double> requiredMinorPages = const Value.absent(),
            Value<double> requiredMajorPages = const Value.absent(),
            Value<double> requiredFridayPages = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WeeklyPlansCompanion.insert(
            id: id,
            studentId: studentId,
            halaqaId: halaqaId,
            weekStartKey: weekStartKey,
            requiredNewPages: requiredNewPages,
            requiredRecentPages: requiredRecentPages,
            requiredMinorPages: requiredMinorPages,
            requiredMajorPages: requiredMajorPages,
            requiredFridayPages: requiredFridayPages,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeeklyPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeeklyPlansTable,
    WeeklyPlan,
    $$WeeklyPlansTableFilterComposer,
    $$WeeklyPlansTableOrderingComposer,
    $$WeeklyPlansTableAnnotationComposer,
    $$WeeklyPlansTableCreateCompanionBuilder,
    $$WeeklyPlansTableUpdateCompanionBuilder,
    (WeeklyPlan, BaseReferences<_$AppDatabase, $WeeklyPlansTable, WeeklyPlan>),
    WeeklyPlan,
    PrefetchHooks Function()>;
typedef $$StudentTransfersTableCreateCompanionBuilder
    = StudentTransfersCompanion Function({
  required String id,
  required String studentId,
  required String fromHalaqaId,
  required String toHalaqaId,
  required DateTime transferredAt,
  Value<String> byUser,
  Value<int> rowid,
});
typedef $$StudentTransfersTableUpdateCompanionBuilder
    = StudentTransfersCompanion Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> fromHalaqaId,
  Value<String> toHalaqaId,
  Value<DateTime> transferredAt,
  Value<String> byUser,
  Value<int> rowid,
});

class $$StudentTransfersTableFilterComposer
    extends Composer<_$AppDatabase, $StudentTransfersTable> {
  $$StudentTransfersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromHalaqaId => $composableBuilder(
      column: $table.fromHalaqaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toHalaqaId => $composableBuilder(
      column: $table.toHalaqaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transferredAt => $composableBuilder(
      column: $table.transferredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get byUser => $composableBuilder(
      column: $table.byUser, builder: (column) => ColumnFilters(column));
}

class $$StudentTransfersTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentTransfersTable> {
  $$StudentTransfersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentId => $composableBuilder(
      column: $table.studentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromHalaqaId => $composableBuilder(
      column: $table.fromHalaqaId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toHalaqaId => $composableBuilder(
      column: $table.toHalaqaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transferredAt => $composableBuilder(
      column: $table.transferredAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get byUser => $composableBuilder(
      column: $table.byUser, builder: (column) => ColumnOrderings(column));
}

class $$StudentTransfersTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentTransfersTable> {
  $$StudentTransfersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get fromHalaqaId => $composableBuilder(
      column: $table.fromHalaqaId, builder: (column) => column);

  GeneratedColumn<String> get toHalaqaId => $composableBuilder(
      column: $table.toHalaqaId, builder: (column) => column);

  GeneratedColumn<DateTime> get transferredAt => $composableBuilder(
      column: $table.transferredAt, builder: (column) => column);

  GeneratedColumn<String> get byUser =>
      $composableBuilder(column: $table.byUser, builder: (column) => column);
}

class $$StudentTransfersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentTransfersTable,
    StudentTransfer,
    $$StudentTransfersTableFilterComposer,
    $$StudentTransfersTableOrderingComposer,
    $$StudentTransfersTableAnnotationComposer,
    $$StudentTransfersTableCreateCompanionBuilder,
    $$StudentTransfersTableUpdateCompanionBuilder,
    (
      StudentTransfer,
      BaseReferences<_$AppDatabase, $StudentTransfersTable, StudentTransfer>
    ),
    StudentTransfer,
    PrefetchHooks Function()> {
  $$StudentTransfersTableTableManager(
      _$AppDatabase db, $StudentTransfersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentTransfersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentTransfersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentTransfersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> fromHalaqaId = const Value.absent(),
            Value<String> toHalaqaId = const Value.absent(),
            Value<DateTime> transferredAt = const Value.absent(),
            Value<String> byUser = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentTransfersCompanion(
            id: id,
            studentId: studentId,
            fromHalaqaId: fromHalaqaId,
            toHalaqaId: toHalaqaId,
            transferredAt: transferredAt,
            byUser: byUser,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required String fromHalaqaId,
            required String toHalaqaId,
            required DateTime transferredAt,
            Value<String> byUser = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentTransfersCompanion.insert(
            id: id,
            studentId: studentId,
            fromHalaqaId: fromHalaqaId,
            toHalaqaId: toHalaqaId,
            transferredAt: transferredAt,
            byUser: byUser,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentTransfersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentTransfersTable,
    StudentTransfer,
    $$StudentTransfersTableFilterComposer,
    $$StudentTransfersTableOrderingComposer,
    $$StudentTransfersTableAnnotationComposer,
    $$StudentTransfersTableCreateCompanionBuilder,
    $$StudentTransfersTableUpdateCompanionBuilder,
    (
      StudentTransfer,
      BaseReferences<_$AppDatabase, $StudentTransfersTable, StudentTransfer>
    ),
    StudentTransfer,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$HalaqasTableTableManager get halaqas =>
      $$HalaqasTableTableManager(_db, _db.halaqas);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$DailyRecordsTableTableManager get dailyRecords =>
      $$DailyRecordsTableTableManager(_db, _db.dailyRecords);
  $$WeeklyPlansTableTableManager get weeklyPlans =>
      $$WeeklyPlansTableTableManager(_db, _db.weeklyPlans);
  $$StudentTransfersTableTableManager get studentTransfers =>
      $$StudentTransfersTableTableManager(_db, _db.studentTransfers);
}
