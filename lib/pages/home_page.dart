import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'contacts_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  /// Check contacts permission
  @override
  void initState() {
    super.initState();
    _askPermissions(null);
  }

  Future<void> _askPermissions(String? routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != null) {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar =
          SnackBar(content: const Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Telegram",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return massages(index + 1);
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("asset/images/img.jpeg"),
              ),
              accountName: Text("Javlon Nurullayev"),
              accountEmail: Text("nurullayevjavlonbek@gmail.com"),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Создать группу"),
              selected: true,
              trailing: Icon(Icons.done),
            ),
            ListTile(
              onTap: () {
                _askPermissions(ContactsPage.id);
                //Navigator.pushNamed(context, ContactsPage.id);
              },
              leading: const Icon(Icons.contacts),
              title: const Text("Контакты"),
            ),
            ListTile(
                leading: Icon(Icons.call_outlined), title: Text("Звонки")),
            ListTile(
                leading: Icon(Icons.accessibility), title: Text("Люди рядом")),
            ListTile(
                leading: Icon(Icons.bookmark_border), title: Text("Избранное")),
            ListTile(
                leading: Icon(Icons.settings), title: Text("Настройки")),
            ListTile(
                leading: Icon(Icons.person_add_alt_1_outlined),
                title: Text("Пригласить друзей")),
            ListTile(
                leading: Icon(Icons.announcement_outlined),
                title: Text("Возможности Telegram")),

          ],
        ),
      ),
    );
  }
}

Container massages(int n) {
  List username = [
    " ",
    "Joe",
    "Laurent",
    "Mark",
    "Williams",
    "Claire",
    "Tracy"
  ];
  List clock = [" ", "20:18", "19:22", "14:34", "11:05", "09:45", "08:15"];
  List status = [
    " ",
    "How about meeting tomorrow?",
    "I love that idea,it's great!",
    "I wasn't aware of that. Let me check",
    "Flutter just release 1.0 officially. Should I go for it?",
    "It totally makes sense to get some extra day-of.",
    "It has been re-scheduled to next Saturday 7.30pm"
  ];

  return Container(
    padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
    child: Row(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("asset/images/img_$n.png"))),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${username[n]}    ${clock[n]}",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 220, child: Text("${status[n]}")),
          ],
        ),
        const Spacer(),
        const Icon(Icons.keyboard_arrow_right_outlined),
      ],
    ),
  );
}
