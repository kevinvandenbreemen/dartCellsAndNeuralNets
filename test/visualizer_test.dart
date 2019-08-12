import 'package:neural_net_experiments/src/cell/CellTypes.dart';
import 'package:neural_net_experiments/src/debug/Visualizer.dart';
import 'package:neural_net_experiments/src/tissue/ConnectionTypes.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

main() {
  group('Tissue Visualization', () {
    Tissue tissue;

    Visualizer visualizer;

    setUp(() {
      tissue = Tissue();
      visualizer = Visualizer();
    });

    test('Visualizes connection from one tissue to another', () {
      Tissue tissueA = Tissue();
      Tissue tissueB = Tissue();

      tissueA.add(STEM);
      tissueA.add(STEM);
      tissueB.add(STEM);
      tissueB.add(STEM);

      tissueA.connectToTissue(tissueB, from: 0, to: 0, strength: 0.5);
      tissueA.connectToTissue(tissueB, from: 0, to: 1, strength: 0.9);

      tissueA.join(from: 0, to: 1, strength: 0.2, type: DIRECTED);
      tissueA.join(from: 1, to: 0, strength: 0.9, type: DIRECTED);
      tissueB.join(from: 0, to: 1, strength: 5, type: DIRECTED);

      String graphDot = visualizer.ofConnection(tissueA.connectedTissues()[0]);
      expect(graphDot, isNotNull);

      print(graphDot);
    });

    test('Visualizes Tissue', () {
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(from: 0, to: 1, strength: 0.2, type: DIRECTED);
      tissue.join(from: 1, to: 2, strength: 12.2, type: DIRECTED);
      tissue.join(from: 2, to: 3, strength: 0.7, type: DIRECTED);
      tissue.join(from: 3, to: 0, strength: 1.0, type: DIRECTED);

      print(visualizer.ofTissue(tissue));
    });

    test('Allows you to give a name for the network graph', () {

      visualizer = Visualizer(name: 'tissue_graph');

      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(from: 0, to: 1, strength: 0.2, type: DIRECTED);
      tissue.join(from: 1, to: 2, strength: 12.2, type: DIRECTED);
      tissue.join(from: 2, to: 3, strength: 0.7, type: DIRECTED);
      tissue.join(from: 3, to: 0, strength: 1.0, type: DIRECTED);

      print(visualizer.ofTissue(tissue));

      expect(visualizer.ofTissue(tissue).startsWith("digraph tissue_graph"), isTrue);
    });
  });
}
