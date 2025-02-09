/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'package:test/test.dart';
import 'package:thedeck_common/the_deck_common.dart';

void main() {
  group('Pair', () {
    test('toMap() should return a valid map', () {
      // Arrange
      final pair = Pair.of<int, String>(42, 'Hello');

      // Act
      final map = pair.toMap();

      // Assert
      expect(map['first'], equals(42));
      expect(map['second'], equals('Hello'));
    });

    test('fromMap() should create a valid Pair object', () {
      // Arrange
      final map = {
        'first': 42,
        'second': 'Hello',
      };

      // Act
      final pair = Pair.fromMap(map);

      // Assert
      expect(pair.first, equals(42));
      expect(pair.second, equals('Hello'));
    });

    test('toMap() and fromMap() should be compatible', () {
      // Arrange
      final originalPair = Pair.of<int, String>(42, 'Hello');

      // Act
      final map = originalPair.toMap();
      final newPair = Pair.fromMap(map);

      // Assert
      expect(newPair.first, equals(originalPair.first));
      expect(newPair.second, equals(originalPair.second));
    });
  });
}
