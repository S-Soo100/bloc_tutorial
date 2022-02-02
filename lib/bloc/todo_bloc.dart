import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_tutorial/bloc/todo_event.dart';
import 'package:bloc_tutorial/bloc/todo_state.dart';
import 'package:bloc_tutorial/model/todo.dart';
import 'package:bloc_tutorial/repository/todo_repository.dart';


class TodoBloc extends Bloc<TodoEvent, TodoState>{
  final TodoRepository repository;


  TodoBloc({
    required this.repository, //의존성 주입
  }) : super(Empty());

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async*{ //async*을 왜 쓰나요?
    if(event is ListTodosEvent){
      yield* _mapListTodosEvent(event);
    }else if (event is CreateTodosEvent){
      yield* _mapCreateTodosEvent(event);
    }else if (event is DeleteTodosEvent){
      yield* _mapDeleteTodosEvent(event);
    }
  }
  Stream<TodoState> _mapListTodosEvent(ListTodosEvent event)async*{
    try{
      yield Loading();

      final resp = await this.repository.listTodo();

      final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();

      yield Loaded(todos: todos);

    }catch(e){
      yield Error(message : e.toString());
    }

  }

  Stream<TodoState> _mapCreateTodosEvent(CreateTodosEvent event)async*{
    try{
      if(state is Loaded){
        final parsedState = (state as Loaded);
        final newTodo = Todo(
          id: parsedState.todos[parsedState.todos.length - 1].id + 1, //?????
          title: event.title,
          createdAt: DateTime.now().toString(),
        );

        //UI에 요청이 가기 전에 먼저 todo를 생성된 것 처럼 보여주기
        final prevTodos = [...parsedState.todos,]; // 기존 상태 저장
        final newTodos = [...prevTodos, newTodo,]; //기존상태에 새로생긴걸 우선 더하기
        yield Loaded(todos: newTodos); //그리고 그걸 '성공 한다는 가정하에'일단 보여주기

        final resp = await this.repository.createTodo(newTodo);
        yield Loaded(todos: [...prevTodos, Todo.fromJson(resp),]);
      }


    }catch(e){
      yield Error(message : e.toString());
    }
  }
  Stream<TodoState> _mapDeleteTodosEvent(DeleteTodosEvent event) async*{

  try{
    if(state is Loaded){
      final newTodos = (state as Loaded)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();

      yield Loaded(todos: newTodos);

      await repository.deleteTodo(event.todo);
    }
  }catch(e){
  yield Error(message : e.toString());
  }
  }

}