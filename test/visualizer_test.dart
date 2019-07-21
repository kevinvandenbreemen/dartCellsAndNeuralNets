import 'package:neural_net_experiments/src/cell/CellTypes.dart';
import 'package:neural_net_experiments/src/debug/Visualizer.dart';
import 'package:neural_net_experiments/src/tissue/ConnectionTypes.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';
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

      tissue.join(from: 0, to: 1, strength: 0.2, type: DIRECTED);
      tissue.join(from: 1, to: 2, strength: 12.2, type: DIRECTED);
      tissue.join(from: 2, to: 3, strength: 0.7, type: DIRECTED);
      tissue.join(from: 3, to: 0, strength: 1.0, type: DIRECTED);

      print(visualizer.toDot(tissue));
    });

  });
}