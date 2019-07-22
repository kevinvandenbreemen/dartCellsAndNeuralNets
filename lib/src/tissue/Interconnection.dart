import 'package:linalg/matrix.dart';
import 'package:linalg/vector.dart';
import 'package:neural_net_experiments/src/reality/reality.dart';
import 'package:neural_net_experiments/src/tissue/TissueChangeListener.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';

/// Connection from one tissue to another.  Represents a connection matrix whose entries correspond to strengths of connections from
/// cells in one tissue to those in the other tissue
class Interconnection implements TissueChangeListener {
  Tissue _from;
  Tissue _to;

  Tissue get to => _to;
  Tissue get from => _from;

  List<List<double>> _tissueConnections;

  Interconnection(this._from, this._to) {
    this._tissueConnections = List<List<double>>.generate(_to.cellCount, (_) {
      List<double> ret = List<double>()..length = _from.cellCount;
      for (var i = 0; i < ret.length; i++) {
        ret[i] = 0.0;
      }
      return ret;
    }, growable: true);

    this._to.listen(this);
    Reality.get().registerConnectionMatrix(this);
  }

  double weight(int to, int from) {
    if (to >= _tissueConnections.length) {
      throw InvalidCellReferenceException(to);
    }
    return _tissueConnections[to][from];
  }

  void connect(int from, int to, double strength) {
    _tissueConnections[to][from] = strength;
  }

  void updateOutgoingConnections() {
    _tissueConnections
        .forEach((destinationCellRow) => destinationCellRow.add(0.0));
  }

  @override
  void onAddCell() {
    List<double> destinationRow = List<double>()..length = _from.cellCount;
    for (var i = 0; i < destinationRow.length; i++) {
      destinationRow[i] = 0.0;
    }
    _tissueConnections.add(destinationRow);
  }

  @override
  void deleteCell(int cellIndex) {
    _tissueConnections.removeAt(cellIndex);
  }

  bool existConnectionsFrom(int fromIndex) {
    bool ret = false;
    _tissueConnections.forEach((destinationCellInputs) {
      if (destinationCellInputs[fromIndex] != 0) {
        ret = true;
      }
    });
    return ret;
  }

  void removeConnectionsFrom(int cellIndex) {
    _tissueConnections.forEach((outputRow) {
      outputRow.removeAt(cellIndex);
    });
  }

  bool existConnectionsTo(int toIndex) {
    return _tissueConnections[toIndex]
                .firstWhere((input) => input != 0, orElse: () => null) !=
            null
        ? true
        : false;
  }

  List<double> computeOutputFor(List<double> input) {
    Matrix weightMatrix = Matrix(_tissueConnections);
    return (weightMatrix * Vector.column(input)).columnVector(0).toList();
  }
}
