import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/extensions.dart';

class TaskReport extends StatelessWidget {
  const TaskReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Task Report',
            style: TextStyle(
              color: white,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 4.0.wp,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Total Task : 0",
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.0.wp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1.5,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "In Progress : 0",
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.0.wp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.5,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Completed : 0",
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: white,
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      radius: 12.0.wp,
                      lineWidth: 5.0,
                      percent: 1.0,
                      center: const Text(
                        "100%",
                        style: TextStyle(color: white),
                      ),
                      progressColor: const Color(0xFF7fff00),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
