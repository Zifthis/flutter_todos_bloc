///VisibilityFilter model will determin which todos our FilteredTodosState
///will contain. In this case, we'll have 3 filters:
///
/// 1. all - show all Todos (default)
/// 2. active - only show Todos which have not been completed
/// 3. completed - only show todos which have been completed

enum VisibilityFilter { all, active, completed }