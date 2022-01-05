import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class BackupCommand extends Command<void> {
  @override
  String get description => 'backups up a database.';

  @override
  String get name => 'backup';

  @override
  void run() {
    if (which('mysqldump').notfound) {
      printerr(red('You must install mysqldump first'));
      throw ExitException(1);
    }

    final args = getArgs(argResults, additionalArgs: ['Path to backup file']);

    backup(MySqlSettings.load(args[0]), args[1]);
  }

  void backup(MySqlSettings settings, String pathToBackupfile) {
    var columnStatistics = '--column-statistics=0 ';
    var success = false;
    while (!success) {
      final result = 'mysqldump --host ${settings.host} '
              '--port=${settings.port} '
              '--user ${settings.user} '
              // so we can backup a v5 db using v8 tools. For large table this
              // is also recommended.
              '$columnStatistics'
              '--password="${settings.password}" '
              '--databases ${settings.dbname} '
              '--result-file=$pathToBackupfile '
          .start(nothrow: true, progress: Progress.capture());

      if (result.toParagraph().contains('column-statistics=0')) {
        /// retry without --column-statistics.
        columnStatistics = '';
      } else {
        success = true;
      }
    }
  }
}

class ExitException implements Exception {
  ExitException(this.exitCode);

  int exitCode;

  @override
  String toString() => 'Application ended with exitCode $exitCode';
}
