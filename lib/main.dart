import 'package:flutter/material.dart';
import 'package:uts/database_helper.dart';
import 'package:uts/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List App',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'To Do List App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
   
  final dbHelper = DatabaseHelper();
  List<Todo> _todos = [];
  // int _count = 0;

  void refreshItemList() async {
    final todos = await dbHelper.getAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  void searchItems() async {
    final keyword = _searchController.text.trim();
    if (keyword.isNotEmpty) {
      final todos = await dbHelper.searchTodo(keyword);
      setState(() { 
        _todos = todos;
      });
    } else {
      refreshItemList();
    }
  }

  void addItem(String title, String desc) async {
    final todo =
        Todo(title: title, description: desc, completed: false);
    await dbHelper.insertTodo(todo);
    refreshItemList();
  }

  void updateItem(Todo todo, bool completed) async {
    
    final item = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: completed,
    );
    await dbHelper.updateTodo(item);
    refreshItemList();
  }

void updateItem2(Todo todo,String jdl, String desk, bool completed) async {
    
    final item = Todo(
      id: todo.id,
      title: jdl,
      description: desk,
      completed: completed,
    );
    await dbHelper.updateTodo(item);
    refreshItemList();
  }

  void deleteItem(int id) async {
    await dbHelper.deleteTodo(id);
    refreshItemList();
  }

  @override
  void initState() {
    refreshItemList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 16, 15, 15),
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        
        title: Text(widget.title),
      ),
      body: Column(
        
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search,color: Colors.white),
                border: OutlineInputBorder(
                ),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70), 
      ),
              ),
              onChanged: (_) {
                searchItems();
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  var todo = _todos[index];
                  return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6
                        ,vertical: 10),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: 
                            BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 41, 39, 39),
                                offset: Offset(5.0, 5.0),
                                blurRadius: 6.0,
                            ),
                            ],
                        ),
                    height: 100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                    ),
                    child: ListTile(
                      textColor: Colors.white,
                      onTap: (){
                      showTodoDetailsDialog(context,todo);
                      },
                      leading: todo.completed
                          ? IconButton(
                              icon: const Icon(Icons.check_circle,color: Colors.white70),
                              onPressed: () {
                                updateItem(todo, !todo.completed);
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.radio_button_unchecked,color: Colors.white70),
                              onPressed: () {
                                updateItem(todo, !todo.completed);
                              },
                            ),
                      title: Text(todo.title),
                      subtitle: Text(todo.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white70),
                        onPressed: () {
                          deleteItem(todo.id!);
                        },
                      ),
                    ),
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tambah Yang Akan Dilakukan'),
              content: SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Judul',hintText: 'Judul todo'),
                    ),
                    TextField(
                      controller: _descController,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi',hintText: 'Deskripsi todo'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Batalkan'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Tambah'),
                  onPressed: () {
                    addItem(_titleController.text, _descController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }, 
        child: const Icon(Icons.add),
      ),
    );
  }

    void showTodoDetailsDialog(BuildContext context,Todo todo){
    TextEditingController titleController2 = TextEditingController(text: todo.title);
    TextEditingController descController2 = TextEditingController(text: todo.description);
    showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Update Yang Akan Dilakukan'),
              content: SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: titleController2,
                      decoration:  const InputDecoration(labelText: 'Judul', hintText: 'Judul Todo'),
                    ),
                    TextField(
                      controller: descController2,
                      decoration:
                          const InputDecoration(labelText: 'Deskripsi', hintText: 'Deskripsi todo'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Batalkan'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('Update'),
                  onPressed: () {
                    updateItem2(todo,titleController2.text, descController2.text,!todo.completed);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
  }

