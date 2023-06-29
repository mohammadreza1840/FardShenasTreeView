import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

var serverData = [
  {
    "checked": null,
    "children": [
      {
        "checked": false,
        "show": false,
        "children": [],
        "id": 11,
        "pid": 1,
        "text": "Child title 11",
      },
      {
        "checked": false,
        "show": false,
        "children": [],
        "id": 12,
        "pid": 1,
        "text": "Child title 12",
      },
    ],
    "id": 1,
    "pid": 0,
    "show": false,
    "text": "Parent title 1",
  },
  {
    "checked": null,
    "show": false,
    "children": [],
    "id": 2,
    "pid": 0,
    "text": "Parent title 2",
  },
  {
    "checked": null,
    "children": [],
    "id": 3,
    "pid": 0,
    "show": false,
    "text": "Parent title 3",
  },
];

TreeNodeData mapServerDataToTreeData(Map data) {
  return TreeNodeData(
    id: data['id'],
    extra: data,
    title: data['text'],
    expaned: data['show'],
    checked: data['checked'],
    children:
        List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
  );
}

List<TreeNodeData> treeData = List.generate(
  serverData.length,
  (index) => mapServerDataToTreeData(serverData[index]),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String json =
        '''{"categories": [{"id": 1,"title": "مهارت های زندگی ","tests": [{"id": 1,"title": "مهارت امید"},{"id": 2,"title": "شهادت طلبی"},{"id": 23,"title": "مهارت مدارا"}]},{"id": 2,"title": "خانواده","tests": [{"id": 3,"title": "شوهر خوب"},{"id": 4,"title": "همسر خوب"},{"id": 25,"title": "مربی فرزندان (هفت سال اول)"}]},{"id": 3,"title": "شخصیت","tests": [{"id": 5,"title": "شخصیت های فعال و منفعل"},{"id": 6,"title": "روحیه ها"}]},{"id": 4,"title": "مراحل رشد بر اساس استعداد","tests": [{"id": 7,"title": "مرحله اول: انسانیت"},{"id": 8,"title": "مرحله دوم: اسلامیت"},{"id": 9,"title": "مرحله سوم : ایمانیت"},{"id": 10,"title": "مرحله چهارم: تقوا"},{"id": 11,"title": "مرحله پنجم: یقین"}]},{"id": 5,"title": "مراحل سقوط فرد","tests": [{"id": 12,"title": "مرحله اول: شک"},{"id": 13,"title": "مرحله دوم: شرک"},{"id": 14,"title": "مرحله سوم: کفر"},{"id": 15,"title": "مرحله چهارم: نفاق"},{"id": 16,"title": "مرحله پنجم: ارتداد و تعرب"}]},{"id": 6,"title": "شکوفایی استعداد","tests": [{"id": 17,"title": "سطح اول شکوفایی: تقوا"},{"id": 18,"title": "سطح دوم شکوفایی: احسان"},{"id": 19,"title": "سطح سوم شکوفایی: اخبات"}]},{"id": 7,"title": "اخلاق","tests": [{"id": 20,"title": "سلامت حال"},{"id": 21,"title": "وخامت حال"},{"id": 22,"title": "مراتب ارتکاب معاصی"}]},{"id": 8,"title": "آسیب های فردی","tests": [{"id": 24,"title": "پیشگیری از خودکشی"}]}]}''';

    Map<String, dynamic> data = jsonDecode(json);

    List<Category> categories = List<Category>.from(
        data['categories'].map((category) => Category.fromJson(category)));
    serverData = categories.map<Map<String, dynamic>>(
      (e) {
        return <String, dynamic>{
          "checked": false,
          "children": e.tests!.map<Map<String, dynamic>>((ee) {
            return <String, Object>{
              "checked": false,
              "show": false,
              "children": [],
              "id": ee.id!,
              "pid": e.id!,
              "text": ee.title!,
            };
          }).toList(),
          "id": e.id!,
          "pid": 0,
          "show": false,
          "text": e.title!,
        };
      },
    ).toList();

    treeData = List.generate(
      serverData.length,
      (index) => mapServerDataToTreeData(serverData[index]),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final double offsetLeft = 24.0;
  late List<AnimationController> _rotationControllers;
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);
  @override
  void initState() {
    super.initState();
    _rotationControllers = List.generate(
        serverData.length,
        ((index) => AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              treeData.length,
              (int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MouseRegion(
                      child: Container(
                        color: Colors.grey[200],
                        margin: const EdgeInsets.only(bottom: 2.0),
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (treeData[index].children.isNotEmpty)
                              RotationTransition(
                                turns: _turnsTween
                                    .animate(_rotationControllers[index]),
                                child: IconButton(
                                  iconSize: 16,
                                  icon:
                                      const Icon(Icons.expand_more, size: 16.0),
                                  onPressed: () {
                                    treeData[index].expaned =
                                        !treeData[index].expaned;
                                    if (treeData[index].expaned) {
                                      _rotationControllers[index].forward();
                                    } else {
                                      _rotationControllers[index].reverse();
                                    }
                                    setState(() {});
                                  },
                                ),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                            Checkbox(
                              value: treeData[index].checked,
                              tristate: true,
                              onChanged: (bool? value) {
                                if (value == null) {
                                  treeData[index].checked = false;
                                } else {
                                  treeData[index].checked = value;
                                }
                                setState(
                                  () {
                                    if (value != null) {
                                      if (value!) {
                                        for (var element
                                            in treeData[index].children) {
                                          element.checked = true;
                                        }
                                      } else {
                                        for (var element
                                            in treeData[index].children) {
                                          element.checked = false;
                                        }
                                      }
                                    } else {
                                      value = false;
                                      for (var element
                                          in treeData[index].children) {
                                        element.checked = false;
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  treeData[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (treeData[index].children.isNotEmpty)
                      SizeTransition(
                        sizeFactor: _rotationControllers[index],
                        child: Padding(
                          padding: EdgeInsets.only(left: offsetLeft),
                          child: Column(
                            children: [
                              ...List.generate(
                                treeData[index].children.length,
                                (index2) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      MouseRegion(
                                        child: Container(
                                          color: Colors.grey[200],
                                          margin: const EdgeInsets.only(
                                              bottom: 2.0),
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                              ),
                                              Checkbox(
                                                value: treeData[index]
                                                    .children[index2]
                                                    .checked,
                                                onChanged: (bool? value) {
                                                  treeData[index]
                                                      .children[index2]
                                                      .checked = value!;
                                                  setState(
                                                    () {
                                                      if (treeData[index]
                                                          .children
                                                          .every((element) =>
                                                              element.checked ==
                                                              true)) {
                                                        treeData[index]
                                                            .checked = true;
                                                      } else if (treeData[index]
                                                              .children
                                                              .any((element) =>
                                                                  element
                                                                      .checked ==
                                                                  true) &&
                                                          treeData[index]
                                                              .children
                                                              .any((element) =>
                                                                  element
                                                                      .checked ==
                                                                  false)) {
                                                        treeData[index]
                                                            .checked = null;
                                                      } else {
                                                        treeData[index]
                                                            .checked = false;
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 6.0),
                                                  child: Text(
                                                    treeData[index]
                                                        .children[index2]
                                                        .title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            TextButton(
                onPressed: () {
                  List<TreeNodeData> selected = [];
                  treeData.forEach((element) {
                    selected.addAll(element.children
                        .where((element) => element.checked == true));
                  });
                  print(selected.map((e) => <int, String>{e.id: e.title}));
                },
                child: const Text('ارسال'))
          ],
        ),
      ),
    );
  }
}

class Category {
  int? id;
  String? title;
  List<Test>? tests;

  Category({this.id, this.title, this.tests});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      tests: List<Test>.from(json['tests'].map((test) => Test.fromJson(test))),
    );
  }
}

class Test {
  int? id;
  String? title;

  Test({this.id, this.title});

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      title: json['title'],
    );
  }
}

class TreeNodeData {
  int id;
  String title;
  bool expaned;
  bool? checked;
  dynamic extra;
  List<TreeNodeData> children;
  AnimationController? rotationController;

  TreeNodeData({
    required this.id,
    required this.title,
    required this.expaned,
    required this.checked,
    required this.children,
    this.rotationController,
    this.extra,
  });
}
