import 'dart:developer';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ea_frontend/models/editevent.dart';
import 'package:ea_frontend/models/location.dart';
import 'package:ea_frontend/models/newchat.dart';
import 'package:ea_frontend/models/newevent.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/routes/management_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../localization/language_constants.dart';
import '../../models/cloudinary.dart';
import '../../models/event.dart';
import '../../models/user.dart';
import '../../routes/user_service.dart';

class NewEvent extends StatefulWidget {
  String? eventId;
  NewEvent({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String eventDateController = DateTime.now().toString();
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

  List<String> usersController = List.empty(growable: true);

  late Event event;
  var dateTimeController = TextEditingController();
  bool isLoading = true;
  var _mapController = MapController();
  String profilePhoto =
      "https://res.cloudinary.com/tonilovers-inc/image/upload/v1656077605/images_xdx4t4.jpg";

  @override
  void initState() {
    super.initState();
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    getCategories();
    fetchUser();
    if (widget.eventId == null) {
      _determinePosition();
    } else {
      fetchEvent();
    }
    isLoading = false;
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

  void fetchEvent() async {
    event = await EventService.getEvent(widget.eventId!);
    nameController.text = event.name;
    descriptionController.text = event.description;
    for (int i = 0; i < categoryList.length; i++) {
      for (var eventCategory in event.category) {
        if (categoryList[i].id == eventCategory.id) {
          setState(() {
            categoryList[i].isSlected = true;
            selectedCategory.add(
                CategoryList(categoryList[i].id, categoryList[i].name, true));
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
    setState(() {
      dateTimeController.text = event.eventDate.toString();
      eventDateController = event.eventDate.toString();
      profilePhoto = event.photoURL;
      _mapController.move(
          LatLng(event.location.latitude, event.location.longitude), 13);
      latitudeController = event.location.latitude;
      longitudeController = event.location.longitude;
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    latitudeController = position.latitude;
    longitudeController = position.longitude;
    _mapController.move(LatLng(position.latitude, position.longitude), 13);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return Scaffold(
        appBar: AppBar(
          title: widget.eventId == null
              ? Text(getTranslated(context, "newEvent")!,
                  style: const TextStyle(fontWeight: FontWeight.bold))
              : Text(getTranslated(context, "editEvent")!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).shadowColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      profilePhoto,
                                    ))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).shadowColor,
                                ),
                                color: Colors.green,
                              ),
                              child: InkWell(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onTap: () async {
                                    print("change photo");

                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          'png',
                                          'jpg',
                                          'webp',
                                        ]);
                                    if (result == null) {
                                      return;
                                    }

                                    PlatformFile file = result.files.first;

                                    final res = await MyCloudinary()
                                        .cloudinary
                                        .uploadResource(
                                            CloudinaryUploadResource(
                                          filePath: file.path,
                                          fileBytes: file.bytes,
                                          resourceType:
                                              CloudinaryResourceType.image,
                                        ));

                                    if (res.isSuccessful) {
                                      log("Uploaded: ${res.secureUrl}");
                                      setState(() {
                                        profilePhoto = res.secureUrl!;
                                      });
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
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
                              hintText:
                                  getTranslated(context, "writeTheDescription"),
                              border: const OutlineInputBorder()),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: DateTimePicker(
                        controller: dateTimeController,
                        type: DateTimePickerType.date,
                        dateMask: 'dd/MM/yyyy',
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
                          center:
                              LatLng(latitudeController, longitudeController),
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
                      child: widget.eventId == null
                          ? Text(
                              getTranslated(context, "addNewEvent")!,
                              textScaleFactor: 1,
                            )
                          : Text(
                              getTranslated(context, "submitEditEvent")!,
                              textScaleFactor: 1,
                            ),
                      onPressed: () async {
                        Location newLoc = Location(
                            latitude: latitudeController,
                            longitude: longitudeController);
                        var response;
                        if (widget.eventId == null) {
                          response = await EventService.newEvent(NewEventModel(
                              name: nameController.text,
                              description: descriptionController.text,
                              admin: idController,
                              photoURL: profilePhoto,
                              eventDate: DateTime.parse(eventDateController),
                              categories: categoriesController,
                              location: newLoc));
                        } else {
                          response = await EventService.editEvent(
                              widget.eventId!,
                              EditEventModel(
                                  eventName: nameController.text,
                                  description: descriptionController.text,
                                  eventDate:
                                      DateTime.parse(eventDateController),
                                  category: categoriesController,
                                  photoURL: profilePhoto,
                                  location: newLoc));
                        }
                        if (response == "200") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScaffold()));
                        } else if (response == "201") {
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
                  ])));
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
