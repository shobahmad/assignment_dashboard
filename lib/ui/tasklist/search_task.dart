import 'package:assignment_dashboard/bloc/task/searchtask_bloc.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/ui/tasklist/progress_chart.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchTask extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

  const SearchTask();
}

class TaskListWidgetState extends State<SearchTask> {
  SearchTaskBloc bloc;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";


  @override
  void initState() {
    super.initState();
    bloc = SearchTaskBloc();
  }

  @override
  Widget build(BuildContext context) {
     return StreamBuilder(
       stream: bloc.state,
        builder: (context, AsyncSnapshot<TaskListStream> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: _isSearching ? _buildSearchField() : Text('Search Task'),
              actions: _buildActions(),

            ),
            body: getBody(snapshot),
          );
        });
  }

  Widget getBody(AsyncSnapshot<TaskListStream> snapshot) {
    if (snapshot.data == null) {
      return Column(
        children: [
          Center(
            child: ListTile(
              leading: Icon(Icons.search, size: 128,),
              title: Text('\n\nFind task here'),
            ),
          )
        ],
      );
    }

    if (snapshot.data.state == null ||
        snapshot.data.state == TaskListState.loading) {
      return Center(
          child: SpinKitThreeBounce(
            color: Colors.blue,
            size: 18.0,
          ));
    }

    if (snapshot.data.state == TaskListState.empty) {
      return Column(
        children: [
          Center(
            child: ListTile(
              leading: Icon(Icons.pending_actions, size: 128,),
              title: Text('\n\nThere is no assigmment for selected parameters!'),
              subtitle: Text('Please choose another keyword'),
            ),
          )
        ],
      );
    }

    if (snapshot.data.state == TaskListState.failed) {
      return Column(
        children: [
          Center(
            child: ListTile(
              leading: Icon(Icons.pending_actions, size: 128,),
              title: Text('\nUnfortunatelly, something went wrong!\n${snapshot.data.errorMessage}\n'),
              subtitle: Text('Please try again with another keyword'),
            ),
          )
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
        );
      },
      itemBuilder: (context, index) {
        return ListTile(
          leading: ProgressChart(
              percentage: snapshot.data.taskList[index].progress == null
                  ? 0.0
                  : snapshot.data.taskList[index].progress.toDouble()),
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: DateUtil.formatToyMMMd(snapshot
                                .data.taskList[index].dateStart)),
                        readOnly: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Start Date'),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: DateUtil.formatToyMMMd(snapshot
                                .data.taskList[index].dateTarget)),
                        readOnly: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Target Date'),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: DateUtil.formatToyMMMd(snapshot
                                .data.taskList[index].dateFinish)),
                        readOnly: true,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Finish Date'),
                      ),
                    )
                  ],
                ),
                Text(snapshot.data.taskList[index].taskName,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(snapshot.data.taskList[index].taskDescription,
                    style: TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text:
                            snapshot.data.taskList[index].division),
                        readOnly: true,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Division'),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: snapshot.data.taskList[index].pic),
                        readOnly: true,
                        maxLines: 2,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_pin),
                            border: InputBorder.none,
                            labelText: 'PIC'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          onTap: () {},
        );
      },
      itemCount: snapshot.data == null || snapshot.data.taskList == null
          ? 0
          : snapshot.data.taskList.length,
    );
  }


  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search assignments...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      if (searchQuery.trim().isEmpty) {
        return;
      }
      EasyDebounce.debounce('debouncer1', Duration(milliseconds: 1000), () => bloc.getTaskListState(searchQuery));
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

}