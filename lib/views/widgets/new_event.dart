import 'dart:developer';
import 'dart:html';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:ea_frontend/models/location.dart';
import 'package:ea_frontend/models/newevent.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/routes/management_service.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../localization/language_constants.dart';
import '../../models/event.dart';
import '../../models/user.dart';
import '../../routes/user_service.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String eventDateController = "";
  String idController = "";
  String categoryController = "";
  String categoriesController = "";
  List<CategoryList> selectedCategory = List.empty(growable: true);
  List<CategoryList> categoryList = [];
  List<Category> _response = List.empty(growable: true);
  bool _isLoading = true;
  double latitudeController = 40.410931;
  double longitudeController = -3.699313;
  List<Marker> markers = [];
  late String _locale;

  void initState() {
    super.initState();
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    getCategories();
    fetchUser();
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

  Future<Event> fetchEvent() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idController = LocalStorage('BookHub').getItem('userId');
    return EventService.getEvent('62695d51c0d07f7296b9c2f2');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return FutureBuilder(
        future: fetchEvent(),
        builder: (context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            var _mapController;
            return Scaffold(
                appBar: AppBar(
                  title: Text(getTranslated(context, "newEvent")!,
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
                          "https://img.icons8.com/ios7/12x/calendar--v3.png",
                          height: 200),
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
                                    getTranslated(context, "writeTheNameEvent"),
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
                        height: 10,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'dd/MM/yyyy',
                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2030),
                          icon: const Icon(Icons.event),
                          dateLabelText: getTranslated(context, "eventDate")!,
                          onSaved: (val) => eventDateController = val!,
                          onChanged: (val) => eventDateController = val,
                          onFieldSubmitted: (val) => eventDateController = val,
                        ),
                      ),
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
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getTranslated(context, 'mapIndication')!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: screenSize.height / 2,
                        width: screenSize.width / 1.5,
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: LatLng(snapshot.data!.location.latitude,
                                snapshot.data!.location.longitude),
                            zoom: 15.0,
                            onTap: (TapPosition, LatLng) {
                              print(LatLng);
                              latitudeController = LatLng.latitude;
                              longitudeController = LatLng.longitude;
                              setState(() {});
                            },
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  width: 150.0,
                                  height: 150.0,
                                  point: LatLng(
                                      latitudeController, longitudeController),
                                  builder: (ctx) => const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 35.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text(
                          getTranslated(context, "addNewEvent")!,
                          textScaleFactor: 1,
                        ),
                        onPressed: () async {
                          print("Add new event ");
                          Location newLoc = Location(
                              latitude: latitudeController,
                              longitude: longitudeController);
                          var response = await EventService.newEvent(
                              NewEventModel(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  admin: idController,
                                  eventDate:
                                      DateTime.parse(eventDateController),
                                  categories: categoriesController,
                                  location: newLoc));
                          if (response == "201") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EventList()));
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
