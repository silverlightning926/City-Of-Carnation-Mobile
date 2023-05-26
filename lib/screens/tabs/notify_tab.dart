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
    required this.workOrders,
  });

  final List<WorkOrder> workOrders;
  final Stream<List<WorkOrder>> workOrderStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            'Notify',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            builder: (context) => const CreateWorkOrderScreen(),
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
              StreamBuilder(
                initialData: workOrders,
                stream: workOrderStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<WorkOrder> workOrders =
                      snapshot.data as List<WorkOrder>;

                  final List<WorkOrder> openWorkOrders = workOrders
                      .where((element) => !element.isCompleted!)
                      .toList();
                  final List<WorkOrder> closedWorkOrders = workOrders
                      .where((element) => element.isCompleted!)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Open',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 15),
                      if (openWorkOrders.isEmpty)
                        const Center(
                          child: Text(
                            'No open work orders',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        ...openWorkOrders.map(
                          (e) => WorkOrderCard(
                            workOrder: e,
                          ),
                        ),
                      const SizedBox(height: 15),
                      Text(
                        'Closed',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 15),
                      if (closedWorkOrders.isEmpty)
                        const Center(
                          child: Text(
                            'No closed work orders',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        ...closedWorkOrders.map(
                          (e) => WorkOrderCard(
                            workOrder: e,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
