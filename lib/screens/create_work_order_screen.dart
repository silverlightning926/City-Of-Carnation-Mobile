import 'package:flutter/material.dart';

class CreateWorkOrderScreen extends StatefulWidget {
  const CreateWorkOrderScreen({super.key});

  @override
  State<CreateWorkOrderScreen> createState() => _CreateWorkOrderScreenState();
}

class _CreateWorkOrderScreenState extends State<CreateWorkOrderScreen> {
  final List<String> list = <String>[
    'One (Lowest)',
    'Two',
    'Three',
    'Four',
    'Five (Highest)',
  ];

  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'New Work Order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Text(
                'Enter A Title',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter A Description',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Add Image',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Ink(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.175),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {},
                  child: const Center(
                    child: Icon(Icons.add),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter A Location',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter A Priority',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                child: DropdownButton(
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => dropdownValue = value.toString(),
                  value: dropdownValue,
                  borderRadius: BorderRadius.circular(10),
                  underline: const SizedBox(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
