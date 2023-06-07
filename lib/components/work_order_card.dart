import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_of_carnation/screens/work_order_screen.dart';
import 'package:city_of_carnation/serialized/work_order.dart';
import 'package:city_of_carnation/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkOrderCard extends StatelessWidget {
  const WorkOrderCard({
    Key? key,
    required this.workOrder,
  }) : super(key: key);

  final WorkOrder workOrder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AnalyticsService.logEvent(
          name: 'work_order_card_tapped',
          parameters: {
            'work_order_id': workOrder.id,
          },
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WorkOrderScreen(
              workOrder: workOrder,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.175),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: ShaderMask(
                  blendMode: BlendMode.dstATop,
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(1.0),
                        Colors.white.withOpacity(0.75),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: workOrder.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workOrder.title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat.yMMMMd().format(workOrder.timestamp!.toDate()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      workOrder.status!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
