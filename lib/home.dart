import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_bloc/todo_bloc.dart';
import 'data/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
      AddTodo(todo),
    );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
      RemoveTodo(todo),
    );
  }

  editTodo(Todo todo){
    context.read<TodoBloc>().add(
      EditTodo(todo),
    );
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(
        AlterTodo(index)
    );
  }

  void _showEditDialog(Todo todo) {
    TextEditingController titleController = TextEditingController(text: todo.title);
    TextEditingController subtitleController = TextEditingController(text: todo.subtitle);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                cursorColor: Theme.of(context).colorScheme.secondary,
                decoration: InputDecoration(
                  hintText: 'Task Title...',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: subtitleController,
                cursorColor: Theme.of(context).colorScheme.secondary,
                decoration: InputDecoration(
                  hintText: 'Task Description...',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Zapisz zmiany do bloc-a
                Todo editedTodo = Todo(
                  title: titleController.text,
                  subtitle: subtitleController.text,
                  isDone: todo.isDone,
                );
                editTodo(editedTodo);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  TextEditingController controller1 = TextEditingController();
                  TextEditingController controller2 = TextEditingController();

                  return AlertDialog(
                    title: const Text(
                        'Add a Task'
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        TextField(
                          controller: controller1,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          decoration: InputDecoration(
                            hintText: 'Task Title...',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controller2,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          decoration: InputDecoration(
                            hintText: 'Task Description...',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextButton(
                            onPressed: () {
                              addTodo(
                                Todo(
                                    title: controller1.text,
                                    subtitle: controller2.text
                                ),
                              );
                              controller1.text = '';
                              controller2.text = '';
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Icon(
                                  CupertinoIcons.check_mark,
                                  color: Colors.green,
                                )
                            )
                        ),
                      )
                    ],
                  );
                }
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.black,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          title: const Text(
            'My ToDo App',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if(state.status == TodoStatus.success) {
                return Column( children: [
                  TextField(
                    controller: searchController,
                    onChanged: (query) {
                      // Wysyłanie zapytania o wyszukiwanie do TodoBloc
                      context.read<TodoBloc>().add(SearchTodo(query));
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                    ),
                  ),
                  Expanded(child:
                  ListView.builder(
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, int i) {
                      return Card(
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Slidable(
                            key: const ValueKey(0),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    removeTodo(state.searchResults[i]);
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) {
                                    _showEditDialog(state.todos[i]);
                                  },
                                  backgroundColor: const Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            child: ListTile(
                                title: Text(
                                    state.searchResults[i].title
                                ),
                                subtitle: Text(
                                    state.searchResults[i].subtitle
                                ),
                                trailing: Checkbox(
                                    value: state.searchResults[i].isDone,
                                    activeColor: Theme.of(context).colorScheme.secondary,
                                    onChanged: (value) {
                                      alertTodo(i);
                                    }
                                )
                            )
                        ),
                      );
                    }
                  ),
                ),],);
              } else if (state.status == TodoStatus.initial){
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container();
              }
            },
          ),
        )
    );
  }
}