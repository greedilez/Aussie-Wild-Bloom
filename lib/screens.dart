import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'game_data.dart';
import 'game_state.dart';

const gold = Color(0xFFFFD05B);
const cream = Color(0xFFFFF3D4);
const teal = Color(0xFF082F34);
const panel = Color(0xFF12454A);
const pale = Color(0xFFB9D7D3);

class Onboarding extends StatefulWidget {
  const Onboarding({super.key, required this.state});
  final GameState state;
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int page = 0;
  static const slides = [
    (
      'A LAND LOSING ITS COLOUR',
      'A silver hush is spreading across Australia. Native blooms are fading and ancient paths are closing.',
      Icons.public,
    ),
    (
      'GATHER WILD MAGIC',
      'Travel with Pip the kangaroo, master timing challenges, and collect plants, minerals, and catalysts.',
      Icons.auto_awesome,
    ),
    (
      'BREW THE WORLD BACK',
      'Craft restoration potions, help local guardians, and awaken the Wild Heart one region at a time.',
      Icons.science,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final slide = slides[page];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/art/app_icon.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF05292D)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GameLogo(),
                  const Spacer(),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: gold,
                    child: Icon(slide.$3, size: 40, color: teal),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    slide.$1,
                    style: const TextStyle(
                      fontSize: 35,
                      height: .95,
                      fontWeight: FontWeight.w900,
                      color: cream,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    slide.$2,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.45,
                      color: cream,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      ...List.generate(
                        3,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: i == page ? 30 : 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 7),
                          decoration: BoxDecoration(
                            color: i == page ? gold : Colors.white38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () => page == 2
                            ? widget.state.finishOnboarding()
                            : setState(() => page++),
                        style: FilledButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 17,
                          ),
                        ),
                        child: Text(
                          page == 2 ? 'BEGIN ADVENTURE' : 'CONTINUE',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameShell extends StatefulWidget {
  const GameShell({super.key, required this.state});
  final GameState state;
  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  int tab = 0;
  late final pages = [
    WorldMap(state: widget.state),
    Laboratory(state: widget.state),
    Journal(state: widget.state),
    CollectionScreen(state: widget.state),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: tab, children: pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab,
      onDestinationSelected: (value) => setState(() => tab = value),
      backgroundColor: const Color(0xFF0B383C),
      indicatorColor: gold,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map, color: teal),
          label: 'Map',
        ),
        NavigationDestination(
          icon: Icon(Icons.science_outlined),
          selectedIcon: Icon(Icons.science, color: teal),
          label: 'Lab',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book, color: teal),
          label: 'Story',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_mosaic_outlined),
          selectedIcon: Icon(Icons.auto_awesome_mosaic, color: teal),
          label: 'Collection',
        ),
      ],
    ),
  );
}

