import 'package:neuralNetExperiments/src/tissue/Interconnection.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';

/// Overarching reality of the internals of the system

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
    this._setOfAllConnectionMatrices.add(connectionMatrix);
  }

  Reality._Reality(){
    _setOfAllTissues = List<Tissue>();
    _setOfAllConnectionMatrices = List<Interconnection>();
  }

}