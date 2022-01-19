import 'package:walltex_app/Helpers/querie.dart';

class TaskTypeModel {
  int? taskid;
  int? tasktype; // id of tasktype from task table
  int? leadid; // id of corres. lead
  int? seqno; // sequence of each task type of a perti lead
  int? allotto; // id of user
  String? allotdt; // date of allotement of tasktype
  int? started; // is tasktype started -> bit bool
  String? complby; // date task type should be compleated
  int? completed; // is tasktype compleated -> bit bool
  String? complon; // date of task type completed
  String? remark;

  TaskTypeModel({
    this.allotdt,
    this.allotto,
    this.complby,
    this.completed,
    this.complon,
    this.leadid,
    this.seqno,
    this.started,
    this.taskid,
    this.tasktype,
    this.remark,
  });

  static Future<int> nextSequenceNumber(int id) async {
    List<dynamic> result = await Query.execute(query: """
    select count(*) from tasks where leadid = $id
    """);
    return result[0]['Column1'] + 1;
  }

  static Future<String> markNextTaskStart(
      int? leadId, int? taskId, int? taskSeq) async {
    List<dynamic> result = await Query.execute(query: """
      select * from tasks where leadid = $leadId and seqno > $taskSeq
      """, toPrint: true);
    if (result.isNotEmpty) {
      int idOfNextTAsk = result.first['taskid'];
      dynamic startedResult = await Query.execute(
          p1: '1',
          query: """
                  update tasks set started = 1 where  
                  leadid = $leadId and taskid = $idOfNextTAsk
                """,
          toPrint: true);
      if (startedResult['status'] == "success") {
        return "Next Task Marked As Started";
      } else {
        return "Error In Marking Next Task As Started";
      }
    } else {
      return "All Task In This Lead Are Completed";
    }
  }

  save() async {
    try {
      dynamic result = await Query.execute(p1: '1', query: """
      insert into tasks(tasktype,leadid,seqno,allotto,allotdt,started,completed,complon,rem,complby)
      values(${tasktype},${leadid},${seqno},${allotto},'${allotdt}',${started},
      ${completed},'${complon}','${remark}','${complby}')
      """);
      print(result);
      if (result['status'] == "success") {
        return true;
      } else {
        throw "Error";
      }
    } catch (e) {
      return false;
    }
  }

  update() async {
    try {
      dynamic result = await Query.execute(p1: '1', query: """
        update tasks set
        tasktype = ${tasktype},leadid = ${leadid},seqno = ${seqno},allotto = ${allotto},
        allotdt = '${allotdt}',started = ${started},
        completed = ${completed},complon = '${complon}', rem = '${remark}',complby = '${complby}'
        where leadid = ${leadid} and seqno = ${seqno}
        """);
      if (result['status'] == "success") {
        return true;
      } else {
        throw "Error";
      }
    } catch (e) {
      return false;
    }
  }
}
