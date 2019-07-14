import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
import 'package:neuralNetExperiments/src/tissue/ConnectionTypes.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

void main() {
  group('Tissue', () {
    
    Tissue tissue;

    setUp((){
      tissue = Tissue();
    });

    test('Adds stem cell', () {
      tissue.add(STEM);

      expect(tissue.cellCount, equals(1));
    });

    test('Can connect one cell to another', () {
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(type: BIDIRECTIONAL, from: 0, to: 1, strength: 1.0);
      tissue.join(type: BIDIRECTIONAL, from: 0, to: 2, strength: 1.0);

      expect(tissue.endpoints(0), equals([1,2]));
    });

    test('respects bidirectional connections', () {
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(type: BIDIRECTIONAL, from: 0, to: 2, strength: 1.0);

      expect(tissue.endpoints(0), equals([2]));
      expect(tissue.endpoints(2), equals([0]));

    });

  });
}
