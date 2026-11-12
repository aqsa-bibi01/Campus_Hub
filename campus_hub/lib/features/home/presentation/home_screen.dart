import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../data/in_memory_task_repository.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = InMemoryTaskRepository();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const _ExploreContent(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Hub'),
        actions: [
          IconButton(
            tooltip: 'Add task',
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          ),
        ],
      ),
      drawer: NavigationDrawer(
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.school, size: 36),
                SizedBox(height: 8),
                Text('Campus Hub'),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              if (_selectedIndex != 0) {
                setState(() => _selectedIndex = 0);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.explore_outlined),
            title: const Text('Explore'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.widgets_outlined),
            title: const Text('UI Showcase'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/showcase');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About this lab'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Campus Hub',
                applicationVersion: '1.0.0',
                children: const [Text('A beginner Flutter flow demo.')],
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: pages[_selectedIndex]),
    );
  }

  Widget _buildHomeContent() {
    final tasks = _repository.getTasks();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Good morning!', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text('Your student workspace at a glance.'),
        const SizedBox(height: 16),
        const AnimatedWelcomeCard(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Tasks',
                value: '${tasks.length}',
                icon: Icons.checklist,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: _StatCard(
                title: 'Courses',
                value: '3',
                icon: Icons.menu_book_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text('My tasks', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        ...tasks.map(
          (task) => Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.task_alt)),
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openTask(task),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: _addTask,
          icon: const Icon(Icons.add),
          label: const Text('Add a task'),
        ),
      ],
    );
  }

  void _openTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: task),
      ),
    ).then((_) => setState(() {}));
  }

  Future<void> _addTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );
    if (task != null) {
      setState(() => _repository.addTask(task));
    }
  }
}

class AnimatedWelcomeCard extends StatefulWidget {
  const AnimatedWelcomeCard({super.key});

  @override
  State<AnimatedWelcomeCard> createState() => _AnimatedWelcomeCardState();
}

class _AnimatedWelcomeCardState extends State<AnimatedWelcomeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(_expanded ? 28 : 16),
        decoration: BoxDecoration(
          color: _expanded
              ? const Color(0xFF64B6AC)
              : const Color(0xFFE3F2F7),
          borderRadius: BorderRadius.circular(_expanded ? 24 : 12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.waving_hand, size: 30),
            const SizedBox(height: 8),
            Text(_expanded ? 'Welcome to Campus Hub!' : 'Welcome back!'),
            if (_expanded)
              const Text('Tap again to return to compact view.'),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 26),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class _ExploreContent extends StatelessWidget {
  const _ExploreContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          'Explore',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.event_outlined),
            title: Text('Upcoming events'),
            subtitle: Text('Workshop, seminar, and society activities'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.library_books_outlined),
            title: Text('Learning resources'),
            subtitle: Text('Notes and project ideas'),
          ),
        ),
      ],
    );
  }
}
