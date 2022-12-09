// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_work_test/database_service.dart';
import 'package:flutter_work_test/showform.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'datalist_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  void initState() {
    readDataList();
    super.initState();
  }

  Stream<List<DataListModel>> readDataList() => FirebaseFirestore.instance
      .collection("Data")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => DataListModel.fromJson(e.data())).toList());

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 165, 10, 255),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 205),
                            child: Text(
                              "Hello User",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25),
                            ),
                          ),
                          h(10),
                          Padding(
                            padding: const EdgeInsets.only(right: 90),
                            child: Text(
                              "What are you going to do?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                          h(10),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: ShowForm(
                              controller: controller,
                              label: "Add To-Do",
                              iconButton: IconButton(
                                onPressed: () {
                                  final text = controller.text;
                                  final number = 0;
                                  controller.clear();
                                  try {
                                    EasyLoading.showSuccess(
                                        'Save Data Successfully');
                                    DataBaseService.createData(text, number);
                                  } catch (e) {
                                    EasyLoading.showError('Error : $e');
                                    Timer(Duration(seconds: 2), () {
                                      EasyLoading.dismiss();
                                    });
                                  }
                                },
                                icon: Icon(Icons.add),
                              ),
                            ),
                          ),
                          h(10),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 170, bottom: 10),
                            child: Text(
                              "Your To-Do List : ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: readDataList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("No Information Yet...");
                    } else if (snapshot.hasData) {
                      final datas = snapshot.data!;

                      return Expanded(
                        child: ListView(
                          children: datas.map(buildData).toList(),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildData(
    DataListModel dataList,
  ) =>
      Card(
        child: ListTile(
          leading: Checkbox(
            value: dataList.number == 0 ? false : true,
            onChanged: (v) {
              setState(() {
                isChecked = v!;
                if (isChecked == true) {
                  updateData(dataList.id!, 1);
                } else if (isChecked == false) {
                  updateData(dataList.id!, 0);
                }
              });
            },
            activeColor: Color.fromARGB(255, 165, 10, 255),
          ),
          title: dataList.number == 1
              ? Text(dataList.text ?? '',
                  style: TextStyle(decoration: TextDecoration.lineThrough))
              : Text(
                  dataList.text ?? '',
                ),
          trailing: IconButton(
              onPressed: () {
                dataList.number == 1
                    ? onSubmit(dataList.id!)
                    : EasyLoading.showError('Error Deleting Data.');
              },
              icon: Icon(Icons.delete_forever_outlined)),
        ),
      );
}

updateData(String id, int number) {
  try {
    final dataList = FirebaseFirestore.instance.collection("Data").doc(id);
    dataList.update({"number": number});
  } catch (e) {
    print(e);
  }
}

onSubmit(String id) {
  try {
    final dataLists = FirebaseFirestore.instance.collection("Data").doc(id);
    EasyLoading.showSuccess("Successful Data Deletion.");
    dataLists.delete();
  } catch (e) {
    print(e);
  }
}

Widget h(double height) {
  return SizedBox(
    height: height,
  );
}

Widget w(double width) {
  return SizedBox(
    height: width,
  );
}

Widget showDataCard(BuildContext context, bool isCheck, String text) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        height: 50,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Row(
              children: [
                Checkbox(value: isCheck, onChanged: (v) {}),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 150),
                  child: Text('data'),
                ),
                IconButton(
                    onPressed: () {
                      // DataBaseService.readData(text);
                    },
                    icon: Icon(Icons.delete_forever_outlined)),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
