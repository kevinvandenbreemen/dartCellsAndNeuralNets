import 'dart:math';

import 'package:linalg/linalg.dart';
import 'package:linalg/matrix.dart';
import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

main() {
  
  const int iterations = 20;
  Random random = Random();
  List<List<double>> rawWeightMatrix;
  void addOutgoingCellOnMatrix(Tissue originTissue) {
    if(rawWeightMatrix.isEmpty) {
      rawWeightMatrix.add(List<double>());
      rawWeightMatrix[0].add(0.0);
      return;
    }
    rawWeightMatrix.forEach((row) => row.add(0.0));
  }
  void addIncomingCellOnMatrix(Tissue destinationTissue) {
    if(rawWeightMatrix.length == destinationTissue.cellCount) {
      return;
    }
    List<double> ret = new List<double>()..length = rawWeightMatrix[0].length;
    for(var i=0; i<ret.length; i++) {
      ret[i] = 0.0;
    }
    rawWeightMatrix.add(ret);
  }
  void addConnection(int from, int to, double strength) {
    rawWeightMatrix[to][from] = strength;
  }

  group('Tissue Chi Matrix Validation', () {

    Tissue t1;
    Tissue t2;

    setUp((){
      t1 = Tissue();
      t2 = Tissue();
      rawWeightMatrix = List<List<double>>();
    });

    test('Keep adding cells', (){
      for(var i=0; i<iterations; i++){
        t1.add(STEM);
        t2.add(STEM);
        addOutgoingCellOnMatrix(t1);
        addIncomingCellOnMatrix(t2);

        int from = random.nextInt(t1.cellCount);
        int to = random.nextInt(t2.cellCount);
        double strength = random.nextDouble();

        t1.connectToTissue(t2, from: from, to: to, strength: strength);
        addConnection(from, to, strength);

        List<double> values = List<double>.generate(t1.cellCount, (k)=>0.5);
        List<double> expectedOutput = (Matrix(rawWeightMatrix) * Vector.column(values)).columnVector(0).toList();
        List<double> resultOfInputs = t1.connectedTissues()[0].computeOutputFor(values);

        expect(expectedOutput, resultOfInputs, reason: "Weight matrix: $rawWeightMatrix, Inputs: $values");

      }

      print("Final weight matrix:\n$rawWeightMatrix");
    });

  });

}