import 'dart:typed_data';

import 'package:neural_net_experiments/src/genome/GenomeFactory.dart';
import 'package:test/test.dart';

main() {
  
  group('Genome Generation', (){

    GenomeFactory genomeFactory;

    setUp(() {
      genomeFactory = GenomeFactory();
    });

    test('Creates Genome', (){
        Uint8List list = genomeFactory.createGenome();
        expect(list, isNotNull);
    });

    test('Creates Genomes with Data', (){
        Uint8List list = genomeFactory.createGenome();
        list.forEach((item)=>expect(item, isNot(0)));
    });

    test('Creates genome of differing length', () {
      Uint8List list = genomeFactory.createGenome(length: 4);
      expect(list.length, equals(4));
    });

  });

}