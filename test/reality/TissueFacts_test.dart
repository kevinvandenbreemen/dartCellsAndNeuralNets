import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
import 'package:neuralNetExperiments/src/reality/context.dart';
import 'package:neuralNetExperiments/src/reality/tissue/tissue_facts.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

main() {

  group('Local Tissue Reality', () {

    Tissue tissue;

    setUp((){
      tissue = Tissue();
    });

    test('Determines if there are less than 5 cells in my tissue', (){
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);
      
      TissueCellCountLessThan count = TissueCellCountLessThan(5);
      expect(count.evaluate(RealityContext(tissue)), isTrue);

    });

  });
  
}