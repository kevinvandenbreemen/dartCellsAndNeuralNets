import 'package:neural_net_experiments/src/cell/CellTypes.dart';
import 'package:neural_net_experiments/src/reality/reality.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

main() {
  group('Tissue Interconnections', () {
    test('Keeps track of X_T (connections in which tissue T is involved)', () {
      Tissue t1 = Tissue();
      Tissue t2 = Tissue();

      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.0);

      expect(Reality.get().X(t1), isNotNull);
    });

    test('Chi divides into set of Chi where T is destination', () {
      Tissue t1 = Tissue();
      Tissue t2 = Tissue();

      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.0);

      expect(Reality.get().X(t2).tIn, isNotNull);
      expect(Reality.get().X(t2).tIn.length, equals(1));
      expect(Reality.get().X(t2).tIn[0].to, equals(t2));
    });

    test('Chi divides into set of Chi where T is origin', () {
      Tissue t1 = Tissue();
      Tissue t2 = Tissue();

      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.0);

      expect(Reality.get().X(t1).tOut, isNotNull);
      expect(Reality.get().X(t1).tOut.length, equals(1));
      expect(Reality.get().X(t1).tOut[0].from, equals(t1));
    });
  });
}
