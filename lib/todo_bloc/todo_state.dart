part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<Todo> todos;
  final List<Todo> searchResults;
  final TodoStatus status;

   TodoState({
    this.todos = const <Todo>[],
    this.searchResults = const <Todo>[],
    this.status = TodoStatus.initial
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    List<Todo>? searchResults,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      searchResults: searchResults ?? this.searchResults,
      status: status ?? this.status,
    );
  }

  @override
  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      var listOfTodos = (json['todo'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();

      return TodoState(
          todos: listOfTodos,
          status: TodoStatus.values.firstWhere(
                  (element) => element.name.toString() == json['status']
          )
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'todo': todos,
      'status': status.name
    };
  }

  @override
  List<Object?> get props => [todos, status];
}