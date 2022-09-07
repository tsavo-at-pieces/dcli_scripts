#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';
import 'dart:math';
import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

/// dcli script generated by:
/// dcli create hog.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main(List<String> args) async {
  // args = ['disk'];
  final runner = CommandRunner<void>('hog', 'Find resource hogs')
    ..addCommand(DiskCommand())
    ..addCommand(MemoryCommand())
    ..addCommand(CPUCommand());
  await runner.run(args);
}

class CPUCommand extends Command<void> {
  @override
  String get description => 'Finds apps that are hogging CPU';

  @override
  String get name => 'cpu';

  @override
  void run() {
    print('Not implemented');
  }
}

class MemoryCommand extends Command<void> {
  @override
  String get description => 'Finds apps that are hogging Memory';

  @override
  String get name => 'memory';

  @override
  void run() {
    print('Not implemented');
  }
}

class DiskCommand extends Command<void> {
  @override
  String get description =>
      'Displays the top 50 largest directories below the current directory';

  @override
  String get name => 'disk';

  @override
  void run() {
    final directories = <String>[];
    print(green('Scanning...'));
    find('*', includeHidden: true, types: [Find.directory])
        .forEach(directories.add);

    final directorySizes = <DirectorySize>[];

    print(orange('Found ${directories.length} directories'));

    var totalSpace = 0;
    print(green('Calculating sizes...'));
    for (final directory in directories) {
      final directorySize = DirectorySize(directory);
      directorySizes.add(directorySize);

      find('*',
              workingDirectory: directory,
              includeHidden: true,
              recursive: false)
          .forEach((file) {
        try {
          directorySize.size += stat(file).size;
          totalSpace += directorySize.size;
        } on FileSystemException catch (e) {
          printerr(e.toString());
        }
      });
    }

    directorySizes.sort((a, b) => b.size - a.size);

    print('${orange('Space Used by ${truepath(pwd)}:')} '
        '${green(humanNumber(totalSpace))}');
    print(
        '${orange('Free Space:')} ${green(humanNumber(availableSpace(pwd)))}');

    for (var i = 0; i < min(50, directorySizes.length); i++) {
      if (directorySizes[i].size == 0) {
        continue;
      }
      print(Format().row(
          [(humanNumber(directorySizes[i].size)), directorySizes[i].pathTo],
          widths: [10, -1],
          alignments: [TableAlignment.right, TableAlignment.left]));
    }
  }
}

class DirectorySize {
  DirectorySize(this.pathTo);
  String pathTo;
  int size = 0;
}

void showUsage(ArgParser parser) {
  print('Usage: hog -v -prompt <a questions>');
  print(parser.usage);
  exit(1);
}

/// returns the the number [bytes] in a human readable
/// form. e.g. 10G, 100M, 20K, 10B
String humanNumber(int bytes) {
  String human;

  final svalue = '$bytes';
  if (bytes > 1000000000) {
    human = svalue.substring(0, svalue.length - 9);
    human += 'G';
  } else if (bytes > 1000000) {
    human = svalue.substring(0, svalue.length - 6);
    human += 'M';
  } else if (bytes > 1000) {
    human = svalue.substring(0, svalue.length - 3);
    human += 'K';
  } else {
    human = '${svalue}B';
  }
  return human;
}

int availableSpace(String path) {
  if (!exists(path)) {
    throw FileSystemException(
        "The given path ${truepath(path)} doesn't exists");
  }

  final lines = 'df -h "$path"'.toList();
  if (lines.length != 2) {
    throw FileSystemException(
        "An error occured retrieving the device path: ${lines.join('\n')}");
  }

  final line = lines[1];
  final parts = line.split(RegExp(r'\s+'));

  if (parts.length != 6) {
    throw FileSystemException('An error parsing line: $line');
  }

  final factors = {'G': 1000000000, 'M': 1000000, 'K': 1000, 'B': 1};

  final havailable = parts[3];

  if (havailable == '0') {
    return 0;
  }

  final factorLetter = havailable.substring(havailable.length - 1);
  final hsize = havailable.substring(0, havailable.length - 1);

  final factor = factors[factorLetter];
  if (factor == null) {
    throw FileSystemException(
        "Unrecognized size factor '$factorLetter' in $havailable");
  }

  return (int.tryParse(hsize) ?? 0) * factor;
}

void removeOldKernels() {
  r'''dpkg --list | grep 'linux-image' | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p' | xargs sudo apt-get -y purge'''
      .run;

  r'''dpkg --list | grep 'linux-headers' | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p' | xargs sudo apt-get -y purge'''
      .run;
}
