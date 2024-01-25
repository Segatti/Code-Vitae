import 'dart:convert';

class Training {
  final String? name;
  final num? quantityExercises;
  
  const Training({
    this.name,
    this.quantityExercises,
  });

  Training copyWith({
    String? name,
    num? quantityExercises,
  }) {
    return Training(
      name: name ?? this.name,
      quantityExercises: quantityExercises ?? this.quantityExercises,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'quantityExercises': quantityExercises,
    };
  }

  factory Training.fromMap(Map<String, dynamic> map) {
    return Training(
      name: map['name'] != null ? map['name'] as String : null,
      quantityExercises: map['quantityExercises'] != null ? map['quantityExercises'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Training.fromJson(String source) => Training.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Training(name: $name, quantityExercises: $quantityExercises)';

  @override
  bool operator ==(covariant Training other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.quantityExercises == quantityExercises;
  }

  @override
  int get hashCode => name.hashCode ^ quantityExercises.hashCode;
}
