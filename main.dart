import 'package:flutter/material.dart';

void main() {
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.orangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoTask> todoTasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Todo List',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('All Tasks'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Add more drawer items as needed
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoTasks.length,
              itemBuilder: (context, index) {
                return TodoTaskItem(
                  task: todoTasks[index],
                  onTaskComplete: () {
                    setState(() {
                      todoTasks[index].isCompleted = !todoTasks[index].isCompleted;
                    });
                  },
                  onDeleteTask: () {
                    setState(() {
                      todoTasks.removeAt(index);
                    });
                  },
                  onTap: () {
                    _showTaskDetails(todoTasks[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(hintText: 'Enter task'),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      setState(() {
                        todoTasks.add(TodoTask(taskController.text));
                        taskController.clear();
                      });
                    }
                  },
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(TodoTask task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Title: ${task.title}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Status: ${task.isCompleted ? 'Completed' : 'Pending'}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TodoTask {
  final String title;
  bool isCompleted;

  TodoTask(this.title, {this.isCompleted = false});
}

class TodoTaskItem extends StatelessWidget {
  final TodoTask task;
  final VoidCallback onTaskComplete;
  final VoidCallback onDeleteTask;
  final VoidCallback onTap;

  TodoTaskItem({required this.task, required this.onTaskComplete, required this.onDeleteTask, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            onTaskComplete();
          },
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDeleteTask,
        ),
        onTap: onTap,
      ),
    );
  }
}
