import 'package:gviz/gviz.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';


class Visualizer {

  String _nodeName(Tissue tissue, int index) {
    return "${tissue.type(of: index)} $index";
  }

  int _weight(Tissue tissue, int from, int to) {
    double rawWeight = tissue.weight(from, to).abs();
    if (rawWeight < 0.1) {
      return 1;
    } else if(rawWeight <= 0.5) {
      return 2;
    } else if(rawWeight <= 1) {
      return 3;
    } else {
      return 4;
    }
  }

  double _width(Tissue tissue, int from, int to) {
    double rawWeight = tissue.weight(from, to).abs();
    if (rawWeight < 0.1) {
      return 0.1;
    } else if(rawWeight <= 0.5) {
      return 0.5;
    } else if(rawWeight <= 1) {
      return 1.0;
    } else {
      return 1.5;
    }
  }

  String _color(Tissue tissue, int from, int to) {
    double rawWeight = tissue.weight(from, to).abs();
    if(rawWeight > 0) {
      return "#00AA00";
    } else {
      return "#AA0000";
    }
  }

  String toDot(Tissue tissue) {
    final graph = Gviz();

    for(var i=0; i<tissue.cellCount; i++) {
      
      //  Node
      String cellName = _nodeName(tissue, i); 
      graph.addNode(cellName, properties: {'shape': 'circle'});

      //  Edges from this node
      tissue.endpoints(i).forEach((index) {
        String endPoint = _nodeName(tissue, index);
        graph.addEdge(cellName, endPoint, properties: {          
          'weight': "${_weight(tissue, i, index)}",
          'penwidth': "${_width(tissue, i, index)}",
          'color': _color(tissue, i, index)
        });
      });
    }

    return graph.toString();
  }

}