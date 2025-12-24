class HealthDataModel {
  final int steps;
  final double caloriesBurned;
  final DateTime lastUpdated;

  HealthDataModel({
    required this.steps,
    required this.caloriesBurned,
    required this.lastUpdated,
  });

  factory HealthDataModel.empty() {
    return HealthDataModel(
      steps: 0,
      caloriesBurned: 0,
      lastUpdated: DateTime.now(),
    );
  }

  HealthDataModel copyWith({
    int? steps,
    double? caloriesBurned,
    DateTime? lastUpdated,
  }) {
    return HealthDataModel(
      steps: steps ?? this.steps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      steps: json['steps'] as int? ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  String toString() {
    return 'HealthDataModel(steps: $steps, caloriesBurned: $caloriesBurned, lastUpdated: $lastUpdated)';
  }
}