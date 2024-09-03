import 'package:flutter/material.dart';
import 'texttosign.dart';
import 'signtotext.dart';
import 'tutorials.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Key _contentKey = UniqueKey();

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
        title: const Text('Sign Language Translator'),
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.person, color: Colors.black, size: 25),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildContent(_contentKey),
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

  Widget _buildContent(Key key) {
    return Column(
      key: key,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 9, 96, 12),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome, User!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 24), // Placeholder to balance the row
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/sign_language.gif',
                  width: 200,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: <Widget>[
                _buildContainer('Text to Sign', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TextToSignScreen()),
                  );
                }, imagePath: 'assets/text_to_sign.png'),
                _buildContainer('Sign to Text', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignToTextScreen()),
                  );
                }, imagePath: 'assets/sign_to_text.png'),
                _buildContainer('Signs Tutorials', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorialsScreen()),
                  );
                }, imagePath: 'assets/sign_tut.png'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContainer(String text, VoidCallback onTap, {String? imagePath}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (imagePath == null)
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
