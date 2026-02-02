import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'game.freezed.dart';
part 'game.g.dart';

/// Represents a sports game/match
@freezed
class Game with _$Game {
  const factory Game({
    required String gameId,
    required String organizerId,
    
    /// Sport type (e.g., 'Football', 'Basketball', 'Padel')
    required String sport,
    
    /// Gender rule: 'men', 'women', or 'mixed'
    required String genderRule,
    
    /// Price per player in SAR
    required double price,
    
    /// Game date and time
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    required DateTime dateTime,
    
    /// Location name/address
    required String locationName,
    
    /// Geographic coordinates
    @JsonKey(
      fromJson: _geoPointFromJson,
      toJson: _geoPointToJson,
    )
    required GeoPoint coordinates,
    
    /// Maximum number of players
    required int maxPlayers,
    
    /// Current number of confirmed players
    @Default(0) int currentPlayers,
    
    /// Game status: 'open', 'full', 'cancelled', 'completed'
    @Default('open') String status,
    
    /// Optional description
    String? description,
    
    /// Creation timestamp
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? createdAt,
    
    /// Last update timestamp
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    DateTime? updatedAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

/// Helper: Convert Firestore Timestamp to DateTime
DateTime _dateTimeFromJson(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.now();
}

/// Helper: Convert DateTime to Firestore Timestamp
dynamic _dateTimeToJson(DateTime? dateTime) {
  if (dateTime == null) return FieldValue.serverTimestamp();
  return Timestamp.fromDate(dateTime);
}

/// Helper: Convert map to GeoPoint
GeoPoint _geoPointFromJson(dynamic value) {
  if (value is GeoPoint) return value;
  if (value is Map) {
    final lat = (value['latitude'] ?? value['_latitude'] ?? 0.0) as num;
    final lng = (value['longitude'] ?? value['_longitude'] ?? 0.0) as num;
    return GeoPoint(lat.toDouble(), lng.toDouble());
  }
  return const GeoPoint(0, 0);
}

/// Helper: Convert GeoPoint to map
Map<String, dynamic> _geoPointToJson(GeoPoint geoPoint) {
  return {
    'latitude': geoPoint.latitude,
    'longitude': geoPoint.longitude,
  };
}

/// Extension methods for Game
extension GameX on Game {
  /// Check if game is full
  bool get isFull => currentPlayers >= maxPlayers;
  
  /// Check if game is in the past
  bool get isPast => dateTime.isBefore(DateTime.now());
  
  /// Check if game is joinable
  bool get isJoinable => status == 'open' && !isFull && !isPast;
  
  /// Get slots remaining
  int get slotsRemaining => maxPlayers - currentPlayers;
  
  /// Get formatted location coordinates
  String get coordinatesString => '${coordinates.latitude}, ${coordinates.longitude}';
}
