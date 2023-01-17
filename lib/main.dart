import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertask/home.dart';
import 'package:fluttertask/model.dart';
import 'package:hovering/hovering.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBZ9FTi-Mlk-0JNX9-qPIPECFOC94LcKTo",
          authDomain: "fluttertask-fecf6.firebaseapp.com",
          projectId: "fluttertask-fecf6",
          storageBucket: "fluttertask-fecf6.appspot.com",
          messagingSenderId: "258725963372",
          appId: "1:258725963372:web:0b29df4f9e351389081a49",
          measurementId: "G-SHP3ELP6JZ"));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setState(() {
      GetData.refreshdata(this);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController password = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  TextEditingController userId = new TextEditingController();
  List<Users> a = [];
  // var password, userId;
  @override
  void initState() {
    setState(() {
      GetData.refreshdata(this);
    });
    super.initState();
  }

  // void adddata() async {
  //   QuerySnapshot snap =
  //       await FirebaseFirestore.instance.collection('Users').get();
  //   snap.docs.forEach((element) {
  //     print(element.get('username'));
  //     // print(element.get('username'));
  //     a.add(Users(element.get('username'), element.get('password')));
  //     a.forEach((element) {
  //       print(element.userid);
  //     });
  //   });
  // }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Employee Login',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEqHXwSz1u8Netep301Mkuu9thY6WisMW8SQ&usqp=CAU"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _container(
                'username',
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                  controller: userId,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 0.3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _container(
                'password',
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a valid password!';
                    }
                    return null;
                  },
                  controller: password,
                  obscureText: !showPassword,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 0.3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  _submit();
                  print(userId.text);
                  print(password.text);

                  QuerySnapshot snap = await FirebaseFirestore.instance
                      .collection('Users')
                      .get();

                  snap.docs.forEach((element) {
                    print(element.get('username') +
                        element.get('password') +
                        "data..");

                    if (userId.text == element.get('username') &&
                        password.text == element.get('password')) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Logging you in')));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Something Went Wrong')));
                    }
                  });

                  // FirebaseFirestore.instance.collection("Users").add(
                  //     {"username": userId.text, "password": password.text});
                },
                child: HoverContainer(
                  height: 50,
                  width: size.width / 4,
                  hoverHeight: 50,
                  hoverWidth: size.width / 4,
                  decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(5)),
                  hoverDecoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                      child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _container(
    String name,
    Widget w,
  ) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(
          left: size.width > 800
              ? 200
              : size.width > 500
                  ? 60
                  : 20,
          right: size.width > 800
              ? 200
              : size.width > 500
                  ? 60
                  : 20,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            name,
          ),
          const SizedBox(
            height: 20,
          ),
          w
        ]));
  }
}
