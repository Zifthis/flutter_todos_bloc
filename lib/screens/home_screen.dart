import 'package:flutter/material.dart';
import 'package:flutter_todos/models/app_tab.dart';
import 'package:flutter_todos/widgets/extra_actions.dart';
import 'package:flutter_todos/widgets/filter_button.dart';
import 'package:flutter_todos/widgets/filtered_todos.dart';
import 'package:flutter_todos/widgets/stats.dart';
import 'package:flutter_todos/widgets/tab_selector.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/blocs/blocs.dart';
import 'package:flutter_todos/localization.dart';


///Our HomeScreen will be responsible for creating the Scaffold
///of our application. It will maintain the AppBar, BottomNavigationBar,
///as well as the Stats/FilteredTodos widgets (depending on the active tab).

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterBlocLocalizations.of(context).appTitle),
            actions: [
              FilterButton(visible: activeTab == AppTab.todos),
              ExtraActions(),
            ],
          ),
          body: activeTab == AppTab.todos ? FilteredTodos() : Stats(),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(TabUpdated(tab)),
          ),
        );
      },
    );
  }
}
