import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:city_of_carnation/services/firestore_service.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class WorkOrderScreen extends StatelessWidget {
  const WorkOrderScreen({
    Key? key,
    required this.workOrder,
  }) : super(key: key);

  final WorkOrder workOrder;

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromARGB(255, 37, 7, 128),
          Color(0xFF030417),
          Color(0xFF03040c),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            title: Text(
              workOrder.title!,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.loaderOverlay.show();

                  FirestoreService.deleteWorkOrder(workOrder.id!).then(
                    (value) {
                      context.loaderOverlay.hide();
                      Navigator.pop(context);

                      AnalyticsService.logEvent(
                          name: 'work_order_deleted',
                          parameters: {
                            'work_order_id': workOrder.id,
                            'work_order_title': workOrder.title,
                          });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Work Order Deleted'),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.175),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${workOrder.status}',
                              style: Theme.of(context).textTheme.titleLarge!,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'On ${DateFormat.yMMMMd().format(
                                workOrder.timestamp!.toDate(),
                              )}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'At ${workOrder.location}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Priority Level ${workOrder.priority}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        DateFormat.yMMMM()
                            .format(workOrder.timestamp!.toDate()),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        workOrder.description!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      if (workOrder.image != null)
                        CachedNetworkImage(
                          imageUrl: workOrder.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      const SizedBox(height: 75),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
