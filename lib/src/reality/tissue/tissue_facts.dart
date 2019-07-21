import 'package:neural_net_experiments/src/reality/context.dart';

/// Facts about tissues.  These must all return results of type boolean
class TissueCellCountLessThan {

  final int numCells;

  TissueCellCountLessThan(this.numCells);

  bool evaluate(RealityContext context) {
    return context.tissue.cellCount < numCells;
  }

}