import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
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

  });
}
