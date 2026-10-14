import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8FB583),
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoItem {
  final String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoItem> _todos = [];

  static const Color _green = Color(0xFF8FB583);
  static const Color _textDark = Color(0xFF2D2D2D);
  static const Color _textGrey = Color(0xFF9A9A9A);

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tulis sesuatu dulu ya'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    setState(() {
      _todos.add(TodoItem(title: text));
      _controller.clear();
    });
  }

  void _toggleDone(int index) {
    setState(() => _todos[index].isDone = !_todos[index].isDone);
  }

  void _deleteTodo(int index) {
    setState(() => _todos.removeAt(index));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD3E2C8), Color(0xFFF3F5F1), Color(0xFFF7F7F5)],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildInputRow(),
                const SizedBox(height: 20),
                Expanded(
                  child: _todos.isEmpty ? _buildEmpty() : _buildList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning,',
          style: TextStyle(fontSize: 13, color: _textDark),
        ),
        SizedBox(height: 2),
        Text(
          'My To-Do List',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addTodo(),
              decoration: const InputDecoration(
                hintText: 'Tulis tugas baru...',
                hintStyle: TextStyle(color: _textGrey),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _addTodo,
          child: Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x338FB583),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist_rounded, size: 64, color: Color(0xFFBFD0B6)),
          SizedBox(height: 12),
          Text(
            'Belum ada tugas',
            style: TextStyle(color: _textGrey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _todos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final todo = _todos[index];

        return Dismissible(
          key: ObjectKey(todo),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteTodo(index),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            color: const Color(0xFFF28B82),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          child: GestureDetector(
            onTap: () => _toggleDone(index),
            child: _buildCard(todo, index),
          ),
        );
      },
    );
  }

  Widget _buildCard(TodoItem todo, int index) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRect(
        child: IntrinsicHeight(
          child: Row(
            children: [
              const SizedBox(width: 20),
              Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: todo.isDone ? _textGrey : _textDark,
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
            ],
          ),
        ),
      ),
    );
  }
}