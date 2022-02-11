import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  static String id = "contacts_page";

  const ContactsPage({Key? key}) : super(key: key);


  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [], moreLoadingList = [];
  int _currentMax = 10;
  ScrollController _scrollController = ScrollController();
  var textForSearch = "";
  //List<Color> colors = Colors.accents;

  Future<void> _makeCall(String number) async {
    await launch("tel:$number");
  }


  bool isGranted = false;

  Future<bool> getPermissionContacts() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted && !status.isPermanentlyDenied) {
      status = await Permission.contacts.request();
    }
    if (status.isGranted) {isGranted = true;}
    return isGranted;
  }

  @override
  void initState() {
    // getPermissionContacts().then((value) {
    //   if(value) {
    //     getContacts();
    //   }
    // });
    getContacts();
    super.initState();
  }

  _getMoreDataAndSearch() {
    /// #Search function
    if (textForSearch.isNotEmpty) {
      moreLoadingList = _contacts.where((element) {
        String phone = "", phoneInput = "";
        RegExp(r'\+?\w+').allMatches(element.phones!.first.value.toString()).forEach((e) {phone += e.group(0).toString();});
        RegExp(r'\+?\w+').allMatches(textForSearch).forEach((e) {phoneInput += e.group(0).toString();});

        return (element.displayName!.toLowerCase().toString().contains(textForSearch.toLowerCase())) ||
            (phone.contains(phoneInput));
      }).toList();
    } else {
      /// #Get More Data
      for (var i = _currentMax; i < _currentMax + 10; i++) {
        if (_contacts.length == i) {
          break;
        } else {
          moreLoadingList.add(_contacts[i]);
        }}
      if (moreLoadingList.length - _currentMax < 10) {
        _currentMax += _contacts.length;
      } else {
        _currentMax = _currentMax + 10;
      }
    }
    setState(() {});
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    List<Contact> contact = await ContactsService.getContacts();
    _contacts = contact.where((element) => element.phones!.isNotEmpty).toList();

    setState(() {
      moreLoadingList =
          List.generate(10, (index) => _contacts.elementAt(index));
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreDataAndSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                //floating: true,
                title: Text("Contacs"),
                centerTitle: true,
              ),
            ];
          },
          body: ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Search",
                    prefixIcon: Icon(
                        Icons.search_rounded,
                    color: Theme.of(context).primaryColor
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    )

                  ),
                  onChanged: (input) {
                    textForSearch = input;
                    _getMoreDataAndSearch();
                   // print(textForSearch);
                  },
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      moreLoadingList.length, (index) => horizontal(index)),
                ),
              ),

              //for(var i=0;i<_contacts.length;i++) vertical(i),

              ListView.builder(
                //itemExtent: 70,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _contacts.length > _currentMax ? moreLoadingList.length : moreLoadingList.length,
                itemBuilder: (context, index) {
                  // if(index==moreLoadingList.length) {
                  //   return CircularProgressIndicator();}
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                          moreLoadingList.elementAt(index).displayName![0]),
                    ),
                    title: Text(moreLoadingList.elementAt(index).displayName.toString()),
                    subtitle: Text(moreLoadingList.elementAt(index).phones!.first.value.toString()),
                    trailing: IconButton(
                      onPressed: () {
                        _makeCall(moreLoadingList.elementAt(index).phones!.first.value.toString());
                      },
                      icon: const Icon(Icons.phone),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget horizontal(int index) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(100, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // <-- Radius
          ),
        ),
        onPressed: () {
          _makeCall(
              moreLoadingList.elementAt(index).phones!.first.value.toString());
        },
        child: Text(moreLoadingList.elementAt(index).displayName.toString()),
      ),
    );
  }

  Widget vertical(int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(moreLoadingList.elementAt(index).initials()),
      ),
      title: Text(moreLoadingList.elementAt(index).displayName.toString()),
      subtitle:
          Text(moreLoadingList.elementAt(index).phones!.first.value.toString()),
      trailing: IconButton(
        onPressed: () {
          _makeCall(
              moreLoadingList.elementAt(index).phones!.first.value.toString());
        },
        icon: const Icon(Icons.phone),
      ),
    );
  }
}
