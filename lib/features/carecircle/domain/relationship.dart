enum Relationship {
  child('Hija o hijo'),
  grandchild('Nieta o nieto'),
  nibling('Sobrina o sobrino'),
  sibling('Hermana o hermano'),
  childInLaw('Nuera o yerno'),
  other('Otro');

  final String label;

  const Relationship(this.label);

  String get storedLabel {
    return this == Relationship.other ? 'familiar' : label.toLowerCase();
  }

  static String display(String? storedLabel) {
    if (storedLabel == null || storedLabel.trim().isEmpty) {
      return 'Familiar';
    }
    final String label = storedLabel.trim();
    return label[0].toUpperCase() + label.substring(1);
  }
}
