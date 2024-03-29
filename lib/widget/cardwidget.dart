// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retro/controller/tapcontroller.dart';
import 'package:retro/widget/radialindicator.dart';
import 'package:retro/widget/chartdata.dart';

class CardWidgetforSoil extends StatelessWidget {
  final String bgimagepath;
  final String title;
  final String iconpath;
  final String? value;
  final int index;
  const CardWidgetforSoil({
    super.key,
    required this.bgimagepath,
    required this.title,
    required this.iconpath,
    required this.index,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    GetxTapController controller = Get.put(GetxTapController());

    return GetBuilder<GetxTapController>(builder: (_) {
      return Card(
        elevation: 5,
        shadowColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lime[200],
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.04), BlendMode.dstATop),
              image: const AssetImage(
                "assets/images/dotted.jpg",
              ),
              // opacity: .2,
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.teal[100],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        title,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ))),
              Flexible(
                child: index == 3
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "N : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenwidth / 16),
                                  ),
                                  Text(
                                    controller.latestfeeddata == null
                                        ? ''
                                        : controller.latestfeeddata!.field4,
                                    style:
                                        TextStyle(fontSize: screenwidth / 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "P : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenwidth / 16),
                                  ),
                                  Text(
                                    controller.latestfeeddata == null
                                        ? ''
                                        : controller.latestfeeddata!.field5,
                                    style:
                                        TextStyle(fontSize: screenwidth / 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "K : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenwidth / 16),
                                  ),
                                  Text(
                                    controller.latestfeeddata == null
                                        ? ''
                                        : controller.latestfeeddata!.field6,
                                    style:
                                        TextStyle(fontSize: screenwidth / 16),
                                  ),
                                ],
                              ),

                              // RadialData(
                              //     nitro: controller.latestfeeddata == null
                              //         ? ''
                              //         : controller.latestfeeddata!.field4,
                              //     phos: controller.latestfeeddata == null
                              //         ? ''
                              //         : controller.latestfeeddata!.field5,
                              //     potas: controller.latestfeeddata == null
                              //         ? ''
                              //         : controller.latestfeeddata!.field6)
                            ],
                          ),
                        ),
                      )
                    : RadialIndicatorSoil(
                        value: value,
                        index: index,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 25, child: Image.asset(iconpath)),
                    Text(
                      "Show more . .",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          /* add child content here */
        ),
      );
    });
  }
}
