import 'package:neuralNetExperiments/src/cell/CellTypes.dart';
import 'package:neuralNetExperiments/src/reality/reality.dart';
import 'package:neuralNetExperiments/src/tissue/ConnectionTypes.dart';
import 'package:neuralNetExperiments/src/tissue/Interconnection.dart';
import 'package:neuralNetExperiments/src/tissue/tissue.dart';
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

  });
}
