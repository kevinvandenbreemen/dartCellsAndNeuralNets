import 'dart:math';

import 'package:linalg/linalg.dart';
import 'package:linalg/matrix.dart';
import 'package:neural_net_experiments/src/cell/CellTypes.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

main() {
  
  const int iterations = 100;
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

  void deleteOutgoingCellOnMatrix(int index) {
    rawWeightMatrix.forEach((row) => row.removeAt(index));
  }

  void deleteIncomingCellOnMatrix(int indexToDelete) {
    rawWeightMatrix.removeAt(indexToDelete);
  }

  void addConnection(int from, int to, double strength) {
    if(rawWeightMatrix.isEmpty) {
      rawWeightMatrix.add(List<double>());
      rawWeightMatrix[0].add(strength);
      return;
    }
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

        List<double> values = List<double>.generate(t1.cellCount, (k)=>random.nextDouble());
        List<double> expectedOutput = (Matrix(rawWeightMatrix) * Vector.column(values)).columnVector(0).toList();
        List<double> resultOfInputs = t1.connectedTissues()[0].computeOutputFor(values);

        expect(expectedOutput, resultOfInputs, reason: "Weight matrix: $rawWeightMatrix, Inputs: $values");

      }
    });

    test('Adding and deleting cells', () {
      for(var i=0; i<iterations; i++){

        if(t1.cellCount > 0 && t2.cellCount > 0 && random.nextBool()) {
          if(random.nextBool()){
            int indexToDelete = random.nextInt(t1.cellCount);
            if(indexToDelete == t1.cellCount) {
              indexToDelete --;
            }
            t1.deleteCell(indexToDelete);
            deleteOutgoingCellOnMatrix(indexToDelete);
          } else {
            int indexToDelete = random.nextInt(t2.cellCount);
            if(indexToDelete == t2.cellCount) {
              indexToDelete --;
            }
            t2.deleteCell(indexToDelete);
            deleteIncomingCellOnMatrix(indexToDelete);
          }
        }

        t1.add(STEM);
        t2.add(STEM);
        addOutgoingCellOnMatrix(t1);
        addIncomingCellOnMatrix(t2);

        int from = random.nextInt(t1.cellCount);
        int to = random.nextInt(t2.cellCount);
        double strength = random.nextDouble();

        t1.connectToTissue(t2, from: from, to: to, strength: strength);
        addConnection(from, to, strength);

        List<double> values = List<double>.generate(t1.cellCount, (k)=>random.nextDouble());
        try {
          
          List<double> expectedOutput = (Matrix(rawWeightMatrix) * Vector.column(values)).columnVector(0).toList();
          List<double> resultOfInputs = t1.connectedTissues()[0].computeOutputFor(values);

          expect(expectedOutput, resultOfInputs, reason: "Weight matrix: $rawWeightMatrix, Inputs: $values");
        } catch(ex){
          //fail("Unexpected ${ex.toString()}:  Raw matrix = $rawWeightMatrix, input:  $values");
        }

      }
    });

  });

}

