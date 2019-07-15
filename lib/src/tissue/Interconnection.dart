
import 'package:neuralNetExperiments/src/tissue/tissue.dart';

/// Connection from one tissue to another
class Interconnection {

  Tissue _from;
  Tissue _to;

  List<List<double>> _tissueConnections;

  Interconnection(this._from, this._to) {
    this._tissueConnections = List<List<double>>.filled(_from.cellCount, 
      List<double>.filled(_to.cellCount, 0.0, growable: true),
      growable: true
    );
  }

  double weight(int from, int to) {
    return _tissueConnections[from][to];
  }

  void connect(int from, int to, double strength) {
    _tissueConnections[from][to] = strength;
  }

}