import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class Hquery {
  String id = "";
  final db = FirebaseFirestore.instance;

  Future<String> push(root, data) async {
    DocumentReference ref = await db.collection(root).add(data);
    id = ref.id;
    return ref.id.toString();
  }

  Future getDataByID(root, key) async {
    DocumentSnapshot snapshot = await db.collection(root).doc(key).get();
    //print("==== ${snapshot.data()}");
    return snapshot.data();
  }

  Future<dynamic> getKeyByData(root, key, value) async {
    var ids = await getIDs(root);

    for (var i in ids) {
      var d = await getDataByID(root, i);

      try {
        if (d[key] == value) {
          return i;
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  Future<dynamic> getDataByData(root, key, value) async {
    var ids = await getIDs(root);
    // print("ids : ${ids.length}");
    for (var i in ids) {
      var d = await getDataByID(root, i);
      // print("d : $d");
      try {
        if (d[key] == value) {
          // print("data : ${d[key]}");
          d["id"] = i;
          return d;
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  Future<dynamic> fastGetDataByData(
    root,
    key,
    value, {
    allData: const [],
  }) async {
    var ids = (await getIDs(root)).toList();
    // print("ids : ${ids}");
    for (int i = 0; i < ids.length; i++) {
      // var d = await getDataByID(root, i);
      print("d : ${allData[i]}");
      var thisdata = allData[i] as Map;

      try {
        if (thisdata[key] == value) {
          // print("alldata: ${allData[i][key]}");
          // print("alldata: ${allData[i]}");
          allData[i]["id"] = ids[i];
          return allData[i];
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  Future<dynamic> getAllDataByData(root, key, value) async {
    // ignore: todo
    // TODO: Get all data fast
    // QuerySnapshot snapshot = await db.collection(root).get();
    // var data = [];

    // for (DocumentSnapshot item in snapshot.docs) {
    //   try {
    //     if (item[key] == value) {
    //       var temp = item.data();
    //       item['id'] = item.id;
    //       data.add(item);
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    var ids = await getIDs(root);
    var data = [];

    for (var i in ids) {
      var d = await getDataByID(root, i);

      try {
        if (d[key] == value) {
          d['id'] = i;
          data.add(d);
        }
      } catch (e) {
        print(e);
      }
    }
    //print("data List are =======> : $data");
    return data;
  }

  Future<List> getIDs(root) async {
    QuerySnapshot snapshot = await db.collection(root).get();
    List<String> ids = [];

    // Loop through items
    for (DocumentSnapshot item in snapshot.docs) {
      ids.add(item.id);
    }

    return ids;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getDatas(root) async {
    QuerySnapshot snapshot = await db.collection(root).get();

    return snapshot.docs;
  }

  Future<bool> checkID(root, key) async {
    DocumentSnapshot snapshot = await db.collection(root).doc(key).get();
    return snapshot.exists;
  }

  Future<bool> update(root, key, data) async {
    await db.collection(root).doc(key).update(data).whenComplete(() => null);
    return true;
  }

  Future<bool> deleteByID(root, key) async {
    await db.collection(root).doc(key).delete();
    return true;
  }

  Future<bool> deleteByIDKeys(root, key, ids) async {
    var data = await getDataByID(root, key);

    for (var i in ids) {
      if (data.keys.contains(i)) {
        data[i] = FieldValue.delete();
      }
    }

    await update(root, key, data);
    return true;
  }

  Future<dynamic> deleteAllDataByData(root, key, value) async {
    var ids = await getIDs(root);
    var deletedIDs = [];

    for (var i in ids) {
      var d = await getDataByID(root, i);
      try {
        if (d[key] == value) {
          await deleteByID(root, i);
          deletedIDs.add(i);
        }
      } catch (e) {
        print(e);
      }
    }

    return deletedIDs;
  }

  Future<dynamic> fastDeleteAllDataByData(
    root,
    key,
    value, {
    allData: const [],
  }) async {
    var ids = await getIDs(root);

    for (int i = 0; i < ids.length; i++) {
      // var d = await getDataByID(root, i);
      // print("data: $d");
      try {
        if (allData[i][key] == value) {
          await deleteByID(root, ids[i]);
        }
      } catch (e) {
        print(e);
      }
    }

    return true;
  }

  // Future<bool> downloadFromUrl(url, fileName)async{
  //   var status = await Permission.storage.request();
  //   if(status.isGranted){

  //     var exdir = await getExternalStorageDirectory();

  //     await FlutterDownloader.enqueue(
  //       url: url,
  //       savedDir: exdir.path,
  //       fileName: fileName,
  //       showNotification: true,
  //       openFileFromNotification: true
  //     );

  //     return true;

  //   }else{
  //     return false;
  //   }
  // }

  Stream<QuerySnapshot> getSnap(String root) {
    return FirebaseFirestore.instance.collection(root).snapshots();
  }

  Stream<QuerySnapshot> getSnapSorted(String root, String by) {
    return FirebaseFirestore.instance.collection(root).orderBy(by).snapshots();
  }

  Stream<QuerySnapshot> getSnapSortedR(String root, String by) {
    return FirebaseFirestore.instance.collection(root).orderBy(by, descending: true).snapshots();
  }

  Stream<DocumentSnapshot> getSnapByID(String root, String key) {
    return FirebaseFirestore.instance.collection(root).doc(key).snapshots();
  }
}

// Speed get data functions
class HSquery {
  final hq = Hquery();

  List<Map<String, dynamic>> getDatas(String root) {
    List<Map<String, dynamic>> data = [];

    hq.getSnap("users").forEach((element) {
      var rawdata = element.docs;
      for (var item in rawdata) {
        if (item.exists) {
          data.add({item.id: item.data()});
        }
      }
    });

    return data;
  }

  Map getDataByID(String root, String id) {
    var allData = getDatas(root);
    for (var item in allData) {
      if (item.containsKey(id)) {
        return item;
      }
    }

    return {};
  }
}

// This is a weak logic yet.
// This not flexible and this page will stack if it is not poped
// This is because there is no statement that will catch if the snaphot has error or null.

class GetData extends StatefulWidget {
  final root;
  final getType;
  final id;
  final value;
  final keyOfData;
  final listOfId;
  final listOfData;
  final returnType;

  GetData({
    required this.root,
    this.getType = "getAllData",
    this.returnType = "list",
    this.id = "",
    this.value = "",
    this.keyOfData = "",
    this.listOfId = const [],
    this.listOfData = const [],
  });
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  String root = "";
  String getType = "";
  String returnType = "";
  String id = "";
  String value = "";
  String keyOfData = "";
  var listOfId = [];
  var listOfData = [];
  @override
  void initState() {
    root = widget.root;
    getType = widget.getType;
    id = widget.id;
    value = widget.value;
    keyOfData = widget.keyOfData;
    listOfId = widget.listOfId;
    listOfData = widget.listOfData;
    returnType = widget.returnType;
    super.initState();
  }

  var hq = Hquery();
  bool isFunctionCalled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: streamGetAllData(context),
    );
  }

  Widget streamGetAllData(BuildContext gContext) {
    return StreamBuilder<QuerySnapshot>(
      stream: hq.getSnap(root),
      builder: (gContext, snapshot) {
        if (snapshot.hasData) {
          if (getType == "getAllData") {
            List data = snapshot.data!.docs;
            popFunction(gContext, data);
          } else if (getType == "getAllDataList") {
            List snapData = snapshot.data!.docs;
            List data = [];
            for (var d in snapData) {
              data.add(d.data());
            }
            popFunction(gContext, data);
          } else if (getType == "getAllId") {
            return streamGetAllId(gContext);
          } else if (getType == "getAllDataByData") {
            return streamGetAllDataByData(gContext, returnType);
          } else if (getType == "getDataById") {
            return streamGetDataById(gContext);
          } //else {
          // print("!!!!!!!!!!!!!!! Something went wrong !!!!!!!!!!!!!!!!!");
          //}
        }
        return returnCcntainer();
      },
    );
  }

  Widget streamGetAllId(BuildContext gAIContext) {
    return StreamBuilder<QuerySnapshot>(
      stream: hq.getSnap(root),
      builder: (gAIContext, snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data!.docs;
          List returnData = [];
          for (var datum in data) {
            returnData.add(datum.id);
          }
          popFunction(gAIContext, returnData);
        } //else {
        //print("!!!!!!!!!!!!!!! Something went wrong !!!!!!!!!!!!!!!!!");
        //}
        return returnCcntainer();
      },
    );
  }

  Widget streamGetDataById(BuildContext gDBIContext) {
    return StreamBuilder<QuerySnapshot>(
      stream: hq.getSnap(root),
      builder: (gDBIContext, snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data!.docs;
          var returnData;
          for (var datum in data) {
            //print("====== ${datum.id} ===== $id ======");
            if (datum.id == id) {
              returnData = datum.data();
              print("%%%%%%%%%%% returnData:  $returnData");
            }
          }
          print("%%%%%%%%%%%>>>>>> returnData:  $returnData");
          popFunction(gDBIContext, returnData);
        } //else {
        //print("!!!!!!!!!!!!!!! Something went wrong !!!!!!!!!!!!!!!!!");
        //}
        return returnCcntainer();
      },
    );
  }

  Widget streamGetAllDataByData(BuildContext gADBDContext, String returnType) {
    return StreamBuilder<QuerySnapshot>(
      stream: hq.getSnap(root),
      builder: (gADBDContext, snapshot) {
        if (snapshot.hasData) {
          List data = [];
          var d;

          for (var i in listOfId) {
            for (var getDt in listOfData) {
              var dt = getDt;
              if (dt.id == i) {
                d = dt.data();
              }
            }
            //print("====== ${d[keyOfData]} == ${value} ==");
            try {
              if (d[keyOfData] == value) {
                d['id'] = i;
                if (returnType == "map") {
                  Map retd = d;
                  popFunction(gADBDContext, retd);
                } else {
                  data.add(d);
                }

                //
              }
            } catch (e) {
              print(e);
            }
          }
          popFunction(gADBDContext, data);
        } //else {
        //print("!!!!!!!!!!!!!!! Something went wrongsssss !!!!!!!!!!!!!!!!!");
        //}

        return returnCcntainer();
      },
    );
  }

  Widget returnCcntainer() {
    return Container(
        //child: Center(
        //child: Text(
        //"If you see this screen, please do the following. This might help you \n\n1. Press back button on your phone. \n2. Restart this application. \n3. Report this bug/error to Eihap. "),
        //),
        );
  }

  popFunction(BuildContext popContext, var data) async {
    if (!isFunctionCalled) {
      isFunctionCalled = true;
      await Future.delayed(Duration.zero, () async {
        Navigator.pop(popContext, data);
      });
    }
  }
}
