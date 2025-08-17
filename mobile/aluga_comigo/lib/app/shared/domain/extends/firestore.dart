import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreExtension<T> on Query<T> {
  Query<T> whereJS(String field, String operator, dynamic value) {
    switch(operator){
      case '==':
        return where(field, isEqualTo: value);
      case '>':
        return where(field, isGreaterThan: value);
      case '<':
        return where(field, isLessThan: value);
      case '>=':
        return where(field, isGreaterThanOrEqualTo: value);
      case '<=':
        return where(field, isLessThanOrEqualTo: value);
      case 'array-contains':
        return where(field, arrayContains: value);
      case 'array-contains-any':
        return where(field, arrayContainsAny: value);
      case 'in':
        return where(field, whereIn: value);
      case 'not-in':
        return where(field, whereNotIn: value);
      case 'not-contains':
        return where(field, isNotEqualTo: value);
      case 'isNull':
        return where(field, isNull: value);
      default:
        throw Exception('Operador não suportado: $operator');
    }
  }
}