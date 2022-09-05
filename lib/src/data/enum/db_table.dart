enum DBTable {
  noSuchTable('noSuchTable'),
  currentQuest('CurrentTable');

  final String tableName;

  const DBTable(this.tableName);

  factory DBTable.getByTableName(String tableName) =>
      DBTable.values.firstWhere((value) => value.tableName == tableName,
          orElse: () => DBTable.noSuchTable);
}
