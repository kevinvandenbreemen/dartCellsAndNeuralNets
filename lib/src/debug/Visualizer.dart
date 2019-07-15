import 'package:gviz/gviz.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';


class Visualizer {

  String _nodeName(Tissue tissue, int index) {
    return "${tissue.type(of: index)} $index";
  }

  String toDot(Tissue tissue) {
    final graph = Gviz();

    for(var i=0; i<tissue.cellCount; i++) {
      
      //  Node
      String cellName = _nodeName(tissue, i); 
      graph.addNode(cellName);

      //  Edges from this node
      tissue.endpoints(i).forEach((index) {
        String endPoint = _nodeName(tissue, index);
        graph.addEdge(cellName, endPoint);
      });
    }

    return graph.toString();
  }

}