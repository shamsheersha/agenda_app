import 'package:agenda_app/data/models/agenda_model.dart';
import 'package:equatable/equatable.dart';

abstract class AgendaState extends Equatable{
  const AgendaState();

  @override  
  List<Object?> get props => [];
}

class AgendaInitial extends AgendaState{}

class AgendaLoading extends AgendaState{}

class AgendaLoaded extends AgendaState{
  final List<AgendaModel> agenda;

  const AgendaLoaded(this.agenda);

  @override  
  List<Object> get props => [agenda];
}

class AgendaError extends AgendaState{
  final String message;

  const AgendaError(this.message);

  @override  
  List<Object> get props => [message];
}