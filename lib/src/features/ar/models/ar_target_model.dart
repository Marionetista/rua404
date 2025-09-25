class ARTarget {
  factory ARTarget.fromJson(Map<String, dynamic> json) => ARTarget(
    id: json['id'] as String,
    imagePath: json['image_path'] as String,
    videoPath: json['video_path'] as String,
    width: (json['width'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
  );
  const ARTarget({
    required this.id,
    required this.imagePath,
    required this.videoPath,
    required this.width,
    required this.height,
  });

  final String id;
  final String imagePath;
  final String videoPath;
  final double width;
  final double height;

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_path': imagePath,
    'video_path': videoPath,
    'width': width,
    'height': height,
  };
}

class ARTargetsConfig {
  factory ARTargetsConfig.fromJson(Map<String, dynamic> json) {
    final targetsList =
        (json['targets'] as List)
            .map(
              (targetJson) =>
                  ARTarget.fromJson(targetJson as Map<String, dynamic>),
            )
            .toList();

    return ARTargetsConfig(targets: targetsList);
  }
  const ARTargetsConfig({required this.targets});

  final List<ARTarget> targets;

  Map<String, dynamic> toJson() => {
    'targets': targets.map((target) => target.toJson()).toList(),
  };
}

