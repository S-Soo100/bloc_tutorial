import 'package:bloc_tutorial/bloc/todo_bloc.dart';
import 'package:bloc_tutorial/bloc/todo_event.dart';
import 'package:bloc_tutorial/bloc/todo_state.dart';
import 'package:bloc_tutorial/repository/todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(HomeScreen());


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create : (_) => TodoBloc(repository: TodoRepository()),
      child: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {


  String title = '';
  @override
  void initState(){
    super.initState();

    BlocProvider.of<TodoBloc>(context).add(ListTodosEvent());
    //
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Bloc'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.read<TodoBloc>().add(CreateTodosEvent(title: this.title));
        },
        child: Icon(
          Icons.edit
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val){
                this.title = val;
              },
            ),
            SizedBox(height: 16.0,),
            Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                    builder: (_, state){
                  if(state is Empty){
                    return Container();
                  }else if(state is Error){
                    return Container(child: Text(state.message),);
                  }else if(state is Loading){
                    return CircularProgressIndicator();
                  }else if(state is Loaded){
                    final items = state.todos;
                    return ListView.separated(
                        itemBuilder: (_, index){
                          final item = items[index];

                          return Row(
                            children: [
                              Expanded(child: Text(item.title,)),
                              GestureDetector(
                                onTap: (){
                                  BlocProvider.of<TodoBloc>(context).add(DeleteTodosEvent(todo: item));
                                },
                                child: Icon(Icons.delete),
                              )
                            ],
                          );

                        },
                        separatorBuilder: (_, index) => Divider(),
                        itemCount: items.length
                    );
                  }
                  return Container();

                    }
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
