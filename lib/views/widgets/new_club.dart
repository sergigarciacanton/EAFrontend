import 'dart:developer';

import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/routes/club_service.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../localization/language_constants.dart';
import '../../models/newclub.dart';
import '../../models/user.dart';
import '../../routes/management_service.dart';
import '../../routes/user_service.dart';

class NewClub extends StatefulWidget {
  const NewClub({Key? key}) : super(key: key);

  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String idController = "";
  String categoriesController = "";
  List<CategoryList> selectedCategory = List.empty(growable: true);
  List<CategoryList> categoryList = [];
  List<Category> _response = List.empty(growable: true);
  bool _isLoading = true;

  void initState() {
    super.initState();
    getCategories();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idController = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(idController);
  }

  Future<void> getCategories() async {
    _response = await ManagementService.getCategories();
    setState(() {
      for (int i = 0; i < _response.length; i++) {
        CategoryList category1 = new CategoryList(
            _response[i].id.toString(), _response[i].name.toString(), false);
        categoryList.add(category1);
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(getTranslated(context, "newClub")!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).backgroundColor,
                ),
                body: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Image.network(
                          "https://cdn-icons-png.flaticon.com/512/4693/4693893.png",
                          height: 150),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return getTranslated(context, "fieldRequired");
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                labelText: getTranslated(context, "name"),
                                hintText:
                                    getTranslated(context, "writeTheNameClub"),
                                border: OutlineInputBorder()),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: 8,
                            maxLength: 500,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return getTranslated(context, "fieldRequired");
                              }
                              return null;
                            },
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                labelText:
                                    getTranslated(context, "description"),
                                hintText: getTranslated(
                                    context, "writeTheDescription"),
                                border: OutlineInputBorder()),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getTranslated(context, 'selectCategories')!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 450.0,
                              child: _isLoading
                                  ? Column(
                                      children: const [
                                        SizedBox(height: 10),
                                        LinearProgressIndicator(),
                                        SizedBox(height: 200),
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: categoryList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return categoryItem(
                                          categoryList[index].id,
                                          categoryList[index].name,
                                          categoryList[index].isSlected,
                                          index,
                                        );
                                      }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text(
                          getTranslated(context, "addNewClub")!,
                          textScaleFactor: 1,
                        ),
                        onPressed: () async {
                          print("Add new club");
                          var response = await ClubService.newClub(NewClubModel(
                              clubName: nameController.text,
                              description: descriptionController.text,
                              idAdmin: idController,
                              categories: categoriesController));
                          if (response == "200") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ClubList()));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(response.toString()),
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).backgroundColor,
                            onPrimary: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ])));
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget categoryItem(String id, String name, bool isSelected, int index) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).backgroundColor,
            )
          : const Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
      onTap: () {
        setState(() {
          categoryList[index].isSlected = !categoryList[index].isSlected;
          if (categoryList[index].isSlected == true) {
            selectedCategory.add(CategoryList(id, name, true));
          } else if (categoryList[index].isSlected == false) {
            selectedCategory
                .removeWhere((item) => item.name == categoryList[index].name);
          }
          categoriesController = "";
          for (int i = 0; i < selectedCategory.length; i++) {
            if (i == 0) {
              categoriesController = selectedCategory[i].name;
            } else {
              categoriesController =
                  categoriesController + "," + selectedCategory[i].name;
            }
          }
        });
      },
    );
  }
}
