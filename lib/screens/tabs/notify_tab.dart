import 'package:city_of_carnation/screens/create_work_order_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class NotifyTab extends StatelessWidget {
  const NotifyTab({super.key});

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
                DottedBorder(
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
