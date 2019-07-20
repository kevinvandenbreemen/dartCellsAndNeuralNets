
import 'package:neuralNetExperiments/src/reality/reality.dart';
import 'package:neuralNetExperiments/src/tissue/TissueChangeListener.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';

/// Connection from one tissue to another.  Represents a connection matrix whose entries correspond to strengths of connections from
/// cells in one tissue to those in the other tissue
class Interconnection implements TissueChangeListener {

  Tissue _from;
  Tissue _to;

  Tissue get to => _to;
  Tissue get from => _from;

  List<List<double>> _tissueConnections;

  Interconnection(this._from, this._to) {
    this._tissueConnections = List<List<double>>.filled(_to.cellCount, 
      List<double>.filled(_from.cellCount, 0.0, growable: true),
      growable: true
    );

    this._to.listen(this);
    Reality.get().registerConnectionMatrix(this);
  }

  double weight(int to, int from) {
    return _tissueConnections[to][from];
  }

  void connect(int from, int to, double strength) {
    _tissueConnections[to][from] = strength;
  }

  void updateOutgoingConnections() {
    _tissueConnections.forEach((destinationCellRow) => destinationCellRow.add(0.0));
  }

  @override
  void onAddCell() {
    _tissueConnections.add(List<double>.filled(_from.cellCount, 0.0));
  }

  bool existConnectionsFrom(int fromIndex) {
    bool ret = false;
    _tissueConnections.forEach((destinationCellInputs) {
      if(destinationCellInputs[fromIndex] != 0) {
        ret = true;
      }
    });
    return ret;
  }

}