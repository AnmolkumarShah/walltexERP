import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/task_type.dart';

class TaskTypeAllScreen extends StatefulWidget {
  int? leadId;
  TaskTypeAllScreen({Key? key, this.leadId}) : super(key: key);

  @override
  State<TaskTypeAllScreen> createState() => _TaskTypeAllScreenState();
}

class _TaskTypeAllScreenState extends State<TaskTypeAllScreen> {
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    setState(() {
      _loading = true;
    });
    List<dynamic> list = await Query.execute(
        query:
            "select * from tasks where leadid = ${widget.leadId} order by seqno");
    List<TaskTypeItem> taskItems =
        list.map((e) => TaskTypeItem(leadId: widget.leadId!, prev: e)).toList();
    setState(() {
      itemsToShow = taskItems;
      _loading = false;
    });
  }

  List<TaskTypeItem> itemsToShow = [];

  CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Type"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CarouselSlider(
                    carouselController: _controller,
                    items: itemsToShow.map((e) => e).toList(),
                    options: CarouselOptions(
                      height: 500,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                    )),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  List<TaskTypeItem> temp = [
                    ...itemsToShow,
                    TaskTypeItem(leadId: widget.leadId!),
                  ];
                  setState(() {
                    itemsToShow = temp;
                  });
                  _controller.jumpToPage(itemsToShow.length - 1);
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Task"),
              )
            ],
          ),
          _loading == true ? Loader.circular : const SizedBox(height: 0)
        ],
      ),
    );
  }
}
