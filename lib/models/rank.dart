import 'package:ml_linalg/linalg.dart';

List<Vector> getAlternatives(final Matrix matrix) {
  final Iterable<Vector> rows = matrix.rows;
  return rows.take(matrix.rowCount - 1).toList();
}

Vector getUserVector(final Matrix matrix) {
  return matrix.getRow(matrix.rowCount - 1);
}

Matrix computeNormalizedMatrixFromRows(final List<Vector> rows) {
  final Matrix matrix = Matrix.fromRows(rows);
  return matrix / matrix.norm();
}
