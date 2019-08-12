import 'package:neural_net_experiments/neural_net_experiments.dart';
import 'gviz.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';

class Visualizer {

  String _graphName = "the_graph";

  Visualizer({String name}) {
    if(name != null ){
      this._graphName = name;
    }
  }

  String _nodeName(Tissue tissue, int index) {
    return "${tissue.name}_${tissue.type(of: index)} $index";
  }

  int _weight(Tissue tissue, int from, int to) {
    double rawWeight = tissue.weight(from, to).abs();
    if (rawWeight < 0.1) {
      return 1;
    } else if (rawWeight <= 0.5) {
      return 2;
    } else if (rawWeight <= 1) {
      return 3;
    } else {
      return 4;
    }
  }

  double _width(Tissue tissue, int from, int to) {
    double rawWeight = tissue.weight(from, to).abs();
    return convertWeightToWidth(rawWeight);
  }

  double convertWeightToWidth(double rawWeight) {
    if (rawWeight < 0.1) {
      return 0.1;
    } else if (rawWeight <= 0.5) {
      return 0.5;
    } else if (rawWeight <= 1) {
      return 1.0;
    } else {
      return 1.5;
    }
  }

  String _color(Tissue tissue, int from, int to) {
    double rawWeight = tissue.weight(from, to).abs();
    return convertWeightToColor(rawWeight);
  }

  String convertWeightToColor(double rawWeight) {
    if (rawWeight > 0) {
      return "#00AA00";
    } else {
      return "#AA0000";
    }
  }

  String ofConnection(Interconnection connection) {

    Gviz graph = Gviz(name: _graphName);

    Tissue from = connection.from;
    Tissue to = connection.to;

    Gviz fromGraph = _createTissueGraph(from, name: "cluster_${from.name}");
    Gviz toGraph = _createTissueGraph(to, name: "cluster_${to.name}");

    for(var i=0; i<from.cellCount; i++) {
      for(var j=0; j<to.cellCount; j++) {

        double weight = connection.weight(j, i);

        if(weight != 0) {

          String cellName = _nodeName(from, i);
          String endPoint = _nodeName(to, j);

          graph.addEdge(cellName, endPoint, properties: {
          'weight': "${convertWeightToWidth(weight)}",
          'penwidth': "${convertWeightToWidth(weight)}",
          'color': convertWeightToColor(weight)
        });
        }
      }
    }

    graph.addSubgraph(fromGraph);
    graph.addSubgraph(toGraph);

    return graph.toString();

  }

  Gviz _createTissueGraph(Tissue tissue, {String name}) {
    final graph = Gviz(name: name != null ? name : _graphName);

    for (var i = 0; i < tissue.cellCount; i++) {
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

    return graph;
  }

  String ofTissue(Tissue tissue) {
    return _createTissueGraph(tissue).toString();
  }
}
