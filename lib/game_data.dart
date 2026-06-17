import 'package:flutter/material.dart';

class Region {
  const Region({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.story,
    required this.color,
    required this.icon,
    required this.x,
    required this.y,
    required this.resources,
    required this.recipeId,
  });
  final String id;
  final String name;
  final String subtitle;
  final String story;
  final Color color;
  final IconData icon;
  final double x;
  final double y;
  final List<String> resources;
  final String recipeId;
}

class Ingredient {
  const Ingredient(this.id, this.name, this.type, this.icon, this.color);
  final String id;
  final String name;
  final String type;
  final IconData icon;
  final Color color;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.regionId,
    required this.description,
    required this.ingredients,
    required this.color,
  });
  final String id;
  final String name;
  final String regionId;
  final String description;
  final Map<String, int> ingredients;
  final Color color;
}

const ingredients = <Ingredient>[
  Ingredient(
    'wattle',
    'Golden Wattle',
    'Plant',
    Icons.local_florist,
    Color(0xFFFFD34E),
  ),
  Ingredient(
    'eucalyptus',
    'Eucalyptus Leaf',
    'Plant',
    Icons.eco,
    Color(0xFF63C77C),
  ),
  Ingredient(
    'waratah',
    'Crimson Waratah',
    'Plant',
    Icons.filter_vintage,
    Color(0xFFFF6174),
  ),
  Ingredient(
    'quartz',
    'Sun Quartz',
    'Mineral',
    Icons.diamond,
    Color(0xFFFFB55E),
  ),
  Ingredient('opal', 'Moon Opal', 'Mineral', Icons.hexagon, Color(0xFFAE8DFF)),
  Ingredient(
    'coral',
    'Tide Coral',
    'Catalyst',
    Icons.bubble_chart,
    Color(0xFF55DDE0),
  ),
  Ingredient(
    'dew',
    'Spirit Dew',
    'Catalyst',
    Icons.water_drop,
    Color(0xFF75B9FF),
  ),
  Ingredient('snowmoss', 'Snow Moss', 'Plant', Icons.grass, Color(0xFFA8E6CF)),
];

const regions = <Region>[
  Region(
    id: 'forest',
    name: 'Whispering Forest',
    subtitle: 'The first green spark',
    story:
        'A strange silver hush has fallen over the eucalyptus groves. Help Elder Fern wake the roots and return birdsong to the canopy.',
    color: Color(0xFF48B86B),
    icon: Icons.forest,
    x: .72,
    y: .34,
    resources: ['wattle', 'eucalyptus', 'dew'],
    recipeId: 'verdant',
  ),
  Region(
    id: 'desert',
    name: 'Sunstone Desert',
    subtitle: 'Heat beneath the red earth',
    story:
        'The desert springs have vanished. Gather sunlit minerals and brew a draught strong enough to call water back through ancient stone.',
    color: Color(0xFFF28C45),
    icon: Icons.wb_sunny,
    x: .36,
    y: .38,
    resources: ['quartz', 'wattle', 'opal'],
    recipeId: 'sunwell',
  ),
  Region(
    id: 'coast',
    name: 'Coral Coast',
    subtitle: 'A reef without colour',
    story:
        'The tide pools are fading. Kai the turtle keeper needs a luminous tonic to restore the reef before the next moonrise.',
    color: Color(0xFF36BED0),
    icon: Icons.waves,
    x: .27,
    y: .68,
    resources: ['coral', 'dew', 'eucalyptus'],
    recipeId: 'tideglow',
  ),
  Region(
    id: 'mountain',
    name: 'Moonpeak Range',
    subtitle: 'The final sleeping bloom',
    story:
        'Cold mist seals the high pass. Only the rare Moonbloom Elixir can awaken the alpine sanctuary and heal the whole wild heart.',
    color: Color(0xFF8D83DE),
    icon: Icons.landscape,
    x: .68,
    y: .72,
    resources: ['snowmoss', 'opal', 'waratah'],
    recipeId: 'moonbloom',
  ),
];

const recipes = <Recipe>[
  Recipe(
    id: 'verdant',
    name: 'Verdant Remedy',
    regionId: 'forest',
    description: 'Wakes roots and restores the forest canopy.',
    ingredients: {'wattle': 2, 'eucalyptus': 2, 'dew': 1},
    color: Color(0xFF62D782),
  ),
  Recipe(
    id: 'sunwell',
    name: 'Sunwell Draught',
    regionId: 'desert',
    description: 'Draws cool water through sun-warmed stone.',
    ingredients: {'quartz': 2, 'wattle': 1, 'opal': 1},
    color: Color(0xFFFFA74F),
  ),
  Recipe(
    id: 'tideglow',
    name: 'Tideglow Tonic',
    regionId: 'coast',
    description: 'Returns colour and vitality to coral gardens.',
    ingredients: {'coral': 2, 'dew': 2, 'eucalyptus': 1},
    color: Color(0xFF4CDDE3),
  ),
  Recipe(
    id: 'moonbloom',
    name: 'Moonbloom Elixir',
    regionId: 'mountain',
    description: 'Melts the silver mist and heals the wild heart.',
    ingredients: {'snowmoss': 2, 'opal': 2, 'waratah': 1},
    color: Color(0xFFA894FF),
  ),
];

Ingredient ingredientById(String id) =>
    ingredients.firstWhere((item) => item.id == id);
Region regionById(String id) => regions.firstWhere((item) => item.id == id);
Recipe recipeById(String id) => recipes.firstWhere((item) => item.id == id);
