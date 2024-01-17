import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retro/constant/gradient.dart';
import 'package:retro/controller/tapcontroller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialIndicatorSoil extends StatelessWidget {
  final String? value;
  final int index;
  const RadialIndicatorSoil({
    super.key,
    this.value,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    double screenWeight = MediaQuery.of(context).size.width;
    GetxTapController controller = Get.put(GetxTapController());
    return Obx(() => controller.isDataLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Text(
            value == null
                ? 'N/A'
                : index == 0
                    ? '$value%'
                    : index == 1
                        ? '$value°C'
                        : value!,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: screenWeight / 10),
          )));
    // SfRadialGauge(
    //     enableLoadingAnimation: true,
    //     axes: <RadialAxis>[
    //       RadialAxis(
    //         maximum: index == 2 ? 14 : 100,
    //         canScaleToFit: true,
    //         annotations: [
    //           GaugeAnnotation(
    //               widget: Text(
    //             value == null
    //                 ? 'N/A'
    //                 : index == 0
    //                     ? '$value%'
    //                     : index == 1
    //                         ? '$value°C'
    //                         : value!,
    //             style: const TextStyle(
    //                 fontWeight: FontWeight.bold, fontSize: 26),
    //           ))
    //         ],

    //         showLabels: true,
    //         showTicks: true,
    //         // useRangeColorForAxis: true,
    //         // ranges: [GaugeRange(startValue: double.parse(value), endValue: 100)],
    //         pointers: <GaugePointer>[
    //           RangePointer(
    //               enableAnimation: true,
    //               animationType: AnimationType.bounceOut,
    //               value: value == null ? 0.0 : double.parse(value!),
    //               width: 0.1,
    //               sizeUnit: GaugeSizeUnit.factor,
    //               cornerStyle: CornerStyle.startCurve,
    //               gradient: index == 2
    //                   ? getPhLevelGradient(double.parse(value!))
    //                   : SweepGradient(colors: <Color>[
    //                       int.parse(value!) > 70
    //                           ? const Color(0xFFa4edeb)
    //                           : int.parse(value!) > 50
    //                               ? const Color.fromARGB(
    //                                   255, 237, 210, 164)
    //                               : const Color.fromARGB(
    //                                   255, 237, 171, 164),
    //                       const Color(0xFF00a9b5),
    //                     ], stops: const <double>[
    //                       0.25,
    //                       0.75
    //                     ])),
    //           MarkerPointer(
    //             value: value == null ? 0.0 : double.parse(value!),
    //             markerType: MarkerType.circle,
    //             color: const Color.fromARGB(129, 135, 232, 232),
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
  }
}
