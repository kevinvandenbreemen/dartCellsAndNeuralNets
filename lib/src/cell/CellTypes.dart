/// Stem Cell
const int STEM = 1;

String cellTypeName(int cellType) {
  switch (cellType) {
    case STEM:
      return "Stem";
      break;
    default:
      return "UNK";
  }
}