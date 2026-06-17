import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_data.dart';

class GameState extends ChangeNotifier {
  GameState(this._prefs);
  static const key = 'aussie_wild_bloom_v1';
  final SharedPreferences _prefs;

  bool onboardingComplete = false;
  int unlockedRegions = 1;
  int expeditions = 0;
  int totalPerfects = 0;
  int storyChapter = 0;
  Map<String, int> inventory = {};
  Set<String> discovered = {};
  Set<String> crafted = {};
  Set<String> restored = {};
  Set<String> rares = {};
  Set<String> claimedQuests = {};

  static Future<GameState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final state = GameState(prefs);
    final raw = prefs.getString(key);
    if (raw != null) {
      state._read(jsonDecode(raw) as Map<String, dynamic>);
    }
    return state;
  }

  void _read(Map<String, dynamic> json) {
    onboardingComplete = json['onboarding'] as bool? ?? false;
    unlockedRegions = json['unlocked'] as int? ?? 1;
    expeditions = json['expeditions'] as int? ?? 0;
    totalPerfects = json['perfects'] as int? ?? 0;
    storyChapter = json['chapter'] as int? ?? 0;
    inventory = Map<String, int>.from(json['inventory'] as Map? ?? {});
    discovered = Set<String>.from(json['discovered'] as List? ?? []);
    crafted = Set<String>.from(json['crafted'] as List? ?? []);
    restored = Set<String>.from(json['restored'] as List? ?? []);
    rares = Set<String>.from(json['rares'] as List? ?? []);
    claimedQuests = Set<String>.from(json['quests'] as List? ?? []);
  }

  Future<void> _save() => _prefs.setString(
    key,
    jsonEncode({
      'onboarding': onboardingComplete,
      'unlocked': unlockedRegions,
      'expeditions': expeditions,
      'perfects': totalPerfects,
      'chapter': storyChapter,
      'inventory': inventory,
      'discovered': discovered.toList(),
      'crafted': crafted.toList(),
      'restored': restored.toList(),
      'rares': rares.toList(),
      'quests': claimedQuests.toList(),
    }),
  );

  void finishOnboarding() {
    onboardingComplete = true;
    notifyListeners();
    _save();
  }

  void addRewards(Map<String, int> rewards, int perfects, String regionId) {
    for (final entry in rewards.entries) {
      inventory[entry.key] = (inventory[entry.key] ?? 0) + entry.value;
      discovered.add(entry.key);
    }
    expeditions++;
    totalPerfects += perfects;
    if (perfects >= 4 && !rares.contains('$regionId-gem')) {
      rares.add('$regionId-gem');
    }
    notifyListeners();
    _save();
  }

  bool canCraft(Recipe recipe) => recipe.ingredients.entries.every(
    (e) => (inventory[e.key] ?? 0) >= e.value,
  );

  bool craft(Recipe recipe) {
    if (!canCraft(recipe)) return false;
    for (final item in recipe.ingredients.entries) {
      inventory[item.key] = (inventory[item.key] ?? 0) - item.value;
    }
    crafted.add(recipe.id);
    restored.add(recipe.regionId);
    final index = regions.indexWhere((region) => region.id == recipe.regionId);
    if (index + 2 > unlockedRegions && unlockedRegions < regions.length) {
      unlockedRegions++;
    }
    storyChapter = restored.length;
    notifyListeners();
    _save();
    return true;
  }

  bool regionUnlocked(String id) =>
      regions.indexWhere((r) => r.id == id) < unlockedRegions;

  int count(String id) => inventory[id] ?? 0;

  List<String> get achievements {
    final result = <String>[];
    if (expeditions >= 1) result.add('First Footsteps');
    if (discovered.length >= 4) result.add('Field Botanist');
    if (totalPerfects >= 10) result.add('Perfect Timing');
    if (crafted.isNotEmpty) result.add('Apprentice Alchemist');
    if (restored.length >= 2) result.add('Land Healer');
    if (rares.length >= 3) result.add('Rare Wonder');
    if (restored.length == regions.length) result.add('Wild Heart Restored');
    return result;
  }

  Future<void> reset() async {
    onboardingComplete = false;
    unlockedRegions = 1;
    expeditions = 0;
    totalPerfects = 0;
    storyChapter = 0;
    inventory.clear();
    discovered.clear();
    crafted.clear();
    restored.clear();
    rares.clear();
    claimedQuests.clear();
    await _prefs.remove(key);
    notifyListeners();
  }
}
