import 'dart:convert';

import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/features/account/data/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_cloud_store.dart';

const _uid = 'user-1';

Map<String, dynamic> _food(String id, {int kcal = 100}) => {
  'id': id,
  'name': 'Food $id',
  'calories': kcal,
  'protein': 1.0,
  'carbs': 2.0,
  'fat': 3.0,
  'mealType': 'lunch',
  'loggedAt': '2026-11-02T13:00:00.000',
};

void main() {
  late LocalStorageService storage;
  late FakeCloudStore cloud;
  late SyncService sync;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    cloud = FakeCloudStore();
    sync = SyncService(storage: storage, cloud: cloud);
  });

  tearDown(() => sync.disconnect());

  List<String> localFoodIds() => [
    for (final e in storage.getJsonList(StorageKeys.foodEntries))
      e['id'] as String,
  ]..sort();

  test('a new account gets everything on this phone', () async {
    await storage.setJson(StorageKeys.userProfile, {'name': 'Sam'});
    await storage.setBool(StorageKeys.goalsCustomized, true);
    await storage.setJsonList(StorageKeys.foodEntries, [_food('a')]);

    await sync.connect(_uid);
    await pumpEventQueue();

    expect(cloud.valuesOf(_uid)[StorageKeys.userProfile], '{"name":"Sam"}');
    expect(cloud.valuesOf(_uid)[StorageKeys.goalsCustomized], true);
    expect(cloud.foodOf(_uid).keys, ['a']);
  });

  test('device-only data is not uploaded', () async {
    await storage.setJson(StorageKeys.stepBaseline, {'day': 'x'});
    await storage.setBool(StorageKeys.healthConnected, true);
    await sync.connect(_uid);
    await pumpEventQueue();
    expect(cloud.valuesOf(_uid), isEmpty);
  });

  test(
    'signing in merges: food by id, logs by day, profile from cloud',
    () async {
      await storage.setJson(StorageKeys.userProfile, {'name': 'Local'});
      await storage.setJsonList(StorageKeys.foodEntries, [
        _food('local'),
        _food('both', kcal: 1),
      ]);
      await storage.setJson(StorageKeys.weightLog, {
        '2026-11-01': 80.0,
        '2026-11-02': 79.5,
      });
      cloud.valuesOf(_uid).addAll({
        StorageKeys.userProfile: '{"name":"Cloud"}',
        StorageKeys.weightLog: '{"2026-10-30":81.0,"2026-11-02":79.0}',
      });
      cloud.foodOf(_uid).addAll({
        'cloud': _food('cloud'),
        'both': _food('both', kcal: 2),
      });

      await sync.connect(_uid);
      await pumpEventQueue();

      expect(storage.getJson(StorageKeys.userProfile), {'name': 'Cloud'});
      expect(localFoodIds(), ['both', 'cloud', 'local']);
      final both = storage
          .getJsonList(StorageKeys.foodEntries)
          .firstWhere((e) => e['id'] == 'both');
      expect(both['calories'], 2); // the cloud's copy
      expect(storage.getJson(StorageKeys.weightLog), {
        '2026-10-30': 81.0,
        '2026-11-01': 80.0,
        '2026-11-02': 79.0,
      });
      // The merged result is uploaded too.
      expect(cloud.foodOf(_uid).keys.toSet(), {'both', 'cloud', 'local'});
      expect(
        jsonDecode(cloud.valuesOf(_uid)[StorageKeys.weightLog] as String),
        hasLength(3),
      );
    },
  );

  test('later changes are copied: added, edited and removed food', () async {
    await sync.connect(_uid);
    await storage.setJsonList(StorageKeys.foodEntries, [
      _food('a'),
      _food('b'),
    ]);
    await pumpEventQueue();
    expect(cloud.foodOf(_uid).keys.toSet(), {'a', 'b'});

    final writes = cloud.writes;
    await storage.setJsonList(StorageKeys.foodEntries, [
      _food('a'),
      _food('b', kcal: 500),
    ]);
    await pumpEventQueue();
    expect(cloud.writes, writes + 1, reason: 'only the changed entry');
    expect(cloud.foodOf(_uid)['b']!['calories'], 500);

    await storage.setJsonList(StorageKeys.foodEntries, [_food('b', kcal: 500)]);
    await pumpEventQueue();
    expect(cloud.foodOf(_uid).keys, ['b']);
  });

  test('later value changes are copied, removals delete them', () async {
    await sync.connect(_uid);
    await storage.setJson(StorageKeys.activityKcal, {'2026-11-02': 300});
    await pumpEventQueue();
    expect(
      cloud.valuesOf(_uid)[StorageKeys.activityKcal],
      '{"2026-11-02":300}',
    );

    await storage.remove(StorageKeys.activityKcal);
    await pumpEventQueue();
    expect(cloud.valuesOf(_uid), isNot(contains(StorageKeys.activityKcal)));
  });

  test('nothing is copied after disconnecting', () async {
    await sync.connect(_uid);
    sync.disconnect();
    await storage.setJsonList(StorageKeys.foodEntries, [_food('a')]);
    await pumpEventQueue();
    expect(cloud.foodOf(_uid), isEmpty);
  });

  test("an unreadable cloud fails sign-in but not app start", () async {
    cloud.failReads = true;
    await expectLater(sync.connect(_uid), throwsA(isA<SyncException>()));
    expect(sync.isConnected, isFalse);

    // At app start (maybe offline) changes are still copied.
    await sync.connect(_uid, requireCloud: false);
    expect(sync.isConnected, isTrue);
    await storage.setJsonList(StorageKeys.foodEntries, [_food('a')]);
    await pumpEventQueue();
    expect(cloud.foodOf(_uid).keys, ['a']);
  });
}
