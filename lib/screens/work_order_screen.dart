import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/managers/firestore_services.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class WorkOrderScreen extends StatelessWidget {
  const WorkOrderScreen({
    super.key,
    required this.workOrder,
  });

  final WorkOrder workOrder;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                collapsedHeight: 125.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.blue,
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  title: Text(
                    workOrder.title!,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.loaderOverlay.show();

                      FireStoreServices.deleteWorkOrder(workOrder.id!).then(
                        (value) {
                          Navigator.pop(context);

                          FirebaseAnalytics.instance.logEvent(
                            name: 'work_order_deleted',
                            parameters: {
                              'work_order_id': workOrder.id,
                              'work_order_title': workOrder.title,
                            },
                          );

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
                      padding: const EdgeInsets.all(10.0),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'On ${DateFormat.yMMMMd().format(
                                    workOrder.timestamp!.toDate(),
                                  )}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'At ${workOrder.location}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Priority Level ${workOrder.priority}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            workOrder.description!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          const SizedBox(height: 15),
                          (workOrder.image != null && workOrder.image != '')
                              ? ClipRRect(
                                  child: CachedNetworkImage(
                                      imageUrl: workOrder.image!),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
