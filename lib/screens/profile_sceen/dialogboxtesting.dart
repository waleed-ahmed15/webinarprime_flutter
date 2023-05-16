// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Alert Dialog',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Alert Dialog'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _textFieldController = TextEditingController();
//   String? codeDialog;
//   String? valueText;

//   Future<void> _displayTextInputDialog(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('TextField in Dialog'),
//             content: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   valueText = value;
//                 });
//               },
//               controller: _textFieldController,
//               decoration:
//                   const InputDecoration(hintText: "Text Field in Dialog"),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 // color: Colors.red,
//                 // textColor: Colors.white,
//                 child: const Text('CANCEL'),
//                 onPressed: () {
//                   setState(() {
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//               TextButton(
//                 // color: Colors.green,
//                 // textColor: Colors.white,
//                 child: const Text('OK'),
//                 onPressed: () {
//                   setState(() {
//                     codeDialog = valueText;
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: (codeDialog == "123456") ? Colors.green : Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('Alert Dialog'),
//       ),
//       body: Center(
//         child: TextButton(
//           // color: Colors.teal,
//           // textColor: Colors.white,
//           onPressed: () {
//             _displayTextInputDialog(context);
//           },
//           child: const Text('Press For Alert'),
//         ),
//       ),
//     );
//   }
// }
