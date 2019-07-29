import 'package:neural_net_experiments/src/cell/CellTypes.dart';
import 'package:neural_net_experiments/src/reality/reality.dart';
import 'package:neural_net_experiments/src/tissue/ConnectionTypes.dart';
import 'package:neural_net_experiments/src/tissue/Interconnection.dart';
import 'package:neural_net_experiments/src/tissue/TissueChangeListener.dart';

class InvalidCellReferenceException implements Exception {
  int _cellIndex;

  InvalidCellReferenceException(this._cellIndex) : super();

  @override
  String toString() {
    return "Cell at $_cellIndex does not exist";
  }
}

class Tissue {
  /// List of cell types (each index corresponds to a single cell of that type)
  List<int> _cells;

  /// List whose entries correspond to the cell type id at each cell index in this tissue
  List<int> get cellTypes => List<int>.from(_cells, growable: false);

  List<Interconnection> _connectedTissues;

  List<TissueChangeListener> _changeListeners;

  /// Total number of cells in this tissue
  int get cellCount => _cells.length;

  List<List<double>> _connectionMatrix;

  Tissue() {
    _cells = List();
    _connectedTissues = List();
    _changeListeners = List();
    Reality.get().registerTissue(this);
  }

  void add(int cellType) {
    _cells.add(cellType);
    _addCellForConnectionMatrix();

    _connectedTissues.forEach((connection) {
      connection.updateOutgoingConnections();
    });

    _changeListeners.forEach((listener) => listener.onAddCell());
  }

  void deleteCell(int cellIndex) {
    _cells.removeAt(cellIndex);
    _connectedTissues.forEach((tissueConnection) =>
        tissueConnection.removeConnectionsFrom(cellIndex));
    _changeListeners.forEach((listener) => listener.deleteCell(cellIndex));
  }

  void listen(TissueChangeListener changeListener) {
    _changeListeners.add(changeListener);
  }

  String type({int of}) {
    return cellTypeName(_cells[of]);
  }

  void _addCellForConnectionMatrix() {
    if (_connectionMatrix == null) {
      _connectionMatrix = List<List<double>>.filled(
          cellCount, List<double>.filled(cellCount, 0, growable: true),
          growable: true);
    } else {
      for (var i = 0; i < _connectionMatrix.length; i++) {
        _connectionMatrix[i].add(0);
      }
      _connectionMatrix.add(List<double>.filled(cellCount, 0, growable: true));
    }
  }

  @override
  String toString() {
    String ret = "tissue: matrix:\n";
    for (var i = 0; i < _connectionMatrix.length; i++) {
      ret += "[\t";
      for (var j = 0; j < _connectionMatrix[i].length; j++) {
        ret += "${_connectionMatrix[i][j]}\t";
      }
      ret += "]\n";
    }

    return ret;
  }

  /// Create or update the connection from cell at index [from] to cell at index [to] to the specified strength.  See also 
  /// [connectionStrength()]
  void join({int type, int from, int to, double strength}) {
    if (from == to) {
      print("Connection from cell to itself not allowed");
      return;
    }

    _connectionMatrix[from][to] = strength;
    if (type == BIDIRECTIONAL) {
      _connectionMatrix[to][from] = strength;
    }
  }

  void removeConnectionTo(Tissue tissue) {
    _connectedTissues = _connectedTissues.where((x)=>x.to != tissue).toList(growable: true);
  }

  /// Get the current connection strength from cell at index [from] to cell at index [to]
  double connectionStrength({int from, int to}) {
    assert(from != null && to != null);
    return _connectionMatrix[from][to];
  }

  void connectToTissue(Tissue tissue, {int from, int to, double strength}) {
    if (tissue == this) {
      print('Tissue connecting to itself is not allowed');
      return;
    }

    Interconnection connection;
    if (_connectedTissues.isNotEmpty) {
      connection = _connectedTissues.firstWhere(
          (connection) => connection.to == tissue,
          orElse: () => null);
    } else {
      connection = null;
    }

    if (connection == null) {
      connection = Interconnection(this, tissue);
      _connectedTissues.add(connection);
    }

    connection.connect(from, to, strength);
  }

  List<Interconnection> connectedTissues() {
    return List.unmodifiable(_connectedTissues);
  }

  /// Gets list of cell indexes that are endpoints for the given cell (have connections going from the cell to those cells)
  List<int> endpoints(int cellIndex) {
    List<int> ret = List();
    for (var i = 0; i < cellCount; i++) {
      if (_connectionMatrix[cellIndex][i] != 0) {
        ret.add(i);
      }
    }
    return ret;
  }

  /// Returns set of all outgoing tissue connections such that the cell at index [cellIndex] has a
  /// non-zero connection to at least one cell
  List<Interconnection> cVOut(int cellIndex) {
    return _connectedTissues
        .where((c) => c.existConnectionsFrom(cellIndex))
        .toList(growable: false);
  }

  /// Returns set of all incoming tissue connections such that the cell at index[cellIndex] has a
  /// non-zero connection from at least one cell
  List<Interconnection> cVIn(int cellIndex) {
    List<Interconnection> incomingConnections = Reality.get().X(this).tIn;
    return incomingConnections
        .where((c) => c.existConnectionsTo(cellIndex))
        .toList(growable: false);
  }

  /// Gets the weight of the connection (0 if none exists) from the given [cellIndex] to the given [toIndex]
  double weight(int cellIndex, int toIndex) {
    return _connectionMatrix[cellIndex][toIndex];
  }
}
