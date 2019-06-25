import 'package:flutter/material.dart';
import 'package:onboarding_flow/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onboarding_flow/models/user.dart';

class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  MainScreen({this.firebaseUser});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text("Home"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                _logOut();
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: Auth.getUser(widget.firebaseUser.uid),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(212, 20, 15, 1.0),
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    child: CircleAvatar(
                      backgroundImage: (snapshot.data.profilePictureURL != '')
                          ? NetworkImage(snapshot.data.profilePictureURL)
                          : AssetImage("assets/images/default.png"),
                    ),
                  ),
                  Text("Name: ${snapshot.data.firstName}"),
                  Text("Email: ${snapshot.data.email}"),
                  Text("UID: ${snapshot.data.userID}"),
                ],
              ),
            );
  Widget build(BuildContext context) {
    final appState = AppState();

    return FadeInWidget(
      duration: 750,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: ValueBuilder<List<Category>>(
          streamed: appState.categoriesStream,
          noDataChild: const CircularProgressIndicator(),
          builder: (context, snapshot) {
            final categories = snapshot.data;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 56.0),
                      child: const Text(
                        'TRIVIA',
                        style: TextStyle(
                          fontSize: 46.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.lightBlueAccent,
                              offset: Offset(3.0, 4.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Choose a category:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 14.0,
                            color: Colors.lightBlueAccent,
                          ),
                        ],
                      ),
                    ),
                    ValueBuilder<Category>(
                      streamed: appState.categoryChosen,
                      builder: (context, snapshotCategory) =>
                          DropdownButton<Category>(
                            isExpanded: true,
                            value: snapshotCategory.data,
                            onChanged: appState.setCategory,
                            items: categories
                                .map<DropdownMenuItem<Category>>(
                                  (value) => DropdownMenuItem<Category>(
                                        value: value,
                                        child: Text(
                                          value.name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                )
                                .toList(),
                          ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: 36,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(35),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue,
                              blurRadius: 2.0,
                              spreadRadius: 2.5),
                        ]),
                    child: const Text(
                      'Play trivia',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  onTap: appState.startTrivia,
                ),
              ],
            );
          },
        ),
      ),
    );
}
            
          }
        },
      ),
    );
  }

  void _logOut() async {
    Auth.signOut();
  }
}
