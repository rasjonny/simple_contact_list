import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
      title: 'Home page',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
      routes: {'/newContact': (context) => const NewContactView()}));
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook.sharedInstance() : super([]);
  static final _shared = ContactBook.sharedInstance();
  factory ContactBook() => _shared;
  void addContact(Contact contact) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void removeContact(Contact contact) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
    return;
  }

  int get contact => value.length;

  Contact? fetchContact(int index) =>
      value.length > index ? value[index] : null;
}

class Contact {
  final String name;
  final String id;

  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: ( context,  value,  child) {
          final contacts = value;
          return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                );
              });
        },
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/newContact');
          },
          icon: const Icon(Icons.add)),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Contact"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'enter your contact'),
            controller: controller,
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: TextButton(
                onPressed: (() {
                  final contactName = controller.text;
                  final contact = Contact(name: contactName);
                  final contactList = ContactBook();
                  contactList.addContact(contact);
                  Navigator.of(context).pop();
                }),
                child: const Text('Add Contact')),
          ),
        ],
      ),
    );
  }
}
