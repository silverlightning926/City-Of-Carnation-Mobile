import 'dart:io';

import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/auth_service.dart';
import 'package:city_of_carnation/services/cloud_storage_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'New Work Order',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Enter A Title',
                style: Theme.of(context).textTheme.titleLarge),
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
              style: Theme.of(context).textTheme.titleLarge,
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
              style: Theme.of(context).textTheme.titleLarge,
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
              style: Theme.of(context).textTheme.titleLarge,
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
              style: Theme.of(context).textTheme.titleLarge,
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
                onChanged: (value) => setState(() {
                  dropdownValue = value.toString();
                }),
                value: dropdownValue,
                borderRadius: BorderRadius.circular(10),
                underline: const SizedBox(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                context.loaderOverlay.show();
                try {
                  await createWorkOrder();
                } catch (e) {
                  context.loaderOverlay.hide();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Something went wrong. Please try again.',
                      ),
                    ),
                  );
                }

                if (context.mounted) {
                  context.loaderOverlay.hide();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Work order created successfully.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createWorkOrder() async {
    bool hasImage = _pickedImage != null;
    late final String? downloadURL;

    if (hasImage) {
      downloadURL = await CloudStorageService.uploadWorkOrderPhoto(
        imageFile: File(_pickedImage!.path),
        name: _pickedImage!.name,
      );
    } else {
      downloadURL = null;
    }

    WorkOrder workOrder = WorkOrder(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      priority: list.indexOf(dropdownValue) + 1,
      image: downloadURL,
      status: 'Pending',
      timestamp: Timestamp.now(),
      isCompleted: false,
      creatorId: AuthService.userId,
    );

    FirestoreService.createWorkOrder(
      AuthService.userId!,
      workOrder,
    ).then((value) {
      AnalyticsService.workOrderCreated(
        title: workOrder.title ?? 'No title',
      );
    });
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
