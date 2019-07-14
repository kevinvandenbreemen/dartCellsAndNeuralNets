class Tissue {

  /// List of cell types (each index corresponds to a single cell of that type)
  List<int> _cells;

  /// Total number of cells in this tissue
  int get cellCount => _cells.length;

  Tissue() {
    _cells = List();
  }

  void add(int cellType) {
    _cells.add(cellType);
  }

}