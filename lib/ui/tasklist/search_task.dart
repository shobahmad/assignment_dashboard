import 'package:assignment_dashboard/bloc/task/searchtask_bloc.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/ui/common/list_item_task.dart';
import 'package:assignment_dashboard/ui/taskdetail/task_detail.dart';
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

    return ListItemTask(listTask: snapshot.data.taskList, onItemClick: (value) {
      Future.delayed(const Duration(seconds: 0), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskDetail(
                      taskId: value.taskId, taskName: value.taskName)));
        });
    },);
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