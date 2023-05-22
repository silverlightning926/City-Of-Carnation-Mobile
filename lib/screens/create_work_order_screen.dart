import 'dart:io';

import 'package:city_of_carnation/managers/firestore_manager.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

class CreateWorkOrderScreen extends StatefulWidget {
  const CreateWorkOrderScreen({super.key});

  @override
  State<CreateWorkOrderScreen> createState() => _CreateWorkOrderScreenState();
}

class _CreateWorkOrderScreenState extends State<CreateWorkOrderScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

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
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
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
              TextField(
                maxLines: 5,
                controller: _descriptionController,
                decoration: const InputDecoration(
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
                  color: _pickedImage == null
                      ? Colors.white.withOpacity(0.175)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  image: getPickedPhoto(),
                ),
                child: InkWell(
                  onTap: () {
                    _imagePicker
                        .pickImage(
                      source: ImageSource.gallery,
                    )
                        .then((value) {
                      setState(() {
                        _pickedImage = value;
                      });
                    });
                  },
                  child: Center(
                    child: _pickedImage == null
                        ? const Icon(
                            Icons.add,
                            size: 40,
                          )
                        : const Icon(
                            Icons.refresh_rounded,
                            size: 40,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 35.0,
                              ),
                            ],
                          ),
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
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
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
                onPressed: () {
                  if (_pickedImage != null) {
                    FirebaseStorage.instance
                        .ref()
                        .child(
                          'user-storage/${FirebaseAuth.instance.currentUser!.uid}/work-orders/images/${sanitizeFilename(_pickedImage!.name)}',
                        )
                        .putFile(
                          File(_pickedImage!.path),
                        )
                        .snapshot
                        .ref
                        .getDownloadURL()
                        .then((value) {
                      final WorkOrder workOrder = WorkOrder(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        location: _locationController.text,
                        timestamp: Timestamp.now(),
                        priority: list.indexOf(dropdownValue) + 1,
                        image: value,
                        status: 'Created',
                        isCompleted: false,
                      );

                      FireStoreManager.createWorkOrder(
                          FirebaseAuth.instance.currentUser!.uid, workOrder);
                    }).then(
                      (value) => Navigator.pop(context),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DecorationImage? getPickedPhoto() {
    if (_pickedImage != null) {
      return DecorationImage(
        fit: BoxFit.cover,
        image: FileImage(
          File(_pickedImage!.path),
        ),
      );
    }
    return null;
  }
}
