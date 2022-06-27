import 'package:date_time_picker/date_time_picker.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../localization/language_constants.dart';
import '../../models/book.dart';
import '../../models/category.dart';
import '../../routes/management_service.dart';
import 'event_list.dart';

class NewBook extends StatefulWidget {
  final String? elementId;
  const NewBook({Key? key, this.elementId}) : super(key: key);

  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final titleController = TextEditingController();
  final ISBNController = TextEditingController();
  final photoURLController = TextEditingController();
  final descriptionController = TextEditingController();
  final editorialController = TextEditingController();
  String publishedDateController = "";
  String categoriesController = "";
  List<CategoryList> selectedCategory = List.empty(growable: true);
  List<CategoryList> categoryList = [];
  List<Category> _response = List.empty(growable: true);
  bool _isLoading = true;
  late String _locale;
  bool _isEditing = true;
  void initState() {
    super.initState();
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    getBook();
    getCategories();
  }

  Future<void> getBook() async {
    if (widget.elementId != null) {
      var book = await BookService.getBook(widget.elementId!);
      titleController.text = book.title;
      ISBNController.text = book.ISBN;
      photoURLController.text = book.photoURL;
      descriptionController.text = book.description;
      editorialController.text = book.editorial;
      publishedDateController = book.publishedDate.toString();
    } else {
      _isEditing = false;
    }
  }

  Future<void> getCategories() async {
    _response = await ManagementService.getCategories();
    setState(() {
      for (int i = 0; i < _response.length; i++) {
        if (_locale == "en") {
          CategoryList category1 = new CategoryList(
              _response[i].id.toString(), _response[i].en.toString(), false);
          categoryList.add(category1);
        } else if (_locale == "ca") {
          CategoryList category1 = new CategoryList(
              _response[i].id.toString(), _response[i].ca.toString(), false);
          categoryList.add(category1);
        } else {
          CategoryList category1 = new CategoryList(
              _response[i].id.toString(), _response[i].es.toString(), false);
          categoryList.add(category1);
        }
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (_isEditing)
              ? Text(getTranslated(context, 'editBook')!)
              : Text(getTranslated(context, "newBook")!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.network(
                  "https://static.vecteezy.com/system/resources/previews/001/200/107/original/book-png.png",
                  height: 150),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "title")!,
                        hintText: getTranslated(context, "writeTheTitle"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: ISBNController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "ISBN"),
                        hintText: getTranslated(context, "writeTheISBN"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: photoURLController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "photoURL"),
                        hintText: getTranslated(context, "writeThePhotoURL"),
                        border: const OutlineInputBorder()),
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
                        labelText: getTranslated(context, "description"),
                        hintText: getTranslated(context, "writeTheDescription"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'dd/MM/yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  icon: const Icon(Icons.event),
                  dateLabelText: getTranslated(context, "publishDate")!,
                  onSaved: (val) => publishedDateController = val!,
                  onChanged: (val) => publishedDateController = val,
                  onFieldSubmitted: (val) => publishedDateController = val,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: editorialController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "editorial"),
                        hintText: getTranslated(context, "writeTheEditorial"),
                        border: const OutlineInputBorder()),
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
                              itemBuilder: (BuildContext context, int index) {
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
                child: (_isEditing)
                    ? Text(getTranslated(context, 'edit')!)
                    : Text(
                        getTranslated(context, "addNewBook")!,
                        textScaleFactor: 1,
                      ),
                onPressed: () async {
                  var idAuthor =
                      await LocalStorage('BookHub').getItem('idAuthor');
                  var response;
                  if (_isEditing) {
                    response = await BookService.editBook(
                      widget.elementId!,
                      titleController.text,
                      selectedCategory,
                      ISBNController.text,
                      photoURLController.text,
                      DateTime.parse(publishedDateController).toString(),
                      descriptionController.text,
                      editorialController.text,
                      idAuthor,
                    );
                  } else {
                    response = await BookService.newBook(
                      titleController.text,
                      selectedCategory,
                      ISBNController.text,
                      photoURLController.text,
                      DateTime.parse(publishedDateController).toString(),
                      descriptionController.text,
                      editorialController.text,
                      idAuthor,
                    );
                  }
                  if (response == "200") {
                    Navigator.of(context).pop();
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
                height: 20,
              ),
            ],
          ),
        ));
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
