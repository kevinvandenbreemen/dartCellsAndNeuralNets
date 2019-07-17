import 'dart:typed_data';
import 'dart:math';

class GenomeFactory {

  Uint8List createGenome({int length = 5}) {
    Uint8List ret = Uint8List(length);

    Random random = Random.secure();
    for(var i=0; i<ret.length; i++) {
      int val = random.nextInt(255);
      if(val == 0) {
        val = random.nextInt(255);
      }
      ret[i] = val;
    }

    return ret;
  }

}