class WorldMap extends StatelessWidget {
  const WorldMap({super.key, required this.state});
  final GameState state;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: AnimatedBuilder(
      animation: state,
      builder: (_, _) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.filter_vintage, color: gold),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'WILD BLOOM',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: cream,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ResourcePill(
                  Icons.backpack,
                  '${state.inventory.values.fold(0, (a, b) => a + b)}',
                ),
                const SizedBox(width: 8),
                ResourcePill(Icons.auto_awesome, '${state.restored.length}/4'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'THE WILD HEART',
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'CHOOSE A REGION',
                        style: TextStyle(
                          color: cream,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: const Color(0xFFE09A4A),
                  child: const Icon(Icons.pets, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/art/australia_map.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x66052A2E)],
                        ),
                      ),
                    ),
                  ),
                  ...regions.indexed.map((entry) {
                    final region = entry.$2;
                    final unlocked = state.regionUnlocked(region.id);
                    final restored = state.restored.contains(region.id);
                    return Positioned(
                      left: box.maxWidth * region.x - 30,
                      top: box.maxHeight * region.y - 30,
                      child: RegionMarker(
                        region: region,
                        unlocked: unlocked,
                        restored: restored,
                        onTap: unlocked
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegionScreen(
                                    region: region,
                                    state: state,
                                  ),
                                ),
                              )
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Restore the previous region first.',
                                  ),
                                ),
                              ),
                      ),
                    );
                  }),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 18,
                    child: Card(
                      color: const Color(0xE60B383C),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: gold,
                              child: Icon(Icons.pets, color: teal),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.restored.isEmpty
                                    ? '"The forest is calling, Bloomkeeper!" - Pip'
                                    : state.restored.length == 4
                                    ? '"You did it! Australia is blooming again!" - Pip'
                                    : '"Another path is opening. Let us keep going!" - Pip',
                                style: const TextStyle(
                                  color: cream,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class RegionScreen extends StatelessWidget {
  const RegionScreen({super.key, required this.region, required this.state});
  final Region region;
  final GameState state;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: AnimatedBuilder(
      animation: state,
      builder: (_, _) {
        final restored = state.restored.contains(region.id);
        final recipe = recipeById(region.recipeId);
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: region.color,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [region.color, teal]),
                  ),
                  child: Icon(region.icon, size: 112, color: Colors.white54),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList.list(
                children: [
                  Text(
                    restored
                        ? 'REGION RESTORED'
                        : region.subtitle.toUpperCase(),
                    style: TextStyle(
                      color: restored ? gold : region.color,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    region.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 31,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: cream,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    region.story,
                    style: const TextStyle(
                      color: pale,
                      fontSize: 16,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 22),
                  NpcCard(regionId: region.id, restored: restored),
                  const SizedBox(height: 22),
                  const SectionTitle('AVAILABLE INGREDIENTS'),
                  const SizedBox(height: 10),
                  Row(
                    children: region.resources
                        .map(
                          (id) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IngredientCard(
                                ingredient: ingredientById(id),
                                count: state.count(id),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  if (!restored)
                    FilledButton.icon(
                      key: const Key('start-expedition'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GatherGame(region: region, state: state),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: region.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(18),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'START GATHERING EXPEDITION',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: gold),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This habitat is flourishing again.',
                              style: TextStyle(
                                color: cream,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => showRecipe(context, recipe, state),
                    icon: const Icon(Icons.menu_book),
                    label: Text('VIEW ${recipe.name.toUpperCase()} RECIPE'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

class GatherGame extends StatefulWidget {
  const GatherGame({super.key, required this.region, required this.state});
  final Region region;
  final GameState state;
  @override
  State<GatherGame> createState() => _GatherGameState();
}

class _GatherGameState extends State<GatherGame>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int time = 20;
  int hits = 0;
  int perfects = 0;
  bool done = false;
  Timer? timer;
  final random = Random();
  late String current;

  @override
  void initState() {
    super.initState();
    current = widget.region.resources.first;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..repeat(reverse: true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (time <= 1) {
        finish();
      } else {
        setState(() => time--);
      }
    });
  }

  void collect() {
    if (done) return;
    final value = controller.value;
    final distance = (value - .5).abs();
    if (distance < .23) {
      setState(() {
        hits++;
        if (distance < .09) perfects++;
        current = widget
            .region
            .resources[random.nextInt(widget.region.resources.length)];
      });
    }
  }

  void finish() {
    if (done) return;
    timer?.cancel();
    controller.stop();
    final rewards = <String, int>{};
    for (var i = 0; i < max(2, hits); i++) {
      final id = widget.region.resources[i % widget.region.resources.length];
      rewards[id] = (rewards[id] ?? 0) + 1;
    }
    widget.state.addRewards(rewards, perfects, widget.region.id);
    setState(() => done = true);
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredient = ingredientById(current);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: done
              ? ResultPanel(
                  region: widget.region,
                  hits: hits,
                  perfects: perfects,
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                        const Spacer(),
                        ResourcePill(Icons.timer, '${time}s'),
                        const SizedBox(width: 8),
                        ResourcePill(Icons.auto_awesome, '$perfects'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'GATHER ${ingredient.name.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: cream,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Tap while the spark is inside the golden zone',
                      style: TextStyle(color: pale),
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Container(
                        key: ValueKey(current),
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ingredient.color.withValues(alpha: .2),
                          boxShadow: [
                            BoxShadow(
                              color: ingredient.color.withValues(alpha: .35),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: Icon(
                          ingredient.icon,
                          color: ingredient.color,
                          size: 92,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 58,
                      child: LayoutBuilder(
                        builder: (_, box) => Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            Positioned(
                              left: box.maxWidth * .38,
                              width: box.maxWidth * .24,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: gold.withValues(alpha: .4),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: controller,
                              builder: (_, _) => Positioned(
                                left: controller.value * (box.maxWidth - 24),
                                top: 5,
                                child: Container(
                                  width: 24,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: cream,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(color: gold, blurRadius: 12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const Key('collect-button'),
                        onPressed: collect,
                        style: FilledButton.styleFrom(
                          backgroundColor: ingredient.color,
                          foregroundColor: teal,
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Text(
                          'COLLECT!',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: finish,
                      child: const Text('Finish expedition'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ResultPanel extends StatelessWidget {
  const ResultPanel({
    super.key,
    required this.region,
    required this.hits,
    required this.perfects,
  });
  final Region region;
  final int hits, perfects;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 54,
          backgroundColor: gold,
          child: const Icon(Icons.backpack, color: teal, size: 54),
        ),
        const SizedBox(height: 20),
        const Text(
          'EXPEDITION COMPLETE!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: cream,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${max(2, hits)} ingredients gathered | $perfects perfect taps',
          style: const TextStyle(color: pale),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('RETURN TO REGION'),
        ),
      ],
    ),
  );
}

class Laboratory extends StatelessWidget {
  const Laboratory({super.key, required this.state});
  final GameState state;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: AnimatedBuilder(
      animation: state,
      builder: (_, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const GameLogo(),
          const SizedBox(height: 24),
          const ScreenTitle(
            kicker: 'THE BLOOM LABORATORY',
            title: 'BREW RESTORATION',
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF7754B3), Color(0xFF20A69D)],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.science, color: cream, size: 96),
                Positioned(top: 25, left: 55, child: Spark(size: 12)),
                Positioned(bottom: 35, right: 65, child: Spark(size: 16)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: SectionTitle('RECIPE BOOK')),
              Text(
                '${state.crafted.length}/${recipes.length}',
                style: const TextStyle(
                  color: gold,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recipes.map((recipe) => RecipeCard(recipe: recipe, state: state)),
          const SizedBox(height: 22),
          const SectionTitle('INGREDIENT SATCHEL'),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: ingredients
                .map(
                  (item) => IngredientCard(
                    ingredient: item,
                    count: state.count(item.id),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.state});
  final Recipe recipe;
  final GameState state;
  @override
  Widget build(BuildContext context) {
    final unlocked = state.regionUnlocked(recipe.regionId);
    final ready = state.canCraft(recipe);
    final crafted = state.crafted.contains(recipe.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: unlocked ? () => showRecipe(context, recipe, state) : null,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: recipe.color.withValues(alpha: .2),
                child: Icon(
                  crafted
                      ? Icons.check
                      : unlocked
                      ? Icons.science
                      : Icons.lock,
                  color: recipe.color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        color: cream,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      crafted
                          ? 'Brewed and region restored'
                          : !unlocked
                          ? 'Discover this region first'
                          : ready
                          ? 'Ready to brew'
                          : 'Gather more ingredients',
                      style: TextStyle(
                        color: crafted || ready ? gold : pale,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showRecipe(
  BuildContext context,
  Recipe recipe,
  GameState state,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => AnimatedBuilder(
      animation: state,
      builder: (_, _) {
        final ready = state.canCraft(recipe);
        final crafted = state.crafted.contains(recipe.id);
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: recipe.color.withValues(alpha: .2),
                    child: Icon(Icons.science, color: recipe.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recipe.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        color: cream,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recipe.description,
                style: const TextStyle(color: pale, height: 1.4),
              ),
              const SizedBox(height: 20),
              ...recipe.ingredients.entries.map((entry) {
                final ingredient = ingredientById(entry.key);
                final have = state.count(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(ingredient.icon, color: ingredient.color),
                      const SizedBox(width: 10),
                      Expanded(child: Text(ingredient.name)),
                      Text(
                        '$have / ${entry.value}',
                        style: TextStyle(
                          color: have >= entry.value ? gold : Colors.redAccent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('brew-button'),
                  onPressed: crafted || !ready
                      ? null
                      : () {
                          state.craft(recipe);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${recipe.name} restored ${regionById(recipe.regionId).name}!',
                              ),
                            ),
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: recipe.color,
                    foregroundColor: teal,
                    padding: const EdgeInsets.all(17),
                  ),
                  icon: Icon(crafted ? Icons.check : Icons.auto_awesome),
                  label: Text(
                    crafted
                        ? 'ALREADY BREWED'
                        : ready
                        ? 'BREW POTION'
                        : 'INGREDIENTS MISSING',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class Journal extends StatelessWidget {
  const Journal({super.key, required this.state});
  final GameState state;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: AnimatedBuilder(
      animation: state,
      builder: (_, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const GameLogo(),
          const SizedBox(height: 24),
          const ScreenTitle(
            kicker: 'QUESTS AND COMPANIONS',
            title: 'FIELD JOURNAL',
          ),
          const SizedBox(height: 18),
          const CompanionCard(),
          const SizedBox(height: 24),
          const SectionTitle('REGION STORIES'),
          const SizedBox(height: 10),
          ...regions.indexed.map((entry) {
            final region = entry.$2;
            final unlocked = state.regionUnlocked(region.id);
            final restored = state.restored.contains(region.id);
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                enabled: unlocked,
                leading: CircleAvatar(
                  backgroundColor: region.color.withValues(alpha: .2),
                  child: Icon(
                    restored
                        ? Icons.check
                        : unlocked
                        ? region.icon
                        : Icons.lock,
                    color: region.color,
                  ),
                ),
                title: Text(
                  region.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  restored
                      ? 'Chapter complete'
                      : unlocked
                      ? region.subtitle
                      : 'Locked',
                ),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                children: [
                  Text(
                    region.story,
                    style: const TextStyle(color: pale, height: 1.4),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 18),
          const SectionTitle('ACTIVE QUESTS'),
          const SizedBox(height: 10),
          QuestCard(
            title: 'A Botanist Begins',
            body: 'Discover 4 different ingredients.',
            current: state.discovered.length,
            goal: 4,
            icon: Icons.eco,
          ),
          QuestCard(
            title: 'Steady Hands',
            body: 'Land 10 perfect gathering taps.',
            current: state.totalPerfects,
            goal: 10,
            icon: Icons.adjust,
          ),
          QuestCard(
            title: 'Healing Country',
            body: 'Restore all four habitats.',
            current: state.restored.length,
            goal: 4,
            icon: Icons.public,
          ),
        ],
      ),
    ),
  );
}

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key, required this.state});
  final GameState state;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: AnimatedBuilder(
      animation: state,
      builder: (_, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const GameLogo(),
          const SizedBox(height: 24),
          const ScreenTitle(kicker: 'YOUR ADVENTURE', title: 'COLLECTIONS'),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  '${state.expeditions}',
                  'EXPEDITIONS',
                  Icons.hiking,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  '${state.discovered.length}/8',
                  'INGREDIENTS',
                  Icons.local_florist,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  '${state.crafted.length}/4',
                  'POTIONS',
                  Icons.science,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('FIELD GUIDE'),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: ingredients
                .map(
                  (item) => IngredientCard(
                    ingredient: item,
                    count: state.count(item.id),
                    hidden: !state.discovered.contains(item.id),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          const SectionTitle('RARE WONDERS'),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final found = state.rares.contains('${regions[i].id}-gem');
                return Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        found ? Icons.diamond : Icons.help_outline,
                        color: found ? regions[i].color : Colors.white24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        found
                            ? '${regions[i].name.split(' ').first} Gem'
                            : 'Unknown',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: pale),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('ACHIEVEMENTS'),
          const SizedBox(height: 10),
          if (state.achievements.isEmpty)
            const EmptyCard(
              'Your first achievement is just one expedition away.',
            ),
          ...state.achievements.map(
            (name) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: gold,
                  child: Icon(Icons.emoji_events, color: teal),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                trailing: const Icon(Icons.check_circle, color: gold),
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () => confirmReset(context, state),
            child: const Text(
              'Reset adventure',
              style: TextStyle(color: Colors.white38),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> confirmReset(BuildContext context, GameState state) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Reset adventure?'),
      content: const Text(
        'All local progress, ingredients, potions, and discoveries will be removed.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  if (yes == true) await state.reset();
}

class GameLogo extends StatelessWidget {
  const GameLogo({super.key});
  @override
  Widget build(BuildContext context) => const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.filter_vintage, color: gold),
      SizedBox(width: 7),
      Text(
        'AUSSIE WILD',
        style: TextStyle(
          color: cream,
          fontWeight: FontWeight.w900,
          letterSpacing: .5,
        ),
      ),
      Text(
        ' BLOOM',
        style: TextStyle(
          color: gold,
          fontWeight: FontWeight.w900,
          letterSpacing: .5,
        ),
      ),
    ],
  );
}

class ResourcePill extends StatelessWidget {
  const ResourcePill(this.icon, this.value, {super.key});
  final IconData icon;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xCC0B383C),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: gold, size: 17),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(color: cream, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}

class RegionMarker extends StatelessWidget {
  const RegionMarker({
    super.key,
    required this.region,
    required this.unlocked,
    required this.restored,
    required this.onTap,
  });
  final Region region;
  final bool unlocked, restored;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: unlocked ? region.color : Colors.blueGrey,
            border: Border.all(color: restored ? gold : Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .35),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            restored
                ? Icons.check
                : unlocked
                ? region.icon
                : Icons.lock,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xDD082F34),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            region.name.split(' ').first,
            style: const TextStyle(
              color: cream,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    ),
  );
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.kicker, required this.title});
  final String kicker, title;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        kicker,
        style: const TextStyle(
          color: gold,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      Text(
        title,
        style: const TextStyle(
          color: cream,
          fontSize: 30,
          height: 1,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: cream,
      fontWeight: FontWeight.w900,
      fontSize: 17,
    ),
  );
}

class IngredientCard extends StatelessWidget {
  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.count,
    this.hidden = false,
  });
  final Ingredient ingredient;
  final int count;
  final bool hidden;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          hidden ? Icons.question_mark : ingredient.icon,
          color: hidden ? Colors.white24 : ingredient.color,
        ),
        const SizedBox(height: 5),
        Text(
          hidden ? '???' : ingredient.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: pale,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (!hidden)
          Text(
            'x$count',
            style: const TextStyle(
              color: cream,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
      ],
    ),
  );
}

class NpcCard extends StatelessWidget {
  const NpcCard({super.key, required this.regionId, required this.restored});
  final String regionId;
  final bool restored;
  @override
  Widget build(BuildContext context) {
    final data = {
      'forest': ('Elder Fern', 'The roots remember every kindness.'),
      'desert': ('Marlu', 'Stone keeps water safer than any jar.'),
      'coast': ('Kai', 'A healthy reef sings beneath the waves.'),
      'mountain': ('Ayla', 'The highest blooms need the gentlest magic.'),
    }[regionId]!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: gold,
              child: Icon(
                restored ? Icons.sentiment_very_satisfied : Icons.person,
                color: teal,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.$1,
                    style: const TextStyle(
                      color: cream,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    restored
                        ? 'Thank you, Bloomkeeper. Life has returned!'
                        : '"${data.$2}"',
                    style: const TextStyle(color: pale, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Spark extends StatelessWidget {
  const Spark({super.key, required this.size});
  final double size;
  @override
  Widget build(BuildContext context) =>
      Icon(Icons.auto_awesome, color: gold, size: size);
}

class CompanionCard extends StatelessWidget {
  const CompanionCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        colors: [Color(0xFFD98942), Color(0xFF7C4A7E)],
      ),
    ),
    child: const Row(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: gold,
          child: Icon(Icons.pets, color: teal, size: 34),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PIP THE KANGAROO',
                style: TextStyle(
                  color: cream,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              Text(
                'Curious, quick, and always ready with a clue. Pip carries your ingredient satchel.',
                style: TextStyle(color: cream, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.title,
    required this.body,
    required this.current,
    required this.goal,
    required this.icon,
  });
  final String title, body;
  final int current, goal;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final value = (current / goal).clamp(0.0, 1.0);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: gold.withValues(alpha: .2),
              child: Icon(icon, color: gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: cream,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(body, style: const TextStyle(color: pale, fontSize: 12)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: value,
                    color: gold,
                    backgroundColor: Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${min(current, goal)}/$goal',
              style: const TextStyle(color: gold, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard(this.value, this.label, this.icon, {super.key});
  final String value, label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: gold),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: cream,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: pale,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  );
}

class EmptyCard extends StatelessWidget {
  const EmptyCard(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_outlined, color: gold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: pale)),
          ),
        ],
      ),
    ),
  );
}
