import 'package:aussie_wild_bloom/game_data.dart';
import 'package:aussie_wild_bloom/game_state.dart';
import 'package:aussie_wild_bloom/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GameState> freshState() async {
  SharedPreferences.setMockInitialValues({});
  return GameState.load();
}

void phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
}

void main() {
  testWidgets('onboarding opens the world map on a narrow phone', (
    tester,
  ) async {
    phoneSize(tester);
    addTearDown(tester.view.reset);
    final state = await freshState();
    await tester.pumpWidget(WildBloomApp(state: state));

    expect(find.text('A LAND LOSING ITS COLOUR'), findsOneWidget);
    await tester.tap(find.text('CONTINUE'));
    await tester.pump();
    await tester.tap(find.text('CONTINUE'));
    await tester.pump();
    await tester.tap(find.text('BEGIN ADVENTURE'));
    await tester.pump();

    expect(find.text('CHOOSE A REGION'), findsOneWidget);
    expect(state.onboardingComplete, isTrue);
  });

  test('rewards support crafting and unlock the next region', () async {
    final state = await freshState();
    state.addRewards({'wattle': 2, 'eucalyptus': 2, 'dew': 1}, 4, 'forest');

    expect(state.canCraft(recipeById('verdant')), isTrue);
    expect(state.craft(recipeById('verdant')), isTrue);
    expect(state.restored, contains('forest'));
    expect(state.unlockedRegions, 2);
  });

  testWidgets('collection screen renders empty progress safely', (
    tester,
  ) async {
    phoneSize(tester);
    addTearDown(tester.view.reset);
    final state = await freshState()
      ..finishOnboarding();
    await tester.pumpWidget(WildBloomApp(state: state));
    await tester.tap(find.text('Collection'));
    await tester.pump();

    expect(find.text('COLLECTIONS'), findsOneWidget);
    expect(find.textContaining('first achievement'), findsOneWidget);
  });
}
