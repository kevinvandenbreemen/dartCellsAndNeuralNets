import 'package:neural_net_experiments/neural_net_experiments.dart';

main() {

  Tissue t1 = Tissue();
  Tissue t2 = Tissue();
      
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

  List<double> output = connection.computeOutputFor(input);
  print(output);
}
