import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/screens/work_order_screen.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:flutter/material.dart';

class WorkOrderCard extends StatelessWidget {
  const WorkOrderCard({
    Key? key,
    required this.workOrder,
  }) : super(key: key);

  final WorkOrder workOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: workOrder.image != null && workOrder.image!.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(
                      workOrder.image!,
                    ),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(188, 0, 0, 0),
                      BlendMode.darken,
                    ),
                  )
                : null,
            color: workOrder.image!.isEmpty
                ? Colors.white.withOpacity(0.175)
                : null,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkOrderScreen(
                    workOrder: workOrder,
                  ),
                  settings: const RouteSettings(
                    name: 'WorkOrderScreen',
                  ),
                ),
              );

              AnalyticsService.workOrderCardClicked(
                id: workOrder.id ?? 'No ID',
                title: workOrder.title ?? 'No Title',
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  workOrder.title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  workOrder.status!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
