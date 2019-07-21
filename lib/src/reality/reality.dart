import 'package:neural_net_experiments/src/tissue/Interconnection.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';

/// Overarching reality of the internals of the system

abstract class Chi {
  List<Interconnection> get tIn;
  List<Interconnection> get tOut;
}

class _Chi implements Chi {

  List<Interconnection> _connectionMatrices;
  Tissue _t;
  _Chi(this._connectionMatrices, this._t);

  @override
  List<Interconnection> get tIn => _connectionMatrices.where((x) => x.to == _t).toList(growable: false);

  @override
  List<Interconnection> get tOut => _connectionMatrices.where((x) => x.from == _t).toList(growable: false);

}

class Reality {

  static final Reality _reality = Reality._Reality();
  static Reality get() => _reality;

  List<Tissue> _setOfAllTissues;
  List<Tissue> get setOfAllTissues => List.unmodifiable(_setOfAllTissues);
  void registerTissue(Tissue tissue) {
    _setOfAllTissues.add(tissue);
  }

  List<Interconnection> _setOfAllConnectionMatrices;
  List<Interconnection> get setOfAllConnectionMatrices => List.unmodifiable(_setOfAllConnectionMatrices);
  void registerConnectionMatrix(Interconnection connectionMatrix) {
    _setOfAllConnectionMatrices.add(connectionMatrix);
  }

  Chi X(Tissue t) {
    return _Chi(_setOfAllConnectionMatrices.where((x) => x.from == t || x.to == t).toList(growable: false),
      t
    );
  }

  Reality._Reality(){
    _setOfAllTissues = List<Tissue>();
    _setOfAllConnectionMatrices = List<Interconnection>();
  }

}