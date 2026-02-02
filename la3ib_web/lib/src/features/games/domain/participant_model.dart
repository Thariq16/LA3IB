import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

/// Represents a participant in a game
@freezed
class Participant with _$Participant {
  const factory Participant({
    required String userId,
    required String gameId,
    
    /// Participation status: 'pending', 'confirmed', 'paid', 'cancelled'
    @Default('pending') String status,
    
    /// When the user joined
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    required DateTime joinedAt,
    
    /// Payment status
    @Default(false) bool paid,
    
    /// Payment amount (may differ from game price for early bird, etc.)
    double? paymentAmount,
    
    /// Payment transaction ID
    String? paymentTransactionId,
    
    /// Additional notes
    String? notes,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) => 
      _$ParticipantFromJson(json);
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

/// Extension methods for Participant
extension ParticipantX on Participant {
  /// Check if participant is confirmed
  bool get isConfirmed => status == 'confirmed' || status == 'paid';
  
  /// Check if participant has paid
  bool get hasPaid => paid && status == 'paid';
  
  /// Check if participant is pending
  bool get isPending => status == 'pending';
  
  /// Check if participant has cancelled
  bool get isCancelled => status == 'cancelled';
}
