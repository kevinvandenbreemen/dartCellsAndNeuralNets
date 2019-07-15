import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
import 'package:neuralNetExperiments/src/debug/Visualizer.dart';
import 'package:neuralNetExperiments/src/tissue/ConnectionTypes.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

main() {
  group('Tissue Visualization', (){

    Tissue tissue;

    Visualizer visualizer;

    setUp((){
      tissue = Tissue();
      visualizer = Visualizer(); 
    });

    test('Visualizes Tissue', (){
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(from: 0, to: 1, strength: 1.0, type: DIRECTED);
      tissue.join(from: 1, to: 2, strength: 1.0, type: DIRECTED);
      tissue.join(from: 2, to: 3, strength: 1.0, type: DIRECTED);
      tissue.join(from: 3, to: 0, strength: 1.0, type: DIRECTED);

      print(visualizer.toDot(tissue));
    });

  });
}