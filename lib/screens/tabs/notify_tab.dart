import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/components/work_order_card.dart';
import 'package:city_of_carnation/screens/create_work_order_screen.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class NotifyTab extends StatelessWidget {
  const NotifyTab({
    super.key,
    required this.workOrderStream,
  });

  final Stream<QuerySnapshot<Map<String, dynamic>>> workOrderStream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Notify',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(10),
                  child: DottedBorder(
                    color: Colors.white.withOpacity(0.5),
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    dashPattern: const [5, 6],
                    radius: const Radius.circular(10),
                    child: Ink(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.175),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateWorkOrderScreen(),
                              settings: const RouteSettings(
                                name: 'CreateWorkOrderScreen',
                              ),
                            ),
                          );
                        },
                        child: const Center(
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Open',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 15),
                StreamBuilder(
                  stream: workOrderStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final List<WorkOrder> workOrders = snapshot.data!.docs
                        .map(
                            (e) => WorkOrder.fromJson(id: e.id, json: e.data()))
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final workOrder in workOrders
                            .where((element) => element.isCompleted == false))
                          WorkOrderCard(workOrder: workOrder),
                        const SizedBox(height: 15),
                        Text(
                          'Completed',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 15),
                        for (final workOrder in workOrders
                            .where((element) => element.isCompleted == true))
                          WorkOrderCard(workOrder: workOrder),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
