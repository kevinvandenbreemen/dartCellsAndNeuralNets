import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
import 'package:neuralNetExperiments/src/tissue/ConnectionTypes.dart';
import 'package:neuralNetExperiments/src/tissue/Interconnection.dart';
import 'package:neuralNetExperiments/src/tissue/TissueChangeListener.dart';

class Tissue {

  /// List of cell types (each index corresponds to a single cell of that type)
  List<int> _cells;

  List<Interconnection> _connectedTissues;

  List<TissueChangeListener> _changeListeners;

  /// Total number of cells in this tissue
  int get cellCount => _cells.length;

  List<List<double>> _connectionMatrix;

  Tissue() {
    _cells = List();
    _connectedTissues = List();
    _changeListeners = List();
  }

  void add(int cellType) {
    _cells.add(cellType);
    _addCellForConnectionMatrix();

    _connectedTissues.forEach((connection) {
      connection.updateOutgoingConnections();
    });

    _changeListeners.forEach((listener) => listener.onAddCell());
  }

  void listen(TissueChangeListener changeListener) {
    _changeListeners.add(changeListener);
  }

  String type({int of}) {
    return cellTypeName(_cells[of]);
  }

  void _addCellForConnectionMatrix() {
    if(_connectionMatrix == null) {
      _connectionMatrix = List<List<double>>.filled(cellCount, List<double>.filled(cellCount, 0, growable: true), growable: true);
    } else {
      for(var i=0; i<_connectionMatrix.length; i++) {
        _connectionMatrix[i].add(0);
      }
      _connectionMatrix.add(List<double>.filled(cellCount, 0, growable: true));
    }
  }

  @override
  String toString() {
    String ret = "tissue: matrix:\n";
    for(var i=0; i<_connectionMatrix.length; i++) {
      ret += "[\t";
      for(var j=0; j<_connectionMatrix[i].length; j++) {
        ret += "${_connectionMatrix[i][j]}\t";
      }
      ret += "]\n";
    }

    return ret;
  }

  void join({int type, int from, int to, double strength}) {

    if(from == to) {
      print("Connection from cell to itself not allowed");
      return;
    }

    _connectionMatrix[from][to] = strength;
    if(type == BIDIRECTIONAL) {
      _connectionMatrix[to][from] = strength;
    }
  }

  void connectToTissue(Tissue tissue, {int from, int to, double strength}) {
    Interconnection connection = Interconnection(this, tissue);
    connection.connect(from, to, strength);
    _connectedTissues.add(connection);
  }

  List<Interconnection> connectedTissues() {
    return List.unmodifiable(_connectedTissues);
  }

  /// Gets list of cell indexes that are endpoints for the given cell (have connections going from the cell to those cells)
  List<int> endpoints(int cellIndex) {

    List<int> ret = List();
    for(var i=0; i<cellCount; i++) {
      if(_connectionMatrix[cellIndex][i] != 0) {
        ret.add(i);
      }
    }
    return ret;
  }

  /// Gets the weight of the connection (0 if none exists) from the given [cellIndex] to the given [toIndex]
  double weight(int cellIndex, int toIndex) {
    return _connectionMatrix[cellIndex][toIndex];
  }

}