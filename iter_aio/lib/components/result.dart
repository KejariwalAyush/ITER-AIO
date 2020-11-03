// import 'dart:convert';

// import 'package:flare_flutter/flare_actor.dart';
// import 'package:flutter/material.dart';

// import 'package:iteraio/MyHomePage.dart';
// import 'package:iteraio/Utilities/Theme.dart';
// import 'package:iteraio/components/Icons.dart';
// import 'package:iteraio/widgets/loading.dart';

// class Result extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ITER AIO'),
//         centerTitle: true,
//         elevation: 15,
//         // actions: <Widget>[
//         //   // IconButton(
//         //   //   icon: new Icon(Icons.share),
//         //   //   onPressed: () {},
//         //   // ),
//         //   IconButton(
//         //     icon: new Icon(Icons.feedback),
//         //     onPressed: () {
//         //       Wiredash.of(context).show();
//         //     },
//         //   ),
//         // ],
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(25),
//                 bottomRight: Radius.circular(25))),
//       ),
//       // bottomSheet: Container(
//       //   height: 20,
//       //   padding: EdgeInsets.only(bottom: 8),
//       //   alignment: Alignment.bottomCenter,
//       //   child: Text(
//       //     'All data may take some time to load.',
//       //     style: TextStyle(
//       //       fontSize: 10,
//       //     ),
//       //     textAlign: TextAlign.center,
//       //   ),
//       // ),
//       body: isLoading //|| resultData == null
//           ? Center(
//               child: Container(height: 200, child: loading()),
//             )
//           : SingleChildScrollView(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.all(15),
//                       margin: EdgeInsets.all(5),
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               height: 80,
//                               // width: 100,
//                               child: FlareActor(
//                                   "assets/animations/ITER-AIO.flr",
//                                   alignment: Alignment.center,
//                                   fit: BoxFit.cover,
//                                   animation: "hello"),
//                             ),
//                             // child: CircleAvatar(
//                             //   child: Image.asset(
//                             //     gender == 'M'
//                             //         ? 'assets/logos/maleAvtar.png'
//                             //         : 'assets/logos/femaleAvtar.png',
//                             //     fit: BoxFit.cover,
//                             //   ),
//                             //   radius: 40,
//                             //   backgroundColor: Colors.transparent,
//                             // ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Hero(
//                               tag: 'home animation',
//                               child: InkWell(
//                                 onTap: () => Navigator.pop(context, false),
//                                 child: RichText(
//                                   textAlign: TextAlign.end,
//                                   text: TextSpan(
//                                       text: '$name',
//                                       style: TextStyle(
//                                         fontSize: 25,
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(context).brightness ==
//                                                 Brightness.light
//                                             ? Colors.black87
//                                             : Colors.white,
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                             text: '\nRegd. No.:$regdNo',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Theme.of(context)
//                                                           .brightness ==
//                                                       Brightness.light
//                                                   ? Colors.black54
//                                                   : Colors.white60,
//                                             )),
//                                         TextSpan(
//                                             text: '\nSemester: $sem',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Theme.of(context)
//                                                           .brightness ==
//                                                       Brightness.light
//                                                   ? Colors.black54
//                                                   : Colors.white60,
//                                             )),
//                                       ]),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     // if (resultData == null && resultload)
//                     //   Container(
//                     //     width: 300,
//                     //     height: 300,
//                     //     child: loading(),
//                     //   )
//                     // else
//                     Column(
//                       children: <Widget>[
//                         Text(
//                           'CGPA : ' + getcgpa().toString(),
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             // color: Colors.black87
//                           ),
//                         ),
//                         for (var j in resultData)
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             margin: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).brightness ==
//                                       Brightness.light
//                                   ? colorLight
//                                   : colorDark,
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: ExpansionTile(
//                               initiallyExpanded: false,
//                               title: Text(
//                                 'Semester : ${jsonDecode(j)['Semdata'][0]['stynumber']}',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                               trailing: Text(
//                                 '${getTotalresult(j)}',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                               leading: Image.asset(
//                                 getTotalresult(j) >= 9.0
//                                     ? 'assets/logos/happy.gif'
//                                     : getTotalresult(j) >= 7.5
//                                         ? 'assets/logos/low happy.gif'
//                                         : getTotalresult(j) <= 5.0
//                                             ? 'assets/logos/sad.gif'
//                                             : 'assets/logos/low sad.gif',
//                                 fit: BoxFit.contain,
//                               ),
//                               children: <Widget>[
//                                 for (var i in jsonDecode(j)['Semdata'])
//                                   ListTile(
//                                     leading: Image.asset(
//                                       subjectAvatar(i['subjectcode']),
//                                       width: 40,
//                                     ),
//                                     title: Text(
//                                       '${i['subjectdesc']}',
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     trailing: Text(
//                                       '${i['grade']}',
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     subtitle: Text(
//                                       '${i['subjectcode']}\nEarned Credit : ${i['earnedcredit']}',
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     isThreeLine: true,
//                                   ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   double getcgpa() {
//     double sum = 0.0;
//     int cnt = 0;
//     for (var i in cgpaData['data']) {
//       sum = sum + i['sgpaR'];
//       cnt++;
//     }

//     return (sum ~/ (cnt * 0.01) / 100);
//   }

//   double getTotalresult(String x) {
//     double res;
//     for (var i in cgpaData['data']) {
//       if (i['stynumber'] == jsonDecode(x)['Semdata'][1]['stynumber'])
//         res = i['sgpaR'];
//     }
//     return res;
//   }
// }
