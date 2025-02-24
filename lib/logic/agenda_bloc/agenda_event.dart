import 'package:agenda_app/data/models/agenda_model.dart';
import 'package:equatable/equatable.dart';

abstract class AgendaEvent extends Equatable{
  const AgendaEvent();

  @override  
  List<Object?> get props => [];
}

class LoadAgendas extends AgendaEvent{}

class AddAgenda extends AgendaEvent{
  final AgendaModel agenda;

  const AddAgenda(this.agenda);

  @override  
  List<Object?> get props => [agenda];
}