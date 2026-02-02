import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/game.dart';
import '../domain/participant.dart';

part 'game_repository.g.dart';

class GameRepository {
  GameRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _gamesCollection =>
      _firestore.collection('games');

  // ==================== Game CRUD Operations ====================

  /// Create a new game
  Future<String> createGame(Game game) async {
    final docRef = _gamesCollection.doc();
    final gameWithId = game.copyWith(
      gameId: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await docRef.set(gameWithId.toJson());
    return docRef.id;
  }

  /// Get a single game by ID
  Future<Game?> getGame(String gameId) async {
    final doc = await _gamesCollection.doc(gameId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Game.fromJson(doc.data()!);
  }

  /// Watch a single game (real-time updates)
  Stream<Game?> watchGame(String gameId) {
    return _gamesCollection.doc(gameId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return Game.fromJson(snapshot.data()!);
    });
  }

  /// Update a game
  Future<void> updateGame(Game game) async {
    final updatedGame = game.copyWith(updatedAt: DateTime.now());
    await _gamesCollection.doc(game.gameId).update(updatedGame.toJson());
  }

  /// Delete a game
  Future<void> deleteGame(String gameId) async {
    // Delete all participants first
    final participants = await _gamesCollection
        .doc(gameId)
        .collection('participants')
        .get();
    
    final batch = _firestore.batch();
    for (final doc in participants.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_gamesCollection.doc(gameId));
    await batch.commit();
  }

  // ==================== Query Operations ====================

  /// Get all open games
  Stream<List<Game>> watchOpenGames({
    String? sport,
    String? genderRule,
    DateTime? fromDate,
  }) {
    Query<Map<String, dynamic>> query = _gamesCollection
        .where('status', isEqualTo: 'open')
        .orderBy('dateTime');

    if (sport != null) {
      query = query.where('sport', isEqualTo: sport);
    }

    if (genderRule != null) {
      query = query.where('genderRule', isEqualTo: genderRule);
    }

    if (fromDate != null) {
      query = query.where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate));
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromJson(doc.data()))
          .toList();
    });
  }

  /// Get games organized by a specific user
  Stream<List<Game>> watchUserOrganizedGames(String organizerId) {
    return _gamesCollection
        .where('organizerId', isEqualTo: organizerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromJson(doc.data()))
          .toList();
    });
  }

  // ==================== Participant Operations ====================

  /// Add a participant to a game
  Future<void> joinGame({
    required String gameId,
    required String userId,
  }) async {
    final gameRef = _gamesCollection.doc(gameId);
    final participantRef = gameRef.collection('participants').doc(userId);

    // Use transaction to ensure atomicity
    await _firestore.runTransaction((transaction) async {
      final gameDoc = await transaction.get(gameRef);
      
      if (!gameDoc.exists) {
        throw Exception('Game not found');
      }

      final game = Game.fromJson(gameDoc.data()!);
      
      if (game.isFull) {
        throw Exception('Game is full');
      }

      if (game.status != 'open') {
        throw Exception('Game is not open for registration');
      }

      // Add participant
      final participant = Participant(
        userId: userId,
        gameId: gameId,
        status: 'confirmed',
        joinedAt: DateTime.now(),
        paid: false,
      );
      transaction.set(participantRef, participant.toJson());

      // Increment player count
      transaction.update(gameRef, {
        'currentPlayers': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update status to full if needed
      if (game.currentPlayers + 1 >= game.maxPlayers) {
        transaction.update(gameRef, {'status': 'full'});
      }
    });
  }

  /// Leave a game
  Future<void> leaveGame({
    required String gameId,
    required String userId,
  }) async {
    final gameRef = _gamesCollection.doc(gameId);
    final participantRef = gameRef.collection('participants').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final participantDoc = await transaction.get(participantRef);
      
      if (!participantDoc.exists) {
        throw Exception('Not a participant of this game');
      }

      // Remove participant
      transaction.delete(participantRef);

      // Decrement player count
      transaction.update(gameRef, {
        'currentPlayers': FieldValue.increment(-1),
        'status': 'open', // Reopen game if it was full
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Get all participants of a game
  Stream<List<Participant>> watchGameParticipants(String gameId) {
    return _gamesCollection
        .doc(gameId)
        .collection('participants')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Participant.fromJson(doc.data()))
          .toList();
    });
  }

  /// Get games a user has joined
  Stream<List<Game>> watchUserJoinedGames(String userId) async* {
    // This is a bit complex - we need to query all games where user is a participant
    // Since Firestore doesn't support collection group queries easily in subcollections,
    // we'll use a different approach: query participants where userId matches,
    // then fetch the games
    
    // Note: This is simplified. In production, consider maintaining a user_games
    // collection for better performance
    final allGames = await _gamesCollection
        .where('status', whereIn: ['open', 'full'])
        .get();

    final gameIds = <String>[];
    
    for (final gameDoc in allGames.docs) {
      final participantDoc = await gameDoc.reference
          .collection('participants')
          .doc(userId)
          .get();
      
      if (participantDoc.exists) {
        gameIds.add(gameDoc.id);
      }
    }

    if (gameIds.isEmpty) {
      yield [];
      return;
    }

    // Watch these games
    yield* _gamesCollection
        .where(FieldPath.documentId, whereIn: gameIds)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromJson(doc.data()))
          .toList();
    });
  }

  /// Update participant payment status
  Future<void> updateParticipantPayment({
    required String gameId,
    required String userId,
    required bool paid,
    String? transactionId,
  }) async {
    await _gamesCollection
        .doc(gameId)
        .collection('participants')
        .doc(userId)
        .update({
      'paid': paid,
      'status': paid ? 'paid' : 'confirmed',
      if (transactionId != null) 'paymentTransactionId': transactionId,
    });
  }
}

@Riverpod(keepAlive: true)
GameRepository gameRepository(GameRepositoryRef ref) {
  return GameRepository(FirebaseFirestore.instance);
}
