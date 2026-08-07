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

class $GuardiansTable extends Guardians
    with TableInfo<$GuardiansTable, Guardian> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuardiansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _relationMeta =
      const VerificationMeta('relation');
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
      'relation', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('والد'));
  static const VerificationMeta _primaryPhoneMeta =
      const VerificationMeta('primaryPhone');
  @override
  late final GeneratedColumn<String> primaryPhone = GeneratedColumn<String>(
      'primary_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _whatsappPhoneMeta =
      const VerificationMeta('whatsappPhone');
  @override
  late final GeneratedColumn<String> whatsappPhone = GeneratedColumn<String>(
      'whatsapp_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _secondaryPhoneMeta =
      const VerificationMeta('secondaryPhone');
  @override
  late final GeneratedColumn<String> secondaryPhone = GeneratedColumn<String>(
      'secondary_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _preferredContactMeta =
      const VerificationMeta('preferredContact');
  @override
  late final GeneratedColumn<String> preferredContact = GeneratedColumn<String>(
      'preferred_contact', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('whatsapp'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fullName,
        relation,
        primaryPhone,
        whatsappPhone,
        secondaryPhone,
        preferredContact,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guardians';
  @override
  VerificationContext validateIntegrity(Insertable<Guardian> instance,
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
    if (data.containsKey('relation')) {
      context.handle(_relationMeta,
          relation.isAcceptableOrUnknown(data['relation']!, _relationMeta));
    }
    if (data.containsKey('primary_phone')) {
      context.handle(
          _primaryPhoneMeta,
          primaryPhone.isAcceptableOrUnknown(
              data['primary_phone']!, _primaryPhoneMeta));
    } else if (isInserting) {
      context.missing(_primaryPhoneMeta);
    }
    if (data.containsKey('whatsapp_phone')) {
      context.handle(
          _whatsappPhoneMeta,
          whatsappPhone.isAcceptableOrUnknown(
              data['whatsapp_phone']!, _whatsappPhoneMeta));
    }
    if (data.containsKey('secondary_phone')) {
      context.handle(
          _secondaryPhoneMeta,
          secondaryPhone.isAcceptableOrUnknown(
              data['secondary_phone']!, _secondaryPhoneMeta));
    }
    if (data.containsKey('preferred_contact')) {
      context.handle(
          _preferredContactMeta,
          preferredContact.isAcceptableOrUnknown(
              data['preferred_contact']!, _preferredContactMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Guardian map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Guardian(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      relation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relation'])!,
      primaryPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}primary_phone'])!,
      whatsappPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp_phone'])!,
      secondaryPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}secondary_phone'])!,
      preferredContact: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_contact'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $GuardiansTable createAlias(String alias) {
    return $GuardiansTable(attachedDatabase, alias);
  }
}

class Guardian extends DataClass implements Insertable<Guardian> {
  final String id;
  final String fullName;
  final String relation;
  final String primaryPhone;
  final String whatsappPhone;
  final String secondaryPhone;
  final String preferredContact;
  final String notes;
  const Guardian(
      {required this.id,
      required this.fullName,
      required this.relation,
      required this.primaryPhone,
      required this.whatsappPhone,
      required this.secondaryPhone,
      required this.preferredContact,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    map['relation'] = Variable<String>(relation);
    map['primary_phone'] = Variable<String>(primaryPhone);
    map['whatsapp_phone'] = Variable<String>(whatsappPhone);
    map['secondary_phone'] = Variable<String>(secondaryPhone);
    map['preferred_contact'] = Variable<String>(preferredContact);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  GuardiansCompanion toCompanion(bool nullToAbsent) {
    return GuardiansCompanion(
      id: Value(id),
      fullName: Value(fullName),
      relation: Value(relation),
      primaryPhone: Value(primaryPhone),
      whatsappPhone: Value(whatsappPhone),
      secondaryPhone: Value(secondaryPhone),
      preferredContact: Value(preferredContact),
      notes: Value(notes),
    );
  }

  factory Guardian.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Guardian(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      relation: serializer.fromJson<String>(json['relation']),
      primaryPhone: serializer.fromJson<String>(json['primaryPhone']),
      whatsappPhone: serializer.fromJson<String>(json['whatsappPhone']),
      secondaryPhone: serializer.fromJson<String>(json['secondaryPhone']),
      preferredContact: serializer.fromJson<String>(json['preferredContact']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'relation': serializer.toJson<String>(relation),
      'primaryPhone': serializer.toJson<String>(primaryPhone),
      'whatsappPhone': serializer.toJson<String>(whatsappPhone),
      'secondaryPhone': serializer.toJson<String>(secondaryPhone),
      'preferredContact': serializer.toJson<String>(preferredContact),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Guardian copyWith(
          {String? id,
          String? fullName,
          String? relation,
          String? primaryPhone,
          String? whatsappPhone,
          String? secondaryPhone,
          String? preferredContact,
          String? notes}) =>
      Guardian(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        relation: relation ?? this.relation,
        primaryPhone: primaryPhone ?? this.primaryPhone,
        whatsappPhone: whatsappPhone ?? this.whatsappPhone,
        secondaryPhone: secondaryPhone ?? this.secondaryPhone,
        preferredContact: preferredContact ?? this.preferredContact,
        notes: notes ?? this.notes,
      );
  Guardian copyWithCompanion(GuardiansCompanion data) {
    return Guardian(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      relation: data.relation.present ? data.relation.value : this.relation,
      primaryPhone: data.primaryPhone.present
          ? data.primaryPhone.value
          : this.primaryPhone,
      whatsappPhone: data.whatsappPhone.present
          ? data.whatsappPhone.value
          : this.whatsappPhone,
      secondaryPhone: data.secondaryPhone.present
          ? data.secondaryPhone.value
          : this.secondaryPhone,
      preferredContact: data.preferredContact.present
          ? data.preferredContact.value
          : this.preferredContact,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Guardian(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('relation: $relation, ')
          ..write('primaryPhone: $primaryPhone, ')
          ..write('whatsappPhone: $whatsappPhone, ')
          ..write('secondaryPhone: $secondaryPhone, ')
          ..write('preferredContact: $preferredContact, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, relation, primaryPhone,
      whatsappPhone, secondaryPhone, preferredContact, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Guardian &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.relation == this.relation &&
          other.primaryPhone == this.primaryPhone &&
          other.whatsappPhone == this.whatsappPhone &&
          other.secondaryPhone == this.secondaryPhone &&
          other.preferredContact == this.preferredContact &&
          other.notes == this.notes);
}

class GuardiansCompanion extends UpdateCompanion<Guardian> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String> relation;
  final Value<String> primaryPhone;
  final Value<String> whatsappPhone;
  final Value<String> secondaryPhone;
  final Value<String> preferredContact;
  final Value<String> notes;
  final Value<int> rowid;
  const GuardiansCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.relation = const Value.absent(),
    this.primaryPhone = const Value.absent(),
    this.whatsappPhone = const Value.absent(),
    this.secondaryPhone = const Value.absent(),
    this.preferredContact = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuardiansCompanion.insert({
    required String id,
    required String fullName,
    this.relation = const Value.absent(),
    required String primaryPhone,
    this.whatsappPhone = const Value.absent(),
    this.secondaryPhone = const Value.absent(),
    this.preferredContact = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fullName = Value(fullName),
        primaryPhone = Value(primaryPhone);
  static Insertable<Guardian> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? relation,
    Expression<String>? primaryPhone,
    Expression<String>? whatsappPhone,
    Expression<String>? secondaryPhone,
    Expression<String>? preferredContact,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (relation != null) 'relation': relation,
      if (primaryPhone != null) 'primary_phone': primaryPhone,
      if (whatsappPhone != null) 'whatsapp_phone': whatsappPhone,
      if (secondaryPhone != null) 'secondary_phone': secondaryPhone,
      if (preferredContact != null) 'preferred_contact': preferredContact,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuardiansCompanion copyWith(
      {Value<String>? id,
      Value<String>? fullName,
      Value<String>? relation,
      Value<String>? primaryPhone,
      Value<String>? whatsappPhone,
      Value<String>? secondaryPhone,
      Value<String>? preferredContact,
      Value<String>? notes,
      Value<int>? rowid}) {
    return GuardiansCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      relation: relation ?? this.relation,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      whatsappPhone: whatsappPhone ?? this.whatsappPhone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      preferredContact: preferredContact ?? this.preferredContact,
      notes: notes ?? this.notes,
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
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (primaryPhone.present) {
      map['primary_phone'] = Variable<String>(primaryPhone.value);
    }
    if (whatsappPhone.present) {
      map['whatsapp_phone'] = Variable<String>(whatsappPhone.value);
    }
    if (secondaryPhone.present) {
      map['secondary_phone'] = Variable<String>(secondaryPhone.value);
    }
    if (preferredContact.present) {
      map['preferred_contact'] = Variable<String>(preferredContact.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuardiansCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('relation: $relation, ')
          ..write('primaryPhone: $primaryPhone, ')
          ..write('whatsappPhone: $whatsappPhone, ')
          ..write('secondaryPhone: $secondaryPhone, ')
          ..write('preferredContact: $preferredContact, ')
          ..write('notes: $notes, ')
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
      type: DriftSqlType.string, requiredDuringInsert: true);
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
    } else if (isInserting) {
      context.missing(_levelMeta);
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
    required String level,
    this.teacherIds = const Value.absent(),
    this.supervisorId = const Value.absent(),
    this.capacity = const Value.absent(),
    this.scheduleDescription = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        level = Value(level);
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
  static const VerificationMeta _guardianIdsMeta =
      const VerificationMeta('guardianIds');
  @override
  late final GeneratedColumn<String> guardianIds = GeneratedColumn<String>(
      'guardian_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
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
        guardianIds,
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
    if (data.containsKey('guardian_ids')) {
      context.handle(
          _guardianIdsMeta,
          guardianIds.isAcceptableOrUnknown(
              data['guardian_ids']!, _guardianIdsMeta));
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
      guardianIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_ids'])!,
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
  final String guardianIds;
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
      required this.guardianIds,
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
    map['guardian_ids'] = Variable<String>(guardianIds);
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
      guardianIds: Value(guardianIds),
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
      guardianIds: serializer.fromJson<String>(json['guardianIds']),
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
      'guardianIds': serializer.toJson<String>(guardianIds),
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
          String? guardianIds,
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
        guardianIds: guardianIds ?? this.guardianIds,
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
      guardianIds:
          data.guardianIds.present ? data.guardianIds.value : this.guardianIds,
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
          ..write('guardianIds: $guardianIds, ')
          ..write('internalNotes: $internalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentCode, fullName, halaqaId, level,
      active, joinDate, guardianIds, internalNotes, createdAt, updatedAt);
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
          other.guardianIds == this.guardianIds &&
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
  final Value<String> guardianIds;
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
    this.guardianIds = const Value.absent(),
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
    this.guardianIds = const Value.absent(),
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
    Expression<String>? guardianIds,
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
      if (guardianIds != null) 'guardian_ids': guardianIds,
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
      Value<String>? guardianIds,
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
      guardianIds: guardianIds ?? this.guardianIds,
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
    if (guardianIds.present) {
      map['guardian_ids'] = Variable<String>(guardianIds.value);
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
          ..write('guardianIds: $guardianIds, ')
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
  static const VerificationMeta _attendanceMeta =
      const VerificationMeta('attendance');
  @override
  late final GeneratedColumn<String> attendance = GeneratedColumn<String>(
      'attendance', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('present'));
  static const VerificationMeta _fromSurahMeta =
      const VerificationMeta('fromSurah');
  @override
  late final GeneratedColumn<String> fromSurah = GeneratedColumn<String>(
      'from_surah', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _fromAyahMeta =
      const VerificationMeta('fromAyah');
  @override
  late final GeneratedColumn<int> fromAyah = GeneratedColumn<int>(
      'from_ayah', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _toSurahMeta =
      const VerificationMeta('toSurah');
  @override
  late final GeneratedColumn<String> toSurah = GeneratedColumn<String>(
      'to_surah', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _toAyahMeta = const VerificationMeta('toAyah');
  @override
  late final GeneratedColumn<int> toAyah = GeneratedColumn<int>(
      'to_ayah', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _estimatedPagesMeta =
      const VerificationMeta('estimatedPages');
  @override
  late final GeneratedColumn<double> estimatedPages = GeneratedColumn<double>(
      'estimated_pages', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _revisionPlannedPagesMeta =
      const VerificationMeta('revisionPlannedPages');
  @override
  late final GeneratedColumn<double> revisionPlannedPages =
      GeneratedColumn<double>('revision_planned_pages', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _revisionCompletedPagesMeta =
      const VerificationMeta('revisionCompletedPages');
  @override
  late final GeneratedColumn<double> revisionCompletedPages =
      GeneratedColumn<double>('revision_completed_pages', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _revisionScoreMeta =
      const VerificationMeta('revisionScore');
  @override
  late final GeneratedColumn<double> revisionScore = GeneratedColumn<double>(
      'revision_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minorErrorsMeta =
      const VerificationMeta('minorErrors');
  @override
  late final GeneratedColumn<int> minorErrors = GeneratedColumn<int>(
      'minor_errors', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _mediumErrorsMeta =
      const VerificationMeta('mediumErrors');
  @override
  late final GeneratedColumn<int> mediumErrors = GeneratedColumn<int>(
      'medium_errors', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _majorErrorsMeta =
      const VerificationMeta('majorErrors');
  @override
  late final GeneratedColumn<int> majorErrors = GeneratedColumn<int>(
      'major_errors', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _selfCorrectionsMeta =
      const VerificationMeta('selfCorrections');
  @override
  late final GeneratedColumn<int> selfCorrections = GeneratedColumn<int>(
      'self_corrections', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _automaticScoreMeta =
      const VerificationMeta('automaticScore');
  @override
  late final GeneratedColumn<double> automaticScore = GeneratedColumn<double>(
      'automatic_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _overrideScoreMeta =
      const VerificationMeta('overrideScore');
  @override
  late final GeneratedColumn<double> overrideScore = GeneratedColumn<double>(
      'override_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _overrideReasonMeta =
      const VerificationMeta('overrideReason');
  @override
  late final GeneratedColumn<String> overrideReason = GeneratedColumn<String>(
      'override_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _homeworkStatusMeta =
      const VerificationMeta('homeworkStatus');
  @override
  late final GeneratedColumn<String> homeworkStatus = GeneratedColumn<String>(
      'homework_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _homeworkScoreMeta =
      const VerificationMeta('homeworkScore');
  @override
  late final GeneratedColumn<double> homeworkScore = GeneratedColumn<double>(
      'homework_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _finalScoreMeta =
      const VerificationMeta('finalScore');
  @override
  late final GeneratedColumn<double> finalScore = GeneratedColumn<double>(
      'final_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('good'));
  static const VerificationMeta _internalNoteMeta =
      const VerificationMeta('internalNote');
  @override
  late final GeneratedColumn<String> internalNote = GeneratedColumn<String>(
      'internal_note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _needsFollowUpMeta =
      const VerificationMeta('needsFollowUp');
  @override
  late final GeneratedColumn<bool> needsFollowUp = GeneratedColumn<bool>(
      'needs_follow_up', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("needs_follow_up" IN (0, 1))'),
      defaultValue: const Constant(false));
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
        attendance,
        fromSurah,
        fromAyah,
        toSurah,
        toAyah,
        estimatedPages,
        revisionPlannedPages,
        revisionCompletedPages,
        revisionScore,
        minorErrors,
        mediumErrors,
        majorErrors,
        selfCorrections,
        automaticScore,
        overrideScore,
        overrideReason,
        homeworkStatus,
        homeworkScore,
        finalScore,
        level,
        internalNote,
        needsFollowUp,
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
    if (data.containsKey('attendance')) {
      context.handle(
          _attendanceMeta,
          attendance.isAcceptableOrUnknown(
              data['attendance']!, _attendanceMeta));
    }
    if (data.containsKey('from_surah')) {
      context.handle(_fromSurahMeta,
          fromSurah.isAcceptableOrUnknown(data['from_surah']!, _fromSurahMeta));
    }
    if (data.containsKey('from_ayah')) {
      context.handle(_fromAyahMeta,
          fromAyah.isAcceptableOrUnknown(data['from_ayah']!, _fromAyahMeta));
    }
    if (data.containsKey('to_surah')) {
      context.handle(_toSurahMeta,
          toSurah.isAcceptableOrUnknown(data['to_surah']!, _toSurahMeta));
    }
    if (data.containsKey('to_ayah')) {
      context.handle(_toAyahMeta,
          toAyah.isAcceptableOrUnknown(data['to_ayah']!, _toAyahMeta));
    }
    if (data.containsKey('estimated_pages')) {
      context.handle(
          _estimatedPagesMeta,
          estimatedPages.isAcceptableOrUnknown(
              data['estimated_pages']!, _estimatedPagesMeta));
    }
    if (data.containsKey('revision_planned_pages')) {
      context.handle(
          _revisionPlannedPagesMeta,
          revisionPlannedPages.isAcceptableOrUnknown(
              data['revision_planned_pages']!, _revisionPlannedPagesMeta));
    }
    if (data.containsKey('revision_completed_pages')) {
      context.handle(
          _revisionCompletedPagesMeta,
          revisionCompletedPages.isAcceptableOrUnknown(
              data['revision_completed_pages']!, _revisionCompletedPagesMeta));
    }
    if (data.containsKey('revision_score')) {
      context.handle(
          _revisionScoreMeta,
          revisionScore.isAcceptableOrUnknown(
              data['revision_score']!, _revisionScoreMeta));
    }
    if (data.containsKey('minor_errors')) {
      context.handle(
          _minorErrorsMeta,
          minorErrors.isAcceptableOrUnknown(
              data['minor_errors']!, _minorErrorsMeta));
    }
    if (data.containsKey('medium_errors')) {
      context.handle(
          _mediumErrorsMeta,
          mediumErrors.isAcceptableOrUnknown(
              data['medium_errors']!, _mediumErrorsMeta));
    }
    if (data.containsKey('major_errors')) {
      context.handle(
          _majorErrorsMeta,
          majorErrors.isAcceptableOrUnknown(
              data['major_errors']!, _majorErrorsMeta));
    }
    if (data.containsKey('self_corrections')) {
      context.handle(
          _selfCorrectionsMeta,
          selfCorrections.isAcceptableOrUnknown(
              data['self_corrections']!, _selfCorrectionsMeta));
    }
    if (data.containsKey('automatic_score')) {
      context.handle(
          _automaticScoreMeta,
          automaticScore.isAcceptableOrUnknown(
              data['automatic_score']!, _automaticScoreMeta));
    }
    if (data.containsKey('override_score')) {
      context.handle(
          _overrideScoreMeta,
          overrideScore.isAcceptableOrUnknown(
              data['override_score']!, _overrideScoreMeta));
    }
    if (data.containsKey('override_reason')) {
      context.handle(
          _overrideReasonMeta,
          overrideReason.isAcceptableOrUnknown(
              data['override_reason']!, _overrideReasonMeta));
    }
    if (data.containsKey('homework_status')) {
      context.handle(
          _homeworkStatusMeta,
          homeworkStatus.isAcceptableOrUnknown(
              data['homework_status']!, _homeworkStatusMeta));
    }
    if (data.containsKey('homework_score')) {
      context.handle(
          _homeworkScoreMeta,
          homeworkScore.isAcceptableOrUnknown(
              data['homework_score']!, _homeworkScoreMeta));
    }
    if (data.containsKey('final_score')) {
      context.handle(
          _finalScoreMeta,
          finalScore.isAcceptableOrUnknown(
              data['final_score']!, _finalScoreMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('internal_note')) {
      context.handle(
          _internalNoteMeta,
          internalNote.isAcceptableOrUnknown(
              data['internal_note']!, _internalNoteMeta));
    }
    if (data.containsKey('needs_follow_up')) {
      context.handle(
          _needsFollowUpMeta,
          needsFollowUp.isAcceptableOrUnknown(
              data['needs_follow_up']!, _needsFollowUpMeta));
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
      attendance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attendance'])!,
      fromSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_surah'])!,
      fromAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_ayah'])!,
      toSurah: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_surah'])!,
      toAyah: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_ayah'])!,
      estimatedPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}estimated_pages'])!,
      revisionPlannedPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}revision_planned_pages'])!,
      revisionCompletedPages: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}revision_completed_pages'])!,
      revisionScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}revision_score'])!,
      minorErrors: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minor_errors'])!,
      mediumErrors: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}medium_errors'])!,
      majorErrors: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}major_errors'])!,
      selfCorrections: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}self_corrections'])!,
      automaticScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}automatic_score'])!,
      overrideScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}override_score']),
      overrideReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}override_reason']),
      homeworkStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}homework_status'])!,
      homeworkScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}homework_score'])!,
      finalScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}final_score'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      internalNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}internal_note'])!,
      needsFollowUp: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}needs_follow_up'])!,
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
  final String attendance;
  final String fromSurah;
  final int fromAyah;
  final String toSurah;
  final int toAyah;
  final double estimatedPages;
  final double revisionPlannedPages;
  final double revisionCompletedPages;
  final double revisionScore;
  final int minorErrors;
  final int mediumErrors;
  final int majorErrors;
  final int selfCorrections;
  final double automaticScore;
  final double? overrideScore;
  final String? overrideReason;
  final String homeworkStatus;
  final double homeworkScore;
  final double finalScore;
  final String level;
  final String internalNote;
  final bool needsFollowUp;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyRecord(
      {required this.id,
      required this.studentId,
      required this.halaqaId,
      required this.teacherId,
      required this.date,
      required this.dateKey,
      required this.attendance,
      required this.fromSurah,
      required this.fromAyah,
      required this.toSurah,
      required this.toAyah,
      required this.estimatedPages,
      required this.revisionPlannedPages,
      required this.revisionCompletedPages,
      required this.revisionScore,
      required this.minorErrors,
      required this.mediumErrors,
      required this.majorErrors,
      required this.selfCorrections,
      required this.automaticScore,
      this.overrideScore,
      this.overrideReason,
      required this.homeworkStatus,
      required this.homeworkScore,
      required this.finalScore,
      required this.level,
      required this.internalNote,
      required this.needsFollowUp,
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
    map['attendance'] = Variable<String>(attendance);
    map['from_surah'] = Variable<String>(fromSurah);
    map['from_ayah'] = Variable<int>(fromAyah);
    map['to_surah'] = Variable<String>(toSurah);
    map['to_ayah'] = Variable<int>(toAyah);
    map['estimated_pages'] = Variable<double>(estimatedPages);
    map['revision_planned_pages'] = Variable<double>(revisionPlannedPages);
    map['revision_completed_pages'] = Variable<double>(revisionCompletedPages);
    map['revision_score'] = Variable<double>(revisionScore);
    map['minor_errors'] = Variable<int>(minorErrors);
    map['medium_errors'] = Variable<int>(mediumErrors);
    map['major_errors'] = Variable<int>(majorErrors);
    map['self_corrections'] = Variable<int>(selfCorrections);
    map['automatic_score'] = Variable<double>(automaticScore);
    if (!nullToAbsent || overrideScore != null) {
      map['override_score'] = Variable<double>(overrideScore);
    }
    if (!nullToAbsent || overrideReason != null) {
      map['override_reason'] = Variable<String>(overrideReason);
    }
    map['homework_status'] = Variable<String>(homeworkStatus);
    map['homework_score'] = Variable<double>(homeworkScore);
    map['final_score'] = Variable<double>(finalScore);
    map['level'] = Variable<String>(level);
    map['internal_note'] = Variable<String>(internalNote);
    map['needs_follow_up'] = Variable<bool>(needsFollowUp);
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
      attendance: Value(attendance),
      fromSurah: Value(fromSurah),
      fromAyah: Value(fromAyah),
      toSurah: Value(toSurah),
      toAyah: Value(toAyah),
      estimatedPages: Value(estimatedPages),
      revisionPlannedPages: Value(revisionPlannedPages),
      revisionCompletedPages: Value(revisionCompletedPages),
      revisionScore: Value(revisionScore),
      minorErrors: Value(minorErrors),
      mediumErrors: Value(mediumErrors),
      majorErrors: Value(majorErrors),
      selfCorrections: Value(selfCorrections),
      automaticScore: Value(automaticScore),
      overrideScore: overrideScore == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideScore),
      overrideReason: overrideReason == null && nullToAbsent
          ? const Value.absent()
          : Value(overrideReason),
      homeworkStatus: Value(homeworkStatus),
      homeworkScore: Value(homeworkScore),
      finalScore: Value(finalScore),
      level: Value(level),
      internalNote: Value(internalNote),
      needsFollowUp: Value(needsFollowUp),
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
      attendance: serializer.fromJson<String>(json['attendance']),
      fromSurah: serializer.fromJson<String>(json['fromSurah']),
      fromAyah: serializer.fromJson<int>(json['fromAyah']),
      toSurah: serializer.fromJson<String>(json['toSurah']),
      toAyah: serializer.fromJson<int>(json['toAyah']),
      estimatedPages: serializer.fromJson<double>(json['estimatedPages']),
      revisionPlannedPages:
          serializer.fromJson<double>(json['revisionPlannedPages']),
      revisionCompletedPages:
          serializer.fromJson<double>(json['revisionCompletedPages']),
      revisionScore: serializer.fromJson<double>(json['revisionScore']),
      minorErrors: serializer.fromJson<int>(json['minorErrors']),
      mediumErrors: serializer.fromJson<int>(json['mediumErrors']),
      majorErrors: serializer.fromJson<int>(json['majorErrors']),
      selfCorrections: serializer.fromJson<int>(json['selfCorrections']),
      automaticScore: serializer.fromJson<double>(json['automaticScore']),
      overrideScore: serializer.fromJson<double?>(json['overrideScore']),
      overrideReason: serializer.fromJson<String?>(json['overrideReason']),
      homeworkStatus: serializer.fromJson<String>(json['homeworkStatus']),
      homeworkScore: serializer.fromJson<double>(json['homeworkScore']),
      finalScore: serializer.fromJson<double>(json['finalScore']),
      level: serializer.fromJson<String>(json['level']),
      internalNote: serializer.fromJson<String>(json['internalNote']),
      needsFollowUp: serializer.fromJson<bool>(json['needsFollowUp']),
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
      'attendance': serializer.toJson<String>(attendance),
      'fromSurah': serializer.toJson<String>(fromSurah),
      'fromAyah': serializer.toJson<int>(fromAyah),
      'toSurah': serializer.toJson<String>(toSurah),
      'toAyah': serializer.toJson<int>(toAyah),
      'estimatedPages': serializer.toJson<double>(estimatedPages),
      'revisionPlannedPages': serializer.toJson<double>(revisionPlannedPages),
      'revisionCompletedPages':
          serializer.toJson<double>(revisionCompletedPages),
      'revisionScore': serializer.toJson<double>(revisionScore),
      'minorErrors': serializer.toJson<int>(minorErrors),
      'mediumErrors': serializer.toJson<int>(mediumErrors),
      'majorErrors': serializer.toJson<int>(majorErrors),
      'selfCorrections': serializer.toJson<int>(selfCorrections),
      'automaticScore': serializer.toJson<double>(automaticScore),
      'overrideScore': serializer.toJson<double?>(overrideScore),
      'overrideReason': serializer.toJson<String?>(overrideReason),
      'homeworkStatus': serializer.toJson<String>(homeworkStatus),
      'homeworkScore': serializer.toJson<double>(homeworkScore),
      'finalScore': serializer.toJson<double>(finalScore),
      'level': serializer.toJson<String>(level),
      'internalNote': serializer.toJson<String>(internalNote),
      'needsFollowUp': serializer.toJson<bool>(needsFollowUp),
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
          String? attendance,
          String? fromSurah,
          int? fromAyah,
          String? toSurah,
          int? toAyah,
          double? estimatedPages,
          double? revisionPlannedPages,
          double? revisionCompletedPages,
          double? revisionScore,
          int? minorErrors,
          int? mediumErrors,
          int? majorErrors,
          int? selfCorrections,
          double? automaticScore,
          Value<double?> overrideScore = const Value.absent(),
          Value<String?> overrideReason = const Value.absent(),
          String? homeworkStatus,
          double? homeworkScore,
          double? finalScore,
          String? level,
          String? internalNote,
          bool? needsFollowUp,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DailyRecord(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        halaqaId: halaqaId ?? this.halaqaId,
        teacherId: teacherId ?? this.teacherId,
        date: date ?? this.date,
        dateKey: dateKey ?? this.dateKey,
        attendance: attendance ?? this.attendance,
        fromSurah: fromSurah ?? this.fromSurah,
        fromAyah: fromAyah ?? this.fromAyah,
        toSurah: toSurah ?? this.toSurah,
        toAyah: toAyah ?? this.toAyah,
        estimatedPages: estimatedPages ?? this.estimatedPages,
        revisionPlannedPages: revisionPlannedPages ?? this.revisionPlannedPages,
        revisionCompletedPages:
            revisionCompletedPages ?? this.revisionCompletedPages,
        revisionScore: revisionScore ?? this.revisionScore,
        minorErrors: minorErrors ?? this.minorErrors,
        mediumErrors: mediumErrors ?? this.mediumErrors,
        majorErrors: majorErrors ?? this.majorErrors,
        selfCorrections: selfCorrections ?? this.selfCorrections,
        automaticScore: automaticScore ?? this.automaticScore,
        overrideScore:
            overrideScore.present ? overrideScore.value : this.overrideScore,
        overrideReason:
            overrideReason.present ? overrideReason.value : this.overrideReason,
        homeworkStatus: homeworkStatus ?? this.homeworkStatus,
        homeworkScore: homeworkScore ?? this.homeworkScore,
        finalScore: finalScore ?? this.finalScore,
        level: level ?? this.level,
        internalNote: internalNote ?? this.internalNote,
        needsFollowUp: needsFollowUp ?? this.needsFollowUp,
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
      attendance:
          data.attendance.present ? data.attendance.value : this.attendance,
      fromSurah: data.fromSurah.present ? data.fromSurah.value : this.fromSurah,
      fromAyah: data.fromAyah.present ? data.fromAyah.value : this.fromAyah,
      toSurah: data.toSurah.present ? data.toSurah.value : this.toSurah,
      toAyah: data.toAyah.present ? data.toAyah.value : this.toAyah,
      estimatedPages: data.estimatedPages.present
          ? data.estimatedPages.value
          : this.estimatedPages,
      revisionPlannedPages: data.revisionPlannedPages.present
          ? data.revisionPlannedPages.value
          : this.revisionPlannedPages,
      revisionCompletedPages: data.revisionCompletedPages.present
          ? data.revisionCompletedPages.value
          : this.revisionCompletedPages,
      revisionScore: data.revisionScore.present
          ? data.revisionScore.value
          : this.revisionScore,
      minorErrors:
          data.minorErrors.present ? data.minorErrors.value : this.minorErrors,
      mediumErrors: data.mediumErrors.present
          ? data.mediumErrors.value
          : this.mediumErrors,
      majorErrors:
          data.majorErrors.present ? data.majorErrors.value : this.majorErrors,
      selfCorrections: data.selfCorrections.present
          ? data.selfCorrections.value
          : this.selfCorrections,
      automaticScore: data.automaticScore.present
          ? data.automaticScore.value
          : this.automaticScore,
      overrideScore: data.overrideScore.present
          ? data.overrideScore.value
          : this.overrideScore,
      overrideReason: data.overrideReason.present
          ? data.overrideReason.value
          : this.overrideReason,
      homeworkStatus: data.homeworkStatus.present
          ? data.homeworkStatus.value
          : this.homeworkStatus,
      homeworkScore: data.homeworkScore.present
          ? data.homeworkScore.value
          : this.homeworkScore,
      finalScore:
          data.finalScore.present ? data.finalScore.value : this.finalScore,
      level: data.level.present ? data.level.value : this.level,
      internalNote: data.internalNote.present
          ? data.internalNote.value
          : this.internalNote,
      needsFollowUp: data.needsFollowUp.present
          ? data.needsFollowUp.value
          : this.needsFollowUp,
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
          ..write('attendance: $attendance, ')
          ..write('fromSurah: $fromSurah, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toSurah: $toSurah, ')
          ..write('toAyah: $toAyah, ')
          ..write('estimatedPages: $estimatedPages, ')
          ..write('revisionPlannedPages: $revisionPlannedPages, ')
          ..write('revisionCompletedPages: $revisionCompletedPages, ')
          ..write('revisionScore: $revisionScore, ')
          ..write('minorErrors: $minorErrors, ')
          ..write('mediumErrors: $mediumErrors, ')
          ..write('majorErrors: $majorErrors, ')
          ..write('selfCorrections: $selfCorrections, ')
          ..write('automaticScore: $automaticScore, ')
          ..write('overrideScore: $overrideScore, ')
          ..write('overrideReason: $overrideReason, ')
          ..write('homeworkStatus: $homeworkStatus, ')
          ..write('homeworkScore: $homeworkScore, ')
          ..write('finalScore: $finalScore, ')
          ..write('level: $level, ')
          ..write('internalNote: $internalNote, ')
          ..write('needsFollowUp: $needsFollowUp, ')
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
        attendance,
        fromSurah,
        fromAyah,
        toSurah,
        toAyah,
        estimatedPages,
        revisionPlannedPages,
        revisionCompletedPages,
        revisionScore,
        minorErrors,
        mediumErrors,
        majorErrors,
        selfCorrections,
        automaticScore,
        overrideScore,
        overrideReason,
        homeworkStatus,
        homeworkScore,
        finalScore,
        level,
        internalNote,
        needsFollowUp,
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
          other.attendance == this.attendance &&
          other.fromSurah == this.fromSurah &&
          other.fromAyah == this.fromAyah &&
          other.toSurah == this.toSurah &&
          other.toAyah == this.toAyah &&
          other.estimatedPages == this.estimatedPages &&
          other.revisionPlannedPages == this.revisionPlannedPages &&
          other.revisionCompletedPages == this.revisionCompletedPages &&
          other.revisionScore == this.revisionScore &&
          other.minorErrors == this.minorErrors &&
          other.mediumErrors == this.mediumErrors &&
          other.majorErrors == this.majorErrors &&
          other.selfCorrections == this.selfCorrections &&
          other.automaticScore == this.automaticScore &&
          other.overrideScore == this.overrideScore &&
          other.overrideReason == this.overrideReason &&
          other.homeworkStatus == this.homeworkStatus &&
          other.homeworkScore == this.homeworkScore &&
          other.finalScore == this.finalScore &&
          other.level == this.level &&
          other.internalNote == this.internalNote &&
          other.needsFollowUp == this.needsFollowUp &&
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
  final Value<String> attendance;
  final Value<String> fromSurah;
  final Value<int> fromAyah;
  final Value<String> toSurah;
  final Value<int> toAyah;
  final Value<double> estimatedPages;
  final Value<double> revisionPlannedPages;
  final Value<double> revisionCompletedPages;
  final Value<double> revisionScore;
  final Value<int> minorErrors;
  final Value<int> mediumErrors;
  final Value<int> majorErrors;
  final Value<int> selfCorrections;
  final Value<double> automaticScore;
  final Value<double?> overrideScore;
  final Value<String?> overrideReason;
  final Value<String> homeworkStatus;
  final Value<double> homeworkScore;
  final Value<double> finalScore;
  final Value<String> level;
  final Value<String> internalNote;
  final Value<bool> needsFollowUp;
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
    this.attendance = const Value.absent(),
    this.fromSurah = const Value.absent(),
    this.fromAyah = const Value.absent(),
    this.toSurah = const Value.absent(),
    this.toAyah = const Value.absent(),
    this.estimatedPages = const Value.absent(),
    this.revisionPlannedPages = const Value.absent(),
    this.revisionCompletedPages = const Value.absent(),
    this.revisionScore = const Value.absent(),
    this.minorErrors = const Value.absent(),
    this.mediumErrors = const Value.absent(),
    this.majorErrors = const Value.absent(),
    this.selfCorrections = const Value.absent(),
    this.automaticScore = const Value.absent(),
    this.overrideScore = const Value.absent(),
    this.overrideReason = const Value.absent(),
    this.homeworkStatus = const Value.absent(),
    this.homeworkScore = const Value.absent(),
    this.finalScore = const Value.absent(),
    this.level = const Value.absent(),
    this.internalNote = const Value.absent(),
    this.needsFollowUp = const Value.absent(),
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
    this.attendance = const Value.absent(),
    this.fromSurah = const Value.absent(),
    this.fromAyah = const Value.absent(),
    this.toSurah = const Value.absent(),
    this.toAyah = const Value.absent(),
    this.estimatedPages = const Value.absent(),
    this.revisionPlannedPages = const Value.absent(),
    this.revisionCompletedPages = const Value.absent(),
    this.revisionScore = const Value.absent(),
    this.minorErrors = const Value.absent(),
    this.mediumErrors = const Value.absent(),
    this.majorErrors = const Value.absent(),
    this.selfCorrections = const Value.absent(),
    this.automaticScore = const Value.absent(),
    this.overrideScore = const Value.absent(),
    this.overrideReason = const Value.absent(),
    this.homeworkStatus = const Value.absent(),
    this.homeworkScore = const Value.absent(),
    this.finalScore = const Value.absent(),
    this.level = const Value.absent(),
    this.internalNote = const Value.absent(),
    this.needsFollowUp = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        halaqaId = Value(halaqaId),
        date = Value(date),
        dateKey = Value(dateKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DailyRecord> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? halaqaId,
    Expression<String>? teacherId,
    Expression<DateTime>? date,
    Expression<String>? dateKey,
    Expression<String>? attendance,
    Expression<String>? fromSurah,
    Expression<int>? fromAyah,
    Expression<String>? toSurah,
    Expression<int>? toAyah,
    Expression<double>? estimatedPages,
    Expression<double>? revisionPlannedPages,
    Expression<double>? revisionCompletedPages,
    Expression<double>? revisionScore,
    Expression<int>? minorErrors,
    Expression<int>? mediumErrors,
    Expression<int>? majorErrors,
    Expression<int>? selfCorrections,
    Expression<double>? automaticScore,
    Expression<double>? overrideScore,
    Expression<String>? overrideReason,
    Expression<String>? homeworkStatus,
    Expression<double>? homeworkScore,
    Expression<double>? finalScore,
    Expression<String>? level,
    Expression<String>? internalNote,
    Expression<bool>? needsFollowUp,
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
      if (attendance != null) 'attendance': attendance,
      if (fromSurah != null) 'from_surah': fromSurah,
      if (fromAyah != null) 'from_ayah': fromAyah,
      if (toSurah != null) 'to_surah': toSurah,
      if (toAyah != null) 'to_ayah': toAyah,
      if (estimatedPages != null) 'estimated_pages': estimatedPages,
      if (revisionPlannedPages != null)
        'revision_planned_pages': revisionPlannedPages,
      if (revisionCompletedPages != null)
        'revision_completed_pages': revisionCompletedPages,
      if (revisionScore != null) 'revision_score': revisionScore,
      if (minorErrors != null) 'minor_errors': minorErrors,
      if (mediumErrors != null) 'medium_errors': mediumErrors,
      if (majorErrors != null) 'major_errors': majorErrors,
      if (selfCorrections != null) 'self_corrections': selfCorrections,
      if (automaticScore != null) 'automatic_score': automaticScore,
      if (overrideScore != null) 'override_score': overrideScore,
      if (overrideReason != null) 'override_reason': overrideReason,
      if (homeworkStatus != null) 'homework_status': homeworkStatus,
      if (homeworkScore != null) 'homework_score': homeworkScore,
      if (finalScore != null) 'final_score': finalScore,
      if (level != null) 'level': level,
      if (internalNote != null) 'internal_note': internalNote,
      if (needsFollowUp != null) 'needs_follow_up': needsFollowUp,
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
      Value<String>? attendance,
      Value<String>? fromSurah,
      Value<int>? fromAyah,
      Value<String>? toSurah,
      Value<int>? toAyah,
      Value<double>? estimatedPages,
      Value<double>? revisionPlannedPages,
      Value<double>? revisionCompletedPages,
      Value<double>? revisionScore,
      Value<int>? minorErrors,
      Value<int>? mediumErrors,
      Value<int>? majorErrors,
      Value<int>? selfCorrections,
      Value<double>? automaticScore,
      Value<double?>? overrideScore,
      Value<String?>? overrideReason,
      Value<String>? homeworkStatus,
      Value<double>? homeworkScore,
      Value<double>? finalScore,
      Value<String>? level,
      Value<String>? internalNote,
      Value<bool>? needsFollowUp,
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
      attendance: attendance ?? this.attendance,
      fromSurah: fromSurah ?? this.fromSurah,
      fromAyah: fromAyah ?? this.fromAyah,
      toSurah: toSurah ?? this.toSurah,
      toAyah: toAyah ?? this.toAyah,
      estimatedPages: estimatedPages ?? this.estimatedPages,
      revisionPlannedPages: revisionPlannedPages ?? this.revisionPlannedPages,
      revisionCompletedPages:
          revisionCompletedPages ?? this.revisionCompletedPages,
      revisionScore: revisionScore ?? this.revisionScore,
      minorErrors: minorErrors ?? this.minorErrors,
      mediumErrors: mediumErrors ?? this.mediumErrors,
      majorErrors: majorErrors ?? this.majorErrors,
      selfCorrections: selfCorrections ?? this.selfCorrections,
      automaticScore: automaticScore ?? this.automaticScore,
      overrideScore: overrideScore ?? this.overrideScore,
      overrideReason: overrideReason ?? this.overrideReason,
      homeworkStatus: homeworkStatus ?? this.homeworkStatus,
      homeworkScore: homeworkScore ?? this.homeworkScore,
      finalScore: finalScore ?? this.finalScore,
      level: level ?? this.level,
      internalNote: internalNote ?? this.internalNote,
      needsFollowUp: needsFollowUp ?? this.needsFollowUp,
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
    if (attendance.present) {
      map['attendance'] = Variable<String>(attendance.value);
    }
    if (fromSurah.present) {
      map['from_surah'] = Variable<String>(fromSurah.value);
    }
    if (fromAyah.present) {
      map['from_ayah'] = Variable<int>(fromAyah.value);
    }
    if (toSurah.present) {
      map['to_surah'] = Variable<String>(toSurah.value);
    }
    if (toAyah.present) {
      map['to_ayah'] = Variable<int>(toAyah.value);
    }
    if (estimatedPages.present) {
      map['estimated_pages'] = Variable<double>(estimatedPages.value);
    }
    if (revisionPlannedPages.present) {
      map['revision_planned_pages'] =
          Variable<double>(revisionPlannedPages.value);
    }
    if (revisionCompletedPages.present) {
      map['revision_completed_pages'] =
          Variable<double>(revisionCompletedPages.value);
    }
    if (revisionScore.present) {
      map['revision_score'] = Variable<double>(revisionScore.value);
    }
    if (minorErrors.present) {
      map['minor_errors'] = Variable<int>(minorErrors.value);
    }
    if (mediumErrors.present) {
      map['medium_errors'] = Variable<int>(mediumErrors.value);
    }
    if (majorErrors.present) {
      map['major_errors'] = Variable<int>(majorErrors.value);
    }
    if (selfCorrections.present) {
      map['self_corrections'] = Variable<int>(selfCorrections.value);
    }
    if (automaticScore.present) {
      map['automatic_score'] = Variable<double>(automaticScore.value);
    }
    if (overrideScore.present) {
      map['override_score'] = Variable<double>(overrideScore.value);
    }
    if (overrideReason.present) {
      map['override_reason'] = Variable<String>(overrideReason.value);
    }
    if (homeworkStatus.present) {
      map['homework_status'] = Variable<String>(homeworkStatus.value);
    }
    if (homeworkScore.present) {
      map['homework_score'] = Variable<double>(homeworkScore.value);
    }
    if (finalScore.present) {
      map['final_score'] = Variable<double>(finalScore.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (internalNote.present) {
      map['internal_note'] = Variable<String>(internalNote.value);
    }
    if (needsFollowUp.present) {
      map['needs_follow_up'] = Variable<bool>(needsFollowUp.value);
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
          ..write('attendance: $attendance, ')
          ..write('fromSurah: $fromSurah, ')
          ..write('fromAyah: $fromAyah, ')
          ..write('toSurah: $toSurah, ')
          ..write('toAyah: $toAyah, ')
          ..write('estimatedPages: $estimatedPages, ')
          ..write('revisionPlannedPages: $revisionPlannedPages, ')
          ..write('revisionCompletedPages: $revisionCompletedPages, ')
          ..write('revisionScore: $revisionScore, ')
          ..write('minorErrors: $minorErrors, ')
          ..write('mediumErrors: $mediumErrors, ')
          ..write('majorErrors: $majorErrors, ')
          ..write('selfCorrections: $selfCorrections, ')
          ..write('automaticScore: $automaticScore, ')
          ..write('overrideScore: $overrideScore, ')
          ..write('overrideReason: $overrideReason, ')
          ..write('homeworkStatus: $homeworkStatus, ')
          ..write('homeworkScore: $homeworkScore, ')
          ..write('finalScore: $finalScore, ')
          ..write('level: $level, ')
          ..write('internalNote: $internalNote, ')
          ..write('needsFollowUp: $needsFollowUp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FollowUpPlansTable extends FollowUpPlans
    with TableInfo<$FollowUpPlansTable, FollowUpPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FollowUpPlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _goalsMeta = const VerificationMeta('goals');
  @override
  late final GeneratedColumn<String> goals = GeneratedColumn<String>(
      'goals', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _actionsMeta =
      const VerificationMeta('actions');
  @override
  late final GeneratedColumn<String> actions = GeneratedColumn<String>(
      'actions', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        createdBy,
        startDate,
        endDate,
        goals,
        actions,
        status,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'follow_up_plans';
  @override
  VerificationContext validateIntegrity(Insertable<FollowUpPlan> instance,
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
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('goals')) {
      context.handle(
          _goalsMeta, goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta));
    }
    if (data.containsKey('actions')) {
      context.handle(_actionsMeta,
          actions.isAcceptableOrUnknown(data['actions']!, _actionsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FollowUpPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FollowUpPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      goals: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goals'])!,
      actions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actions'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $FollowUpPlansTable createAlias(String alias) {
    return $FollowUpPlansTable(attachedDatabase, alias);
  }
}

class FollowUpPlan extends DataClass implements Insertable<FollowUpPlan> {
  final String id;
  final String studentId;
  final String createdBy;
  final DateTime startDate;
  final DateTime? endDate;
  final String goals;
  final String actions;
  final String status;
  final String notes;
  const FollowUpPlan(
      {required this.id,
      required this.studentId,
      required this.createdBy,
      required this.startDate,
      this.endDate,
      required this.goals,
      required this.actions,
      required this.status,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['created_by'] = Variable<String>(createdBy);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['goals'] = Variable<String>(goals);
    map['actions'] = Variable<String>(actions);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  FollowUpPlansCompanion toCompanion(bool nullToAbsent) {
    return FollowUpPlansCompanion(
      id: Value(id),
      studentId: Value(studentId),
      createdBy: Value(createdBy),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      goals: Value(goals),
      actions: Value(actions),
      status: Value(status),
      notes: Value(notes),
    );
  }

  factory FollowUpPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FollowUpPlan(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      goals: serializer.fromJson<String>(json['goals']),
      actions: serializer.fromJson<String>(json['actions']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'createdBy': serializer.toJson<String>(createdBy),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'goals': serializer.toJson<String>(goals),
      'actions': serializer.toJson<String>(actions),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
    };
  }

  FollowUpPlan copyWith(
          {String? id,
          String? studentId,
          String? createdBy,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          String? goals,
          String? actions,
          String? status,
          String? notes}) =>
      FollowUpPlan(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        createdBy: createdBy ?? this.createdBy,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        goals: goals ?? this.goals,
        actions: actions ?? this.actions,
        status: status ?? this.status,
        notes: notes ?? this.notes,
      );
  FollowUpPlan copyWithCompanion(FollowUpPlansCompanion data) {
    return FollowUpPlan(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      goals: data.goals.present ? data.goals.value : this.goals,
      actions: data.actions.present ? data.actions.value : this.actions,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FollowUpPlan(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('createdBy: $createdBy, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('goals: $goals, ')
          ..write('actions: $actions, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, createdBy, startDate, endDate,
      goals, actions, status, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FollowUpPlan &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.createdBy == this.createdBy &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.goals == this.goals &&
          other.actions == this.actions &&
          other.status == this.status &&
          other.notes == this.notes);
}

class FollowUpPlansCompanion extends UpdateCompanion<FollowUpPlan> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> createdBy;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> goals;
  final Value<String> actions;
  final Value<String> status;
  final Value<String> notes;
  final Value<int> rowid;
  const FollowUpPlansCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.goals = const Value.absent(),
    this.actions = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FollowUpPlansCompanion.insert({
    required String id,
    required String studentId,
    required String createdBy,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.goals = const Value.absent(),
    this.actions = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        createdBy = Value(createdBy),
        startDate = Value(startDate);
  static Insertable<FollowUpPlan> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? createdBy,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? goals,
    Expression<String>? actions,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (createdBy != null) 'created_by': createdBy,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (goals != null) 'goals': goals,
      if (actions != null) 'actions': actions,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FollowUpPlansCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<String>? createdBy,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<String>? goals,
      Value<String>? actions,
      Value<String>? status,
      Value<String>? notes,
      Value<int>? rowid}) {
    return FollowUpPlansCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      createdBy: createdBy ?? this.createdBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      goals: goals ?? this.goals,
      actions: actions ?? this.actions,
      status: status ?? this.status,
      notes: notes ?? this.notes,
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
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (actions.present) {
      map['actions'] = Variable<String>(actions.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowUpPlansCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('createdBy: $createdBy, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('goals: $goals, ')
          ..write('actions: $actions, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, Alert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normal'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingReview'));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _reviewedByMeta =
      const VerificationMeta('reviewedBy');
  @override
  late final GeneratedColumn<String> reviewedBy = GeneratedColumn<String>(
      'reviewed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reviewNoteMeta =
      const VerificationMeta('reviewNote');
  @override
  late final GeneratedColumn<String> reviewNote = GeneratedColumn<String>(
      'review_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        halaqaId,
        type,
        severity,
        message,
        status,
        createdBy,
        createdAt,
        reviewedBy,
        reviewNote
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<Alert> instance,
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
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('reviewed_by')) {
      context.handle(
          _reviewedByMeta,
          reviewedBy.isAcceptableOrUnknown(
              data['reviewed_by']!, _reviewedByMeta));
    }
    if (data.containsKey('review_note')) {
      context.handle(
          _reviewNoteMeta,
          reviewNote.isAcceptableOrUnknown(
              data['review_note']!, _reviewNoteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alert(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      halaqaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}halaqa_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      reviewedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reviewed_by']),
      reviewNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}review_note']),
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class Alert extends DataClass implements Insertable<Alert> {
  final String id;
  final String studentId;
  final String halaqaId;
  final String type;
  final String severity;
  final String message;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final String? reviewedBy;
  final String? reviewNote;
  const Alert(
      {required this.id,
      required this.studentId,
      required this.halaqaId,
      required this.type,
      required this.severity,
      required this.message,
      required this.status,
      required this.createdBy,
      required this.createdAt,
      this.reviewedBy,
      this.reviewNote});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['halaqa_id'] = Variable<String>(halaqaId);
    map['type'] = Variable<String>(type);
    map['severity'] = Variable<String>(severity);
    map['message'] = Variable<String>(message);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || reviewedBy != null) {
      map['reviewed_by'] = Variable<String>(reviewedBy);
    }
    if (!nullToAbsent || reviewNote != null) {
      map['review_note'] = Variable<String>(reviewNote);
    }
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      halaqaId: Value(halaqaId),
      type: Value(type),
      severity: Value(severity),
      message: Value(message),
      status: Value(status),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      reviewedBy: reviewedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedBy),
      reviewNote: reviewNote == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewNote),
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alert(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      halaqaId: serializer.fromJson<String>(json['halaqaId']),
      type: serializer.fromJson<String>(json['type']),
      severity: serializer.fromJson<String>(json['severity']),
      message: serializer.fromJson<String>(json['message']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      reviewedBy: serializer.fromJson<String?>(json['reviewedBy']),
      reviewNote: serializer.fromJson<String?>(json['reviewNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'halaqaId': serializer.toJson<String>(halaqaId),
      'type': serializer.toJson<String>(type),
      'severity': serializer.toJson<String>(severity),
      'message': serializer.toJson<String>(message),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'reviewedBy': serializer.toJson<String?>(reviewedBy),
      'reviewNote': serializer.toJson<String?>(reviewNote),
    };
  }

  Alert copyWith(
          {String? id,
          String? studentId,
          String? halaqaId,
          String? type,
          String? severity,
          String? message,
          String? status,
          String? createdBy,
          DateTime? createdAt,
          Value<String?> reviewedBy = const Value.absent(),
          Value<String?> reviewNote = const Value.absent()}) =>
      Alert(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        halaqaId: halaqaId ?? this.halaqaId,
        type: type ?? this.type,
        severity: severity ?? this.severity,
        message: message ?? this.message,
        status: status ?? this.status,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        reviewedBy: reviewedBy.present ? reviewedBy.value : this.reviewedBy,
        reviewNote: reviewNote.present ? reviewNote.value : this.reviewNote,
      );
  Alert copyWithCompanion(AlertsCompanion data) {
    return Alert(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      halaqaId: data.halaqaId.present ? data.halaqaId.value : this.halaqaId,
      type: data.type.present ? data.type.value : this.type,
      severity: data.severity.present ? data.severity.value : this.severity,
      message: data.message.present ? data.message.value : this.message,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      reviewedBy:
          data.reviewedBy.present ? data.reviewedBy.value : this.reviewedBy,
      reviewNote:
          data.reviewNote.present ? data.reviewNote.value : this.reviewNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alert(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('reviewedBy: $reviewedBy, ')
          ..write('reviewNote: $reviewNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, halaqaId, type, severity,
      message, status, createdBy, createdAt, reviewedBy, reviewNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alert &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.halaqaId == this.halaqaId &&
          other.type == this.type &&
          other.severity == this.severity &&
          other.message == this.message &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.reviewedBy == this.reviewedBy &&
          other.reviewNote == this.reviewNote);
}

class AlertsCompanion extends UpdateCompanion<Alert> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> halaqaId;
  final Value<String> type;
  final Value<String> severity;
  final Value<String> message;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<String?> reviewedBy;
  final Value<String?> reviewNote;
  final Value<int> rowid;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.halaqaId = const Value.absent(),
    this.type = const Value.absent(),
    this.severity = const Value.absent(),
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.reviewedBy = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String id,
    required String studentId,
    this.halaqaId = const Value.absent(),
    required String type,
    this.severity = const Value.absent(),
    required String message,
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    required DateTime createdAt,
    this.reviewedBy = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        type = Value(type),
        message = Value(message),
        createdAt = Value(createdAt);
  static Insertable<Alert> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? halaqaId,
    Expression<String>? type,
    Expression<String>? severity,
    Expression<String>? message,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<String>? reviewedBy,
    Expression<String>? reviewNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (halaqaId != null) 'halaqa_id': halaqaId,
      if (type != null) 'type': type,
      if (severity != null) 'severity': severity,
      if (message != null) 'message': message,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (reviewedBy != null) 'reviewed_by': reviewedBy,
      if (reviewNote != null) 'review_note': reviewNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<String>? halaqaId,
      Value<String>? type,
      Value<String>? severity,
      Value<String>? message,
      Value<String>? status,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<String?>? reviewedBy,
      Value<String?>? reviewNote,
      Value<int>? rowid}) {
    return AlertsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      halaqaId: halaqaId ?? this.halaqaId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      message: message ?? this.message,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewNote: reviewNote ?? this.reviewNote,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (reviewedBy.present) {
      map['reviewed_by'] = Variable<String>(reviewedBy.value);
    }
    if (reviewNote.present) {
      map['review_note'] = Variable<String>(reviewNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('halaqaId: $halaqaId, ')
          ..write('type: $type, ')
          ..write('severity: $severity, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('reviewedBy: $reviewedBy, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactLogsTable extends ContactLogs
    with TableInfo<$ContactLogsTable, ContactLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _guardianIdMeta =
      const VerificationMeta('guardianId');
  @override
  late final GeneratedColumn<String> guardianId = GeneratedColumn<String>(
      'guardian_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _channelMeta =
      const VerificationMeta('channel');
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
      'channel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _contactedByMeta =
      const VerificationMeta('contactedBy');
  @override
  late final GeneratedColumn<String> contactedBy = GeneratedColumn<String>(
      'contacted_by', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _contactedAtMeta =
      const VerificationMeta('contactedAt');
  @override
  late final GeneratedColumn<DateTime> contactedAt = GeneratedColumn<DateTime>(
      'contacted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _outcomeMeta =
      const VerificationMeta('outcome');
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
      'outcome', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        studentId,
        guardianId,
        channel,
        reason,
        note,
        contactedBy,
        contactedAt,
        outcome
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contact_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ContactLog> instance,
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
    if (data.containsKey('guardian_id')) {
      context.handle(
          _guardianIdMeta,
          guardianId.isAcceptableOrUnknown(
              data['guardian_id']!, _guardianIdMeta));
    }
    if (data.containsKey('channel')) {
      context.handle(_channelMeta,
          channel.isAcceptableOrUnknown(data['channel']!, _channelMeta));
    } else if (isInserting) {
      context.missing(_channelMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('contacted_by')) {
      context.handle(
          _contactedByMeta,
          contactedBy.isAcceptableOrUnknown(
              data['contacted_by']!, _contactedByMeta));
    }
    if (data.containsKey('contacted_at')) {
      context.handle(
          _contactedAtMeta,
          contactedAt.isAcceptableOrUnknown(
              data['contacted_at']!, _contactedAtMeta));
    } else if (isInserting) {
      context.missing(_contactedAtMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(_outcomeMeta,
          outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_id'])!,
      guardianId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guardian_id'])!,
      channel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      contactedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contacted_by'])!,
      contactedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}contacted_at'])!,
      outcome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}outcome']),
    );
  }

  @override
  $ContactLogsTable createAlias(String alias) {
    return $ContactLogsTable(attachedDatabase, alias);
  }
}

class ContactLog extends DataClass implements Insertable<ContactLog> {
  final String id;
  final String studentId;
  final String guardianId;
  final String channel;
  final String reason;
  final String note;
  final String contactedBy;
  final DateTime contactedAt;
  final String? outcome;
  const ContactLog(
      {required this.id,
      required this.studentId,
      required this.guardianId,
      required this.channel,
      required this.reason,
      required this.note,
      required this.contactedBy,
      required this.contactedAt,
      this.outcome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['guardian_id'] = Variable<String>(guardianId);
    map['channel'] = Variable<String>(channel);
    map['reason'] = Variable<String>(reason);
    map['note'] = Variable<String>(note);
    map['contacted_by'] = Variable<String>(contactedBy);
    map['contacted_at'] = Variable<DateTime>(contactedAt);
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    return map;
  }

  ContactLogsCompanion toCompanion(bool nullToAbsent) {
    return ContactLogsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      guardianId: Value(guardianId),
      channel: Value(channel),
      reason: Value(reason),
      note: Value(note),
      contactedBy: Value(contactedBy),
      contactedAt: Value(contactedAt),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
    );
  }

  factory ContactLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactLog(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      guardianId: serializer.fromJson<String>(json['guardianId']),
      channel: serializer.fromJson<String>(json['channel']),
      reason: serializer.fromJson<String>(json['reason']),
      note: serializer.fromJson<String>(json['note']),
      contactedBy: serializer.fromJson<String>(json['contactedBy']),
      contactedAt: serializer.fromJson<DateTime>(json['contactedAt']),
      outcome: serializer.fromJson<String?>(json['outcome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'guardianId': serializer.toJson<String>(guardianId),
      'channel': serializer.toJson<String>(channel),
      'reason': serializer.toJson<String>(reason),
      'note': serializer.toJson<String>(note),
      'contactedBy': serializer.toJson<String>(contactedBy),
      'contactedAt': serializer.toJson<DateTime>(contactedAt),
      'outcome': serializer.toJson<String?>(outcome),
    };
  }

  ContactLog copyWith(
          {String? id,
          String? studentId,
          String? guardianId,
          String? channel,
          String? reason,
          String? note,
          String? contactedBy,
          DateTime? contactedAt,
          Value<String?> outcome = const Value.absent()}) =>
      ContactLog(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        guardianId: guardianId ?? this.guardianId,
        channel: channel ?? this.channel,
        reason: reason ?? this.reason,
        note: note ?? this.note,
        contactedBy: contactedBy ?? this.contactedBy,
        contactedAt: contactedAt ?? this.contactedAt,
        outcome: outcome.present ? outcome.value : this.outcome,
      );
  ContactLog copyWithCompanion(ContactLogsCompanion data) {
    return ContactLog(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      guardianId:
          data.guardianId.present ? data.guardianId.value : this.guardianId,
      channel: data.channel.present ? data.channel.value : this.channel,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      contactedBy:
          data.contactedBy.present ? data.contactedBy.value : this.contactedBy,
      contactedAt:
          data.contactedAt.present ? data.contactedAt.value : this.contactedAt,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactLog(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('guardianId: $guardianId, ')
          ..write('channel: $channel, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('contactedBy: $contactedBy, ')
          ..write('contactedAt: $contactedAt, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, guardianId, channel, reason,
      note, contactedBy, contactedAt, outcome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactLog &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.guardianId == this.guardianId &&
          other.channel == this.channel &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.contactedBy == this.contactedBy &&
          other.contactedAt == this.contactedAt &&
          other.outcome == this.outcome);
}

class ContactLogsCompanion extends UpdateCompanion<ContactLog> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> guardianId;
  final Value<String> channel;
  final Value<String> reason;
  final Value<String> note;
  final Value<String> contactedBy;
  final Value<DateTime> contactedAt;
  final Value<String?> outcome;
  final Value<int> rowid;
  const ContactLogsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.guardianId = const Value.absent(),
    this.channel = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.contactedBy = const Value.absent(),
    this.contactedAt = const Value.absent(),
    this.outcome = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactLogsCompanion.insert({
    required String id,
    required String studentId,
    this.guardianId = const Value.absent(),
    required String channel,
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.contactedBy = const Value.absent(),
    required DateTime contactedAt,
    this.outcome = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        studentId = Value(studentId),
        channel = Value(channel),
        contactedAt = Value(contactedAt);
  static Insertable<ContactLog> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? guardianId,
    Expression<String>? channel,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<String>? contactedBy,
    Expression<DateTime>? contactedAt,
    Expression<String>? outcome,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (guardianId != null) 'guardian_id': guardianId,
      if (channel != null) 'channel': channel,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (contactedBy != null) 'contacted_by': contactedBy,
      if (contactedAt != null) 'contacted_at': contactedAt,
      if (outcome != null) 'outcome': outcome,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? studentId,
      Value<String>? guardianId,
      Value<String>? channel,
      Value<String>? reason,
      Value<String>? note,
      Value<String>? contactedBy,
      Value<DateTime>? contactedAt,
      Value<String?>? outcome,
      Value<int>? rowid}) {
    return ContactLogsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      guardianId: guardianId ?? this.guardianId,
      channel: channel ?? this.channel,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      contactedBy: contactedBy ?? this.contactedBy,
      contactedAt: contactedAt ?? this.contactedAt,
      outcome: outcome ?? this.outcome,
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
    if (guardianId.present) {
      map['guardian_id'] = Variable<String>(guardianId.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (contactedBy.present) {
      map['contacted_by'] = Variable<String>(contactedBy.value);
    }
    if (contactedAt.present) {
      map['contacted_at'] = Variable<DateTime>(contactedAt.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactLogsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('guardianId: $guardianId, ')
          ..write('channel: $channel, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('contactedBy: $contactedBy, ')
          ..write('contactedAt: $contactedAt, ')
          ..write('outcome: $outcome, ')
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
  late final $GuardiansTable guardians = $GuardiansTable(this);
  late final $HalaqasTable halaqas = $HalaqasTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $DailyRecordsTable dailyRecords = $DailyRecordsTable(this);
  late final $FollowUpPlansTable followUpPlans = $FollowUpPlansTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $ContactLogsTable contactLogs = $ContactLogsTable(this);
  late final $StudentTransfersTable studentTransfers =
      $StudentTransfersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        guardians,
        halaqas,
        students,
        dailyRecords,
        followUpPlans,
        alerts,
        contactLogs,
        studentTransfers
      ];
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
typedef $$GuardiansTableCreateCompanionBuilder = GuardiansCompanion Function({
  required String id,
  required String fullName,
  Value<String> relation,
  required String primaryPhone,
  Value<String> whatsappPhone,
  Value<String> secondaryPhone,
  Value<String> preferredContact,
  Value<String> notes,
  Value<int> rowid,
});
typedef $$GuardiansTableUpdateCompanionBuilder = GuardiansCompanion Function({
  Value<String> id,
  Value<String> fullName,
  Value<String> relation,
  Value<String> primaryPhone,
  Value<String> whatsappPhone,
  Value<String> secondaryPhone,
  Value<String> preferredContact,
  Value<String> notes,
  Value<int> rowid,
});

class $$GuardiansTableFilterComposer
    extends Composer<_$AppDatabase, $GuardiansTable> {
  $$GuardiansTableFilterComposer({
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

  ColumnFilters<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryPhone => $composableBuilder(
      column: $table.primaryPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsappPhone => $composableBuilder(
      column: $table.whatsappPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secondaryPhone => $composableBuilder(
      column: $table.secondaryPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredContact => $composableBuilder(
      column: $table.preferredContact,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$GuardiansTableOrderingComposer
    extends Composer<_$AppDatabase, $GuardiansTable> {
  $$GuardiansTableOrderingComposer({
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

  ColumnOrderings<String> get relation => $composableBuilder(
      column: $table.relation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryPhone => $composableBuilder(
      column: $table.primaryPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsappPhone => $composableBuilder(
      column: $table.whatsappPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryPhone => $composableBuilder(
      column: $table.secondaryPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredContact => $composableBuilder(
      column: $table.preferredContact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$GuardiansTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuardiansTable> {
  $$GuardiansTableAnnotationComposer({
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

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<String> get primaryPhone => $composableBuilder(
      column: $table.primaryPhone, builder: (column) => column);

  GeneratedColumn<String> get whatsappPhone => $composableBuilder(
      column: $table.whatsappPhone, builder: (column) => column);

  GeneratedColumn<String> get secondaryPhone => $composableBuilder(
      column: $table.secondaryPhone, builder: (column) => column);

  GeneratedColumn<String> get preferredContact => $composableBuilder(
      column: $table.preferredContact, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$GuardiansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GuardiansTable,
    Guardian,
    $$GuardiansTableFilterComposer,
    $$GuardiansTableOrderingComposer,
    $$GuardiansTableAnnotationComposer,
    $$GuardiansTableCreateCompanionBuilder,
    $$GuardiansTableUpdateCompanionBuilder,
    (Guardian, BaseReferences<_$AppDatabase, $GuardiansTable, Guardian>),
    Guardian,
    PrefetchHooks Function()> {
  $$GuardiansTableTableManager(_$AppDatabase db, $GuardiansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuardiansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuardiansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuardiansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String> relation = const Value.absent(),
            Value<String> primaryPhone = const Value.absent(),
            Value<String> whatsappPhone = const Value.absent(),
            Value<String> secondaryPhone = const Value.absent(),
            Value<String> preferredContact = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GuardiansCompanion(
            id: id,
            fullName: fullName,
            relation: relation,
            primaryPhone: primaryPhone,
            whatsappPhone: whatsappPhone,
            secondaryPhone: secondaryPhone,
            preferredContact: preferredContact,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fullName,
            Value<String> relation = const Value.absent(),
            required String primaryPhone,
            Value<String> whatsappPhone = const Value.absent(),
            Value<String> secondaryPhone = const Value.absent(),
            Value<String> preferredContact = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GuardiansCompanion.insert(
            id: id,
            fullName: fullName,
            relation: relation,
            primaryPhone: primaryPhone,
            whatsappPhone: whatsappPhone,
            secondaryPhone: secondaryPhone,
            preferredContact: preferredContact,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GuardiansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GuardiansTable,
    Guardian,
    $$GuardiansTableFilterComposer,
    $$GuardiansTableOrderingComposer,
    $$GuardiansTableAnnotationComposer,
    $$GuardiansTableCreateCompanionBuilder,
    $$GuardiansTableUpdateCompanionBuilder,
    (Guardian, BaseReferences<_$AppDatabase, $GuardiansTable, Guardian>),
    Guardian,
    PrefetchHooks Function()>;
typedef $$HalaqasTableCreateCompanionBuilder = HalaqasCompanion Function({
  required String id,
  required String name,
  required String level,
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
            required String level,
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
  Value<String> guardianIds,
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
  Value<String> guardianIds,
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

  ColumnFilters<String> get guardianIds => $composableBuilder(
      column: $table.guardianIds, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get guardianIds => $composableBuilder(
      column: $table.guardianIds, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get guardianIds => $composableBuilder(
      column: $table.guardianIds, builder: (column) => column);

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
            Value<String> guardianIds = const Value.absent(),
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
            guardianIds: guardianIds,
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
            Value<String> guardianIds = const Value.absent(),
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
            guardianIds: guardianIds,
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
  Value<String> attendance,
  Value<String> fromSurah,
  Value<int> fromAyah,
  Value<String> toSurah,
  Value<int> toAyah,
  Value<double> estimatedPages,
  Value<double> revisionPlannedPages,
  Value<double> revisionCompletedPages,
  Value<double> revisionScore,
  Value<int> minorErrors,
  Value<int> mediumErrors,
  Value<int> majorErrors,
  Value<int> selfCorrections,
  Value<double> automaticScore,
  Value<double?> overrideScore,
  Value<String?> overrideReason,
  Value<String> homeworkStatus,
  Value<double> homeworkScore,
  Value<double> finalScore,
  Value<String> level,
  Value<String> internalNote,
  Value<bool> needsFollowUp,
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
  Value<String> attendance,
  Value<String> fromSurah,
  Value<int> fromAyah,
  Value<String> toSurah,
  Value<int> toAyah,
  Value<double> estimatedPages,
  Value<double> revisionPlannedPages,
  Value<double> revisionCompletedPages,
  Value<double> revisionScore,
  Value<int> minorErrors,
  Value<int> mediumErrors,
  Value<int> majorErrors,
  Value<int> selfCorrections,
  Value<double> automaticScore,
  Value<double?> overrideScore,
  Value<String?> overrideReason,
  Value<String> homeworkStatus,
  Value<double> homeworkScore,
  Value<double> finalScore,
  Value<String> level,
  Value<String> internalNote,
  Value<bool> needsFollowUp,
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

  ColumnFilters<String> get attendance => $composableBuilder(
      column: $table.attendance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromSurah => $composableBuilder(
      column: $table.fromSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toSurah => $composableBuilder(
      column: $table.toSurah, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get estimatedPages => $composableBuilder(
      column: $table.estimatedPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get revisionPlannedPages => $composableBuilder(
      column: $table.revisionPlannedPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get revisionCompletedPages => $composableBuilder(
      column: $table.revisionCompletedPages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get revisionScore => $composableBuilder(
      column: $table.revisionScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minorErrors => $composableBuilder(
      column: $table.minorErrors, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mediumErrors => $composableBuilder(
      column: $table.mediumErrors, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get majorErrors => $composableBuilder(
      column: $table.majorErrors, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get selfCorrections => $composableBuilder(
      column: $table.selfCorrections,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get automaticScore => $composableBuilder(
      column: $table.automaticScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get overrideScore => $composableBuilder(
      column: $table.overrideScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overrideReason => $composableBuilder(
      column: $table.overrideReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get homeworkStatus => $composableBuilder(
      column: $table.homeworkStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get homeworkScore => $composableBuilder(
      column: $table.homeworkScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get internalNote => $composableBuilder(
      column: $table.internalNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get needsFollowUp => $composableBuilder(
      column: $table.needsFollowUp, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get attendance => $composableBuilder(
      column: $table.attendance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromSurah => $composableBuilder(
      column: $table.fromSurah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fromAyah => $composableBuilder(
      column: $table.fromAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toSurah => $composableBuilder(
      column: $table.toSurah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toAyah => $composableBuilder(
      column: $table.toAyah, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get estimatedPages => $composableBuilder(
      column: $table.estimatedPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get revisionPlannedPages => $composableBuilder(
      column: $table.revisionPlannedPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get revisionCompletedPages => $composableBuilder(
      column: $table.revisionCompletedPages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get revisionScore => $composableBuilder(
      column: $table.revisionScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minorErrors => $composableBuilder(
      column: $table.minorErrors, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mediumErrors => $composableBuilder(
      column: $table.mediumErrors,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get majorErrors => $composableBuilder(
      column: $table.majorErrors, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get selfCorrections => $composableBuilder(
      column: $table.selfCorrections,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get automaticScore => $composableBuilder(
      column: $table.automaticScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get overrideScore => $composableBuilder(
      column: $table.overrideScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overrideReason => $composableBuilder(
      column: $table.overrideReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get homeworkStatus => $composableBuilder(
      column: $table.homeworkStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get homeworkScore => $composableBuilder(
      column: $table.homeworkScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get internalNote => $composableBuilder(
      column: $table.internalNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get needsFollowUp => $composableBuilder(
      column: $table.needsFollowUp,
      builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get attendance => $composableBuilder(
      column: $table.attendance, builder: (column) => column);

  GeneratedColumn<String> get fromSurah =>
      $composableBuilder(column: $table.fromSurah, builder: (column) => column);

  GeneratedColumn<int> get fromAyah =>
      $composableBuilder(column: $table.fromAyah, builder: (column) => column);

  GeneratedColumn<String> get toSurah =>
      $composableBuilder(column: $table.toSurah, builder: (column) => column);

  GeneratedColumn<int> get toAyah =>
      $composableBuilder(column: $table.toAyah, builder: (column) => column);

  GeneratedColumn<double> get estimatedPages => $composableBuilder(
      column: $table.estimatedPages, builder: (column) => column);

  GeneratedColumn<double> get revisionPlannedPages => $composableBuilder(
      column: $table.revisionPlannedPages, builder: (column) => column);

  GeneratedColumn<double> get revisionCompletedPages => $composableBuilder(
      column: $table.revisionCompletedPages, builder: (column) => column);

  GeneratedColumn<double> get revisionScore => $composableBuilder(
      column: $table.revisionScore, builder: (column) => column);

  GeneratedColumn<int> get minorErrors => $composableBuilder(
      column: $table.minorErrors, builder: (column) => column);

  GeneratedColumn<int> get mediumErrors => $composableBuilder(
      column: $table.mediumErrors, builder: (column) => column);

  GeneratedColumn<int> get majorErrors => $composableBuilder(
      column: $table.majorErrors, builder: (column) => column);

  GeneratedColumn<int> get selfCorrections => $composableBuilder(
      column: $table.selfCorrections, builder: (column) => column);

  GeneratedColumn<double> get automaticScore => $composableBuilder(
      column: $table.automaticScore, builder: (column) => column);

  GeneratedColumn<double> get overrideScore => $composableBuilder(
      column: $table.overrideScore, builder: (column) => column);

  GeneratedColumn<String> get overrideReason => $composableBuilder(
      column: $table.overrideReason, builder: (column) => column);

  GeneratedColumn<String> get homeworkStatus => $composableBuilder(
      column: $table.homeworkStatus, builder: (column) => column);

  GeneratedColumn<double> get homeworkScore => $composableBuilder(
      column: $table.homeworkScore, builder: (column) => column);

  GeneratedColumn<double> get finalScore => $composableBuilder(
      column: $table.finalScore, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get internalNote => $composableBuilder(
      column: $table.internalNote, builder: (column) => column);

  GeneratedColumn<bool> get needsFollowUp => $composableBuilder(
      column: $table.needsFollowUp, builder: (column) => column);

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
            Value<String> attendance = const Value.absent(),
            Value<String> fromSurah = const Value.absent(),
            Value<int> fromAyah = const Value.absent(),
            Value<String> toSurah = const Value.absent(),
            Value<int> toAyah = const Value.absent(),
            Value<double> estimatedPages = const Value.absent(),
            Value<double> revisionPlannedPages = const Value.absent(),
            Value<double> revisionCompletedPages = const Value.absent(),
            Value<double> revisionScore = const Value.absent(),
            Value<int> minorErrors = const Value.absent(),
            Value<int> mediumErrors = const Value.absent(),
            Value<int> majorErrors = const Value.absent(),
            Value<int> selfCorrections = const Value.absent(),
            Value<double> automaticScore = const Value.absent(),
            Value<double?> overrideScore = const Value.absent(),
            Value<String?> overrideReason = const Value.absent(),
            Value<String> homeworkStatus = const Value.absent(),
            Value<double> homeworkScore = const Value.absent(),
            Value<double> finalScore = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> internalNote = const Value.absent(),
            Value<bool> needsFollowUp = const Value.absent(),
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
            attendance: attendance,
            fromSurah: fromSurah,
            fromAyah: fromAyah,
            toSurah: toSurah,
            toAyah: toAyah,
            estimatedPages: estimatedPages,
            revisionPlannedPages: revisionPlannedPages,
            revisionCompletedPages: revisionCompletedPages,
            revisionScore: revisionScore,
            minorErrors: minorErrors,
            mediumErrors: mediumErrors,
            majorErrors: majorErrors,
            selfCorrections: selfCorrections,
            automaticScore: automaticScore,
            overrideScore: overrideScore,
            overrideReason: overrideReason,
            homeworkStatus: homeworkStatus,
            homeworkScore: homeworkScore,
            finalScore: finalScore,
            level: level,
            internalNote: internalNote,
            needsFollowUp: needsFollowUp,
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
            Value<String> attendance = const Value.absent(),
            Value<String> fromSurah = const Value.absent(),
            Value<int> fromAyah = const Value.absent(),
            Value<String> toSurah = const Value.absent(),
            Value<int> toAyah = const Value.absent(),
            Value<double> estimatedPages = const Value.absent(),
            Value<double> revisionPlannedPages = const Value.absent(),
            Value<double> revisionCompletedPages = const Value.absent(),
            Value<double> revisionScore = const Value.absent(),
            Value<int> minorErrors = const Value.absent(),
            Value<int> mediumErrors = const Value.absent(),
            Value<int> majorErrors = const Value.absent(),
            Value<int> selfCorrections = const Value.absent(),
            Value<double> automaticScore = const Value.absent(),
            Value<double?> overrideScore = const Value.absent(),
            Value<String?> overrideReason = const Value.absent(),
            Value<String> homeworkStatus = const Value.absent(),
            Value<double> homeworkScore = const Value.absent(),
            Value<double> finalScore = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> internalNote = const Value.absent(),
            Value<bool> needsFollowUp = const Value.absent(),
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
            attendance: attendance,
            fromSurah: fromSurah,
            fromAyah: fromAyah,
            toSurah: toSurah,
            toAyah: toAyah,
            estimatedPages: estimatedPages,
            revisionPlannedPages: revisionPlannedPages,
            revisionCompletedPages: revisionCompletedPages,
            revisionScore: revisionScore,
            minorErrors: minorErrors,
            mediumErrors: mediumErrors,
            majorErrors: majorErrors,
            selfCorrections: selfCorrections,
            automaticScore: automaticScore,
            overrideScore: overrideScore,
            overrideReason: overrideReason,
            homeworkStatus: homeworkStatus,
            homeworkScore: homeworkScore,
            finalScore: finalScore,
            level: level,
            internalNote: internalNote,
            needsFollowUp: needsFollowUp,
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
typedef $$FollowUpPlansTableCreateCompanionBuilder = FollowUpPlansCompanion
    Function({
  required String id,
  required String studentId,
  required String createdBy,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String> goals,
  Value<String> actions,
  Value<String> status,
  Value<String> notes,
  Value<int> rowid,
});
typedef $$FollowUpPlansTableUpdateCompanionBuilder = FollowUpPlansCompanion
    Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> createdBy,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String> goals,
  Value<String> actions,
  Value<String> status,
  Value<String> notes,
  Value<int> rowid,
});

class $$FollowUpPlansTableFilterComposer
    extends Composer<_$AppDatabase, $FollowUpPlansTable> {
  $$FollowUpPlansTableFilterComposer({
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

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goals => $composableBuilder(
      column: $table.goals, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actions => $composableBuilder(
      column: $table.actions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$FollowUpPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $FollowUpPlansTable> {
  $$FollowUpPlansTableOrderingComposer({
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

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goals => $composableBuilder(
      column: $table.goals, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actions => $composableBuilder(
      column: $table.actions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$FollowUpPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $FollowUpPlansTable> {
  $$FollowUpPlansTableAnnotationComposer({
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

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<String> get actions =>
      $composableBuilder(column: $table.actions, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FollowUpPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FollowUpPlansTable,
    FollowUpPlan,
    $$FollowUpPlansTableFilterComposer,
    $$FollowUpPlansTableOrderingComposer,
    $$FollowUpPlansTableAnnotationComposer,
    $$FollowUpPlansTableCreateCompanionBuilder,
    $$FollowUpPlansTableUpdateCompanionBuilder,
    (
      FollowUpPlan,
      BaseReferences<_$AppDatabase, $FollowUpPlansTable, FollowUpPlan>
    ),
    FollowUpPlan,
    PrefetchHooks Function()> {
  $$FollowUpPlansTableTableManager(_$AppDatabase db, $FollowUpPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FollowUpPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FollowUpPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FollowUpPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> goals = const Value.absent(),
            Value<String> actions = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FollowUpPlansCompanion(
            id: id,
            studentId: studentId,
            createdBy: createdBy,
            startDate: startDate,
            endDate: endDate,
            goals: goals,
            actions: actions,
            status: status,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            required String createdBy,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> goals = const Value.absent(),
            Value<String> actions = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FollowUpPlansCompanion.insert(
            id: id,
            studentId: studentId,
            createdBy: createdBy,
            startDate: startDate,
            endDate: endDate,
            goals: goals,
            actions: actions,
            status: status,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FollowUpPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FollowUpPlansTable,
    FollowUpPlan,
    $$FollowUpPlansTableFilterComposer,
    $$FollowUpPlansTableOrderingComposer,
    $$FollowUpPlansTableAnnotationComposer,
    $$FollowUpPlansTableCreateCompanionBuilder,
    $$FollowUpPlansTableUpdateCompanionBuilder,
    (
      FollowUpPlan,
      BaseReferences<_$AppDatabase, $FollowUpPlansTable, FollowUpPlan>
    ),
    FollowUpPlan,
    PrefetchHooks Function()>;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  required String id,
  required String studentId,
  Value<String> halaqaId,
  required String type,
  Value<String> severity,
  required String message,
  Value<String> status,
  Value<String> createdBy,
  required DateTime createdAt,
  Value<String?> reviewedBy,
  Value<String?> reviewNote,
  Value<int> rowid,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> halaqaId,
  Value<String> type,
  Value<String> severity,
  Value<String> message,
  Value<String> status,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<String?> reviewedBy,
  Value<String?> reviewNote,
  Value<int> rowid,
});

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reviewedBy => $composableBuilder(
      column: $table.reviewedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reviewNote => $composableBuilder(
      column: $table.reviewNote, builder: (column) => ColumnFilters(column));
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reviewedBy => $composableBuilder(
      column: $table.reviewedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reviewNote => $composableBuilder(
      column: $table.reviewNote, builder: (column) => ColumnOrderings(column));
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get reviewedBy => $composableBuilder(
      column: $table.reviewedBy, builder: (column) => column);

  GeneratedColumn<String> get reviewNote => $composableBuilder(
      column: $table.reviewNote, builder: (column) => column);
}

class $$AlertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, BaseReferences<_$AppDatabase, $AlertsTable, Alert>),
    Alert,
    PrefetchHooks Function()> {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> halaqaId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> reviewedBy = const Value.absent(),
            Value<String?> reviewNote = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion(
            id: id,
            studentId: studentId,
            halaqaId: halaqaId,
            type: type,
            severity: severity,
            message: message,
            status: status,
            createdBy: createdBy,
            createdAt: createdAt,
            reviewedBy: reviewedBy,
            reviewNote: reviewNote,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            Value<String> halaqaId = const Value.absent(),
            required String type,
            Value<String> severity = const Value.absent(),
            required String message,
            Value<String> status = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            required DateTime createdAt,
            Value<String?> reviewedBy = const Value.absent(),
            Value<String?> reviewNote = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion.insert(
            id: id,
            studentId: studentId,
            halaqaId: halaqaId,
            type: type,
            severity: severity,
            message: message,
            status: status,
            createdBy: createdBy,
            createdAt: createdAt,
            reviewedBy: reviewedBy,
            reviewNote: reviewNote,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, BaseReferences<_$AppDatabase, $AlertsTable, Alert>),
    Alert,
    PrefetchHooks Function()>;
typedef $$ContactLogsTableCreateCompanionBuilder = ContactLogsCompanion
    Function({
  required String id,
  required String studentId,
  Value<String> guardianId,
  required String channel,
  Value<String> reason,
  Value<String> note,
  Value<String> contactedBy,
  required DateTime contactedAt,
  Value<String?> outcome,
  Value<int> rowid,
});
typedef $$ContactLogsTableUpdateCompanionBuilder = ContactLogsCompanion
    Function({
  Value<String> id,
  Value<String> studentId,
  Value<String> guardianId,
  Value<String> channel,
  Value<String> reason,
  Value<String> note,
  Value<String> contactedBy,
  Value<DateTime> contactedAt,
  Value<String?> outcome,
  Value<int> rowid,
});

class $$ContactLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactLogsTable> {
  $$ContactLogsTableFilterComposer({
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

  ColumnFilters<String> get guardianId => $composableBuilder(
      column: $table.guardianId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactedBy => $composableBuilder(
      column: $table.contactedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get contactedAt => $composableBuilder(
      column: $table.contactedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outcome => $composableBuilder(
      column: $table.outcome, builder: (column) => ColumnFilters(column));
}

class $$ContactLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactLogsTable> {
  $$ContactLogsTableOrderingComposer({
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

  ColumnOrderings<String> get guardianId => $composableBuilder(
      column: $table.guardianId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactedBy => $composableBuilder(
      column: $table.contactedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get contactedAt => $composableBuilder(
      column: $table.contactedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outcome => $composableBuilder(
      column: $table.outcome, builder: (column) => ColumnOrderings(column));
}

class $$ContactLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactLogsTable> {
  $$ContactLogsTableAnnotationComposer({
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

  GeneratedColumn<String> get guardianId => $composableBuilder(
      column: $table.guardianId, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get contactedBy => $composableBuilder(
      column: $table.contactedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get contactedAt => $composableBuilder(
      column: $table.contactedAt, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);
}

class $$ContactLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContactLogsTable,
    ContactLog,
    $$ContactLogsTableFilterComposer,
    $$ContactLogsTableOrderingComposer,
    $$ContactLogsTableAnnotationComposer,
    $$ContactLogsTableCreateCompanionBuilder,
    $$ContactLogsTableUpdateCompanionBuilder,
    (ContactLog, BaseReferences<_$AppDatabase, $ContactLogsTable, ContactLog>),
    ContactLog,
    PrefetchHooks Function()> {
  $$ContactLogsTableTableManager(_$AppDatabase db, $ContactLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> studentId = const Value.absent(),
            Value<String> guardianId = const Value.absent(),
            Value<String> channel = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<String> contactedBy = const Value.absent(),
            Value<DateTime> contactedAt = const Value.absent(),
            Value<String?> outcome = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContactLogsCompanion(
            id: id,
            studentId: studentId,
            guardianId: guardianId,
            channel: channel,
            reason: reason,
            note: note,
            contactedBy: contactedBy,
            contactedAt: contactedAt,
            outcome: outcome,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String studentId,
            Value<String> guardianId = const Value.absent(),
            required String channel,
            Value<String> reason = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<String> contactedBy = const Value.absent(),
            required DateTime contactedAt,
            Value<String?> outcome = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContactLogsCompanion.insert(
            id: id,
            studentId: studentId,
            guardianId: guardianId,
            channel: channel,
            reason: reason,
            note: note,
            contactedBy: contactedBy,
            contactedAt: contactedAt,
            outcome: outcome,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContactLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContactLogsTable,
    ContactLog,
    $$ContactLogsTableFilterComposer,
    $$ContactLogsTableOrderingComposer,
    $$ContactLogsTableAnnotationComposer,
    $$ContactLogsTableCreateCompanionBuilder,
    $$ContactLogsTableUpdateCompanionBuilder,
    (ContactLog, BaseReferences<_$AppDatabase, $ContactLogsTable, ContactLog>),
    ContactLog,
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
  $$GuardiansTableTableManager get guardians =>
      $$GuardiansTableTableManager(_db, _db.guardians);
  $$HalaqasTableTableManager get halaqas =>
      $$HalaqasTableTableManager(_db, _db.halaqas);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$DailyRecordsTableTableManager get dailyRecords =>
      $$DailyRecordsTableTableManager(_db, _db.dailyRecords);
  $$FollowUpPlansTableTableManager get followUpPlans =>
      $$FollowUpPlansTableTableManager(_db, _db.followUpPlans);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$ContactLogsTableTableManager get contactLogs =>
      $$ContactLogsTableTableManager(_db, _db.contactLogs);
  $$StudentTransfersTableTableManager get studentTransfers =>
      $$StudentTransfersTableTableManager(_db, _db.studentTransfers);
}
