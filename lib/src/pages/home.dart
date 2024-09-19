import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/home_controller.dart';
import 'books_page.dart';
import 'graph_page.dart'; // Importing the graph page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() =>
      _HomePageState(HomeController()); // Initialize controller
}

class _HomePageState extends StateMVC<HomePage> {
  HomeController? _con; // Controller instance
  Widget? currentPage; // Store current page widget

  _HomePageState(HomeController controller) : super(controller) {
    _con = controller; // Assign the controller
  }

  @override
  void initState() {
    loadUser(); // Load the user when the page initializes
    super.initState();
  }

  // Function to load the user and display welcome message
  loadUser() async {
    await _con!.getUser();
    welcome(); // Show the welcome message when the user is loaded
  }

  // Function to set the welcome message
  welcome() {
    currentPage = Center(
      child: Text('Bienvenido ${_con!.user!.email}',
          style: const TextStyle(fontSize: 20)), // Display user's email
    );
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con!.scaffoldKey,
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.secondary, // App bar styling
          title: const Text('Bookstore App Web',
              style: TextStyle(color: Colors.white)), // App title
        ),
        body: _con!.user == null || currentPage == null
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show loader while waiting for user data
            : Row(
                children: [
                  // Always visible drawer menu
                  Container(
                    width: 250.0, // Set drawer width
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Menu options
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              // First menu item to load the BooksPage
                              ListTile(
                                leading: Icon(Icons.book),
                                title: Text('Menu 1'),
                                onTap: () {
                                  setState(() {
                                    currentPage = BooksPage(
                                        controller:
                                            _con!); // Switch to BooksPage
                                  });
                                },
                              ),
                              // Menu option visible only for admin users
                              ListTile(
                                leading: Icon(Icons.bar_chart),
                                title: Text('Menu 2'),
                                onTap: () {
                                  setState(() {
                                    currentPage = LifeExpectancyGraphPage(
                                        controller:
                                            HomeController()); // Switch to GraphPage
                                  });
                                },
                              )

                              // Empty container if user is not admin
                            ],
                          ),
                        ),

                        // Logout option at the bottom of the drawer
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title:const Text('Cerrar Sesión'),
                          onTap: () {
                            _con!
                                .logout(); // Call logout function from controller
                            setState(() {}); // Update the UI after logout
                          },
                        ),
                      ],
                    ),
                  ),

                  // Main content area that switches based on menu selection
                  Expanded(
                    child: currentPage!, // Display the selected page content
                  ),
                ],
              ));
  }
}
