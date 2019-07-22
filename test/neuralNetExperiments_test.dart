import 'package:linalg/matrix.dart';
import 'package:linalg/vector.dart';
import 'package:neural_net_experiments/src/cell/CellTypes.dart';
import 'package:neural_net_experiments/src/reality/reality.dart';
import 'package:neural_net_experiments/src/tissue/ConnectionTypes.dart';
import 'package:neural_net_experiments/src/tissue/Interconnection.dart';
import 'package:neural_net_experiments/src/tissue/tissue.dart';
import 'package:test/test.dart';

void main() {
  group('Tissue', () {
    
    Tissue tissue;

    setUp((){
      tissue = Tissue();
    });

    test('Gets added to reality', (){
      Reality reality = Reality.get();
      expect(reality.setOfAllTissues.contains(tissue), isTrue);
    });

    test('Adds stem cell', () {
      tissue.add(STEM);

      expect(tissue.cellCount, equals(1));
    });

    test('Deletes cell', (){
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.deleteCell(1);

      expect(tissue.cellCount, equals(1));
    });

    test('Can show cell type', () {
      tissue.add(STEM);

      expect(tissue.type(of: 0), equals("Stem"));
    });

    test('Can list types of cells in tissue', (){
      tissue.add(STEM);
      tissue.add(2);

      List<int> cellTypes = tissue.cellTypes;

      expect(cellTypes, equals([1,2]));
    });

    test('Can connect one cell to another', () {
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(type: BIDIRECTIONAL, from: 0, to: 1, strength: 1.0);
      tissue.join(type: BIDIRECTIONAL, from: 0, to: 2, strength: 1.0);

      expect(tissue.endpoints(0), equals([1,2]));
    });

    test('cannot connect cell to itself', () {
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(type: BIDIRECTIONAL, from: 0, to: 0, strength: 1.0);

      expect(tissue.endpoints(0), equals([]));
    });

    test('respects bidirectional connections', () {
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(type: BIDIRECTIONAL, from: 0, to: 2, strength: 1.0);

      expect(tissue.endpoints(0), equals([2]));
      expect(tissue.endpoints(2), equals([0]));

    });

    test('Supports directed connections', () {
      tissue.add(STEM);
      tissue.add(STEM);
      tissue.add(STEM);

      tissue.join(type: DIRECTED, from: 0, to: 2, strength: 1.0);

      expect(tissue.endpoints(0), equals([2]));
      expect(tissue.endpoints(2), equals([]));
    });

  });

  group('Connecting with Other Tissues', () {

    Tissue t1;
    Tissue t2;

    setUp((){
      t1 = Tissue();
      t2 = Tissue();
    });

    test('Connect one tissue with another', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0);

      expect(t1.connectedTissues().length, equals(1));
    });

    test('Any connection is added to reality', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0);

      Interconnection connection = t1.connectedTissues()[0];
      expect(Reality.get().setOfAllConnectionMatrices.contains(connection), isTrue);
    });

    test('Connect cell in one tissue with cell in another', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      expect(t1.connectedTissues()[0].weight(0, 0), equals(1.1));
    });

    test('Add cell to from tissue updates connection', () {
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      t1.add(STEM);

      expect(t1.connectedTissues()[0].weight(0, 1), equals(0.0));
    });

    test('Add cell to dest tissue updates connection', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      t2.add(STEM);

      expect(t1.connectedTissues()[0].weight(1, 0), equals(0.0));
    });

    test('Deleting cell in destination tissue deletes corresponding outgoing connections', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      t2.add(STEM);
      t2.deleteCell(1);

      expect(()=>t1.connectedTissues()[0].weight(1, 0), throwsException);
    });

    test('Deleting all cells in destination tissue deletes corresponding outgoing chi on origin', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      t2.add(STEM);
      t2.deleteCell(0);
      t2.deleteCell(0);

      expect(t1.connectedTissues().length, equals(0));
    });

    test('Deleting all cells in destination tissue deletes corresponding chi in reality for origin cell', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      t2.add(STEM);
      t2.deleteCell(0);
      t2.deleteCell(0);

      expect(Reality.get().X(t1).tOut.isEmpty, isTrue);
    });

    test('Deleting all cells in destination tissue deletes corresponding chi in reality for destination cell', (){
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);

      t2.add(STEM);
      t2.deleteCell(0);
      t2.deleteCell(0);

      expect(Reality.get().X(t2).tIn.isEmpty, isTrue);
    });

    test('Add multiple connection weights', (){
      t1.add(STEM);
      t2.add(STEM);
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 1.1);
      t1.connectToTissue(t2, from: 1, to: 0, strength: 2.0);

      expect(t1.connectedTissues()[0].weight(0, 0), equals(1.1));
      expect(t1.connectedTissues()[0].weight(0, 1), equals(2.0));
    });

    test('Tissue cannot connect to itself', () {
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t1, from: 0, to: 0, strength: 1.1);

      expect(t1.connectedTissues().isEmpty, isTrue);
    });

    test('Can count connections to other tissues for a given cell', (){

      //  Arrange
      Tissue t3 = Tissue();
      t3.add(STEM);
      t3.add(STEM);

      Tissue t4 = Tissue();
      t4.add(STEM);
      t4.add(STEM);

      t1.add(STEM);
      t2.add(STEM);
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t3, from: 0, to: 0, strength: 1.1);
      t1.connectToTissue(t2, from: 0, to: 0, strength: 2.0);
      t1.connectToTissue(t4, from: 1, to: 0, strength: 1.1);
      t2.connectToTissue(t1, from: 0, to: 0, strength: 1);
      List<Interconnection> cVOut = t1.cVOut(0);

      expect(cVOut.isEmpty, isFalse);
      expect(cVOut.length, equals(2));
      expect(cVOut.firstWhere((x)=>x.to == t3, orElse: ()=>null), isNotNull);
      expect(cVOut.firstWhere((x)=>x.to == t2, orElse: ()=>null), isNotNull);

    });

    test('Can count connections from other tissues for a given cell', (){

      //  Arrange
      Tissue t3 = Tissue();
      t3.add(STEM);
      t3.add(STEM);

      Tissue t4 = Tissue();
      t4.add(STEM);
      t4.add(STEM);

      t1.add(STEM);
      t2.add(STEM);
      t1.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t3, from: 0, to: 0, strength: 1.1);
      t1.connectToTissue(t2, from: 0, to: 0, strength: 2.0);
      t1.connectToTissue(t4, from: 1, to: 0, strength: 1.1);
      t2.connectToTissue(t1, from: 0, to: 0, strength: 1);
      List<Interconnection> cVOut = t1.cVIn(0);

      expect(cVOut.isEmpty, isFalse);
      expect(cVOut.length, equals(1));
      expect(cVOut.firstWhere((x)=>x.from == t2, orElse: ()=>null), isNotNull);

    });

    test('Can calculate output to other tissue', (){

      //  Arrange
      t1.add(STEM);
      t1.add(STEM);
      t2.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 0.5);
      t1.connectToTissue(t2, from: 0, to: 1, strength: 0.1);
      t1.connectToTissue(t2, from: 1, to: 0, strength: 0.4);
      t1.connectToTissue(t2, from: 1, to: 1, strength: 1.0);

      List<double> input = List<double>.from([2.0, 4.0]);
      Interconnection connection = t1.connectedTissues()[0];

      //  Act
      List<double> output = connection.computeOutputFor(input);

      //  Assert
      expect(output, equals([2.6, 4.2]));

    });

    test('Deleting cells does not break output function', (){
      //  Arrange
      t1.add(STEM);
      t1.add(STEM);
      t2.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 0.5);
      t1.connectToTissue(t2, from: 0, to: 1, strength: 0.1);
      t1.connectToTissue(t2, from: 1, to: 0, strength: 0.4);
      t1.connectToTissue(t2, from: 1, to: 1, strength: 1.0);

      t1.add(STEM);
      t1.deleteCell(2);

      List<double> input = List<double>.from([2.0, 4.0]);
      Interconnection connection = t1.connectedTissues()[0];

      //  Act
      List<double> output = connection.computeOutputFor(input);

      //  Assert
      expect(output, equals([2.6, 4.2]));
    });

    test('Deleting cell on destination tissue does not break output function', (){
      //  Arrange
      t1.add(STEM);
      t1.add(STEM);
      t2.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 0.5);
      t1.connectToTissue(t2, from: 0, to: 1, strength: 0.1);
      t1.connectToTissue(t2, from: 1, to: 0, strength: 0.4);
      t1.connectToTissue(t2, from: 1, to: 1, strength: 1.0);

      t2.add(STEM);
      t2.deleteCell(2);

      List<double> input = List<double>.from([2.0, 4.0]);
      Interconnection connection = t1.connectedTissues()[0];

      //  Act
      List<double> output = connection.computeOutputFor(input);

      //  Assert
      expect(output, equals([2.6, 4.2]));
    });

    test('Output to other tissue works after adding cell to destination tissue', (){
      //  Arrange
      t1.add(STEM);
      t1.add(STEM);
      t2.add(STEM);
      t2.add(STEM);

      t1.connectToTissue(t2, from: 0, to: 0, strength: 0.5);
      t1.connectToTissue(t2, from: 0, to: 1, strength: 0.1);
      t1.connectToTissue(t2, from: 1, to: 0, strength: 0.4);
      t1.connectToTissue(t2, from: 1, to: 1, strength: 1.0);

      t2.add(STEM);

      //  Matrix here is
      /*
      [0.5  0.4]
      [0.1  1.0]
      */
      Matrix expectedWeightMatrix = Matrix(
        [
          [0.5, 0.4],
          [0.1, 1.0],
          [0.0, 0.0]
        ]
      );

      List<double> input = List<double>.from([2.0, 4.0]);
      List<double> expectedOutputs = (expectedWeightMatrix * Vector.column(input)).columnVector(0).toList();

      Interconnection connection = t1.connectedTissues()[0];

      //  Act
      List<double> output = connection.computeOutputFor(input);

      //  Assert
      expect(output, equals(expectedOutputs));
    });

  });
}
