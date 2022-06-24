import 'package:ea_frontend/models/club.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/models/editclub.dart';
import 'package:ea_frontend/models/newchat.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/routes/club_service.dart';
import 'package:ea_frontend/routes/management_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../localization/language_constants.dart';
import '../../models/newclub.dart';

class NewClub extends StatefulWidget {
  String? clubId;
  NewClub({
    Key? key,
    required this.clubId,
    }) : super(key: key);

  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String idController = "";
  var storage = LocalStorage('BookHub');
  late Club club;
  String categoriesController = "";
  List<CategoryList> selectedCategory = List.empty(growable: true);
  List<CategoryList> categoryList = [];
  List<Category> _response = List.empty(growable: true);
  bool _isLoading = true;
  List<String> usersController = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getCategories();
    fetchUser();
    if(widget.clubId != null) {
      fetchClub();
    }
  }

  void fetchUser() async {
    await storage.ready;

    idController = LocalStorage('BookHub').getItem('userId');
  }

  void fetchClub() async {
    club = await ClubService.getClub(widget.clubId!);
    nameController.text = club.name;
    descriptionController.text = club.description;
    for (int i = 0; i < categoryList.length; i++) {
      for (var clubCategory in club.category) {
        if (categoryList[i].id == clubCategory.id) {
          setState(() {
            categoryList[i].isSlected = true;
            selectedCategory.add(CategoryList(categoryList[i].id, categoryList[i].name, true));
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
        }
      }
    }
  }

  Future<void> getCategories() async {
    _response = await ManagementService.getCategories();
    setState(() {
      for (int i = 0; i < _response.length; i++) {
        CategoryList category1 = CategoryList(
            _response[i].id.toString(), _response[i].name.toString(), false);
        categoryList.add(category1);
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.clubId == null 
            ? getTranslated(context, "newClub")!
            : getTranslated(context, "editClub")!,
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column (
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
                cursorColor: Colors.black,
                validator: (value) {
                  if (value!.isEmpty) {
                    return getTranslated(context, "fieldRequired");
                  }
                  return null;
                },
                style: const TextStyle(
                    fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                    labelText: getTranslated(context, "name"),
                    hintText:
                        getTranslated(context, "writeTheNameClub"),
                    border: const OutlineInputBorder()),
              )
            ),
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
                cursorColor: Colors.black,
                validator: (value) {
                  if (value!.isEmpty) {
                    return getTranslated(context, "fieldRequired");
                  }
                  return null;
                },
                style: const TextStyle(
                    fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  labelText:
                      getTranslated(context, "description"),
                  hintText: getTranslated(
                      context, "writeTheDescription"),
                  border: const OutlineInputBorder()
                ),
              )
            ),
            const SizedBox(
              height: 10,
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
                widget.clubId == null 
                  ? getTranslated(context, "addNewClub")!
                  : getTranslated(context, "submitEditClub")!,
                textScaleFactor: 1,
              ),
              onPressed: () async {
                var response;
                if(widget.clubId == null) {
                  response = await ClubService.newClub(NewClubModel(
                    clubName: nameController.text,
                    description: descriptionController.text,
                    idAdmin: idController,
                    categories: categoriesController
                  ));
                }
                else {
                  response = await ClubService.editClub(widget.clubId!, EditClubModel(
                    clubName: nameController.text,
                    description: descriptionController.text,
                    category: categoriesController
                  ));
                }
                if (response == "200" || response == "201") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScaffold()));
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
                usersController.add(idController);
                var response2 = await ChatService.newChat(
                    NewChatModel(
                        name: nameController.text,
                        userIds: usersController));
                if (response2 == "201") {
                  print("Add new chat");
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 30,
            ),
          ]
        )
      )
    );
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