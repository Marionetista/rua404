enum FilterType {
  todos('Todos'),
  novos('Novos'),
  collabs('Collabs'),
  classicos('Clássicos'),
  prints('Prints'),
  // quadrinhos('Quadrinhos'),
  stickers('Stickers');

  const FilterType(this.label);
  final String label;
}
