import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/providers/dailyByData.dart';
import '/utilities/styles.dart';
import '/widgets/customContainer.dart';
import '/assets/colors/palette.dart';

class ComparePage extends StatefulWidget {
  ComparePage({super.key, required this.title, required this.items});
  final String title;
  final Price items;
  @override
  State<ComparePage> createState() => _Compare();
}

class _Compare extends State<ComparePage> {
  String inputText = '0';
  late String theDay =
      widget.items.dpr1 == "[]" ? widget.items.dpr1 = '0' : widget.items.dpr1;
  late String dayAgo =
      widget.items.dpr2 == "[]" ? widget.items.dpr2 = '0' : widget.items.dpr2;
  late String monthAgo =
      widget.items.dpr3 == "[]" ? widget.items.dpr3 = '0' : widget.items.dpr3;
  late String yearAgo =
      widget.items.dpr4 == "[]" ? widget.items.dpr4 = '0' : widget.items.dpr4;
  late int dayPrice = int.parse('${theDay.replaceAll(",", "")}');
  late int result = dayPrice - int.parse(inputText.replaceAll('"', ''));

  @override
  Widget build(BuildContext context) {
    // String inputText = '0';
    late int dayPrice = int.parse('${theDay.replaceAll(",", "")}');
    late int dayAgoPrice = int.parse('${dayAgo.replaceAll(",", "")}');
    late int monthAgoPrice = int.parse('${monthAgo.replaceAll(",", "")}');
    late int yearAgoPrice = int.parse('${yearAgo.replaceAll(",", "")}');
    late int result = dayPrice - int.parse(inputText.replaceAll('"', ''));
    List<_SalesData> data = [
      _SalesData('1년 전', yearAgoPrice),
      _SalesData('한달 전', monthAgoPrice),
      _SalesData('하루 전', dayAgoPrice),
      _SalesData('당일', dayPrice)
    ];
    List<int> numbers = [dayPrice, dayAgoPrice, monthAgoPrice, yearAgoPrice];
    numbers.sort();
    double max = double.parse(numbers[3].toString());
    double min = double.parse(numbers[0].toString());

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Palette.normalTextColor),
            backgroundColor: Palette.screensColor,
            centerTitle: false,
            elevation: 0,
            actions: [],
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.items.itemName,
                    style: Styles.itemNameText,
                  ),
                  Text(
                    widget.items.unit,
                    style: Styles.unitText,
                  )
                ],
              ),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  //chartBox
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            color: Palette.containerColor,
                            borderRadius: BorderRadius.circular(5.0),
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0,
                                  color: Palette.shadowColor,
                                  offset: Offset(0, 5))
                            ]),
                        child: Column(children: [
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Container(
                            decoration: BoxDecoration(
                              color: Palette.containerColor,
                              borderRadius: BorderRadius.circular(5.0),
                              shape: BoxShape.rectangle,
                            ),
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(
                                    minimum: min - min / 3,
                                    maximum: max + max / 3),
                                //MARK: CHART TITLE
                                title: ChartTitle(
                                    text: '1년간 금액 변화',
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        color: Palette.elementColor,
                                        fontWeight: FontWeight.bold)),
                                //MARK: LEGEND IS VISIBLE ? FALSE
                                legend: Legend(isVisible: false),
                                //MARK: TOOL TIP IS ENABLE ? TRUE
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<_SalesData, String>>[
                                  LineSeries<_SalesData, String>(
                                      color: Palette.highLightColor,
                                      width: 3.0,
                                      markerSettings: MarkerSettings(
                                          isVisible: true,
                                          width: 5.0,
                                          height: 5.0,
                                          shape: DataMarkerType.circle,
                                          borderWidth: 5.0),
                                      dataSource: data,
                                      xValueMapper: (_SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (_SalesData sales, _) =>
                                          sales.sales,
                                      name: 'Sales',
                                      //MARK: DATA LABEL IS VISIBLE ? TRUE
                                      dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                              color: Palette.elementColor,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500))),
                                ]),
                          )
                        ]))
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
                            child: Text(
                              "금일 가격 : ${theDay}원",
                              style: TextStyle(
                                  color: Palette.elementColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            color: Palette.screensColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 0,
                                color: Palette.screensColor,
                                offset: Offset(0, 5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: AlignmentDirectional(0, 0),
                          child: TextField(
                            onSubmitted: (text) {
                              setState(() {
                                inputText = text;
                              });
                            },
                            cursorColor: Palette.highLightColor,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Palette.elementColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                labelText: '비교할 금액을 입력하세요',
                                labelStyle:
                                    TextStyle(color: Palette.elementColor),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Palette.elementColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Palette.highLightColor)),
                                filled: true,
                                fillColor: Palette.screensColor),
                            keyboardType: Platform.isIOS
                                ? TextInputType.numberWithOptions(
                                    signed: true, decimal: true)
                                : TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.1,
                        alignment: AlignmentDirectional(-1, 0),
                        decoration: BoxDecoration(
                            color: Palette.containerColor,
                            borderRadius: BorderRadius.circular(5.0),
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0,
                                  color: Palette.shadowColor,
                                  offset: Offset(0, 5))
                            ]),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "입력 가격 : ${inputText}원",
                                style: Styles.dprText,
                              ),
                              Text(
                                "차액 : ${-(result)}원",
                                style: Styles.dprText,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (-(result) == -dayPrice)
                      ItemBox()
                    else if (result > 0)
                      TakeBuyBox()
                    else
                      DontBuyBox()
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}
