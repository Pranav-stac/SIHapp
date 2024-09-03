import 'package:flutter/material.dart';
import 'texttosign.dart';
import 'signtotext.dart';
import 'homescreen.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  _TutorialsScreenState createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _navigateToScreen(const HomeScreen());
        break;
      case 1:
        _navigateToScreen(const TextToSignScreen());
        break;
      case 2:
        _navigateToScreen(const SignToTextScreen());
        break;
      case 3:
        _navigateToScreen(const TutorialsScreen());
        break;
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Tutorials'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          _buildTutorialItem(
              'Alphabet Signs', 'Learn the basic hand signs for each letter'),
          _buildTutorialItem(
              'Numbers', 'Learn how to sign numbers from 0 to 9'),
          _buildTutorialItem(
              'Common Phrases', 'Learn everyday phrases in sign language'),
          _buildTutorialItem(
              'Emotions', 'Express feelings through sign language'),
          _buildTutorialItem('Colors', 'Learn to sign different colors'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text to Sign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gesture),
            label: 'Sign to Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Tutorials',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor:
            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTutorialItem(String title, String description) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: Implement navigation to specific tutorial
          print('Tapped on $title tutorial');
        },
      ),
    );
  }
}
