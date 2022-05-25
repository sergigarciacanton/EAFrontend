import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/models/event.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/views/club_page.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/models/club.dart';
import 'package:ea_frontend/localization/language_constants.dart';

import '../routes/club_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage storage = LocalStorage('BookHub');
  ScrollController _controller = new ScrollController();

  List<Book> _books = [];
  bool _isLoadingBook = true;
  List<Event> _events = [];
  bool _isLoadingEvent = true;
  List<Club> _clubs = [];
  bool _isLoadingClub = true;

  @override
  void initState() {
    super.initState();
    getBooks();
    getEvents();
    getClubs();
  }

  Future<void> getBooks() async {
    _books = await BookService.getBooks();
    setState(() {
      _isLoadingBook = false;
    });
  }

  Future<void> getEvents() async {
    _events = await EventService.getEvents();
    setState(() {
      _isLoadingEvent = false;
    });
  }

  Future<void> getClubs() async {
    _clubs = await ClubService.getClubs();
    setState(() {
      _isLoadingClub = false;
    });
  }

  String getStringCategories(List<dynamic> categories) {
    String output = "";
    for (var category in categories) {
      output = output + ", " + category.name;
    }
    return output.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(height: 50),
          Text(
            getTranslated(context, 'interestBook')!,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            height: 250,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: _isLoadingBook
                  ? Column(
                      children: const [
                        SizedBox(height: 10),
                        LinearProgressIndicator(),
                        SizedBox(height: 200),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        return BookCard(
                          title: _books[index].title,
                          author: _books[index].writer,
                          rate: _books[index].rate.toString(),
                          imageUrl: _books[index].photoURL,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            getTranslated(context, 'interestEvent')!,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            height: 250,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: _isLoadingEvent
                  ? Column(
                      children: const [
                        SizedBox(height: 10),
                        LinearProgressIndicator(),
                        SizedBox(height: 200),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: BookCard(
                            title: _events[index].name,
                            author: _events[index].eventDate.day.toString() + "-" + _events[index].eventDate.month.toString() + "-" + _events[index].eventDate.year.toString(),
                            rate: _events[index].usersList.length.toString(),
                            imageUrl: "",
                          ),
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => EventPage(
                                    elementId: _events[index].id));
                            Navigator.of(context).push(route);
                          },
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            getTranslated(context, 'interestClub')!,
            style: const TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            height: 250,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: _isLoadingClub
                  ? Column(
                      children: const [
                        SizedBox(height: 10),
                        LinearProgressIndicator(),
                        SizedBox(height: 200),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: _clubs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: BookCard(
                            title: _clubs[index].name,
                            author: getStringCategories(_clubs[index].category).toString(),
                            rate: _clubs[index].usersList.length.toString(),
                            imageUrl: "",
                          ),
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => ClubPage(
                                    elementId: _clubs[index].id));
                            Navigator.of(context).push(route);
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
