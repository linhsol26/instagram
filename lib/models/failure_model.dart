import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String code;
  final String message;

  const Failure({this.code = '', this.message = ''});

  @override
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object> get props => [code, message];
}
