#! /usr/bin/env dshell

import 'dart:io';
import 'package:dshell/dshell.dart';

/// dshell script generated by:
/// dshell create rename_tag.dart
/// 
/// See 
/// https://pub.dev/packages/dshell#-installing-tab-
/// 
/// For details on installing dshell.
/// 

void main(List<String> args) {

	if (args.length != 2)
	{
		printerr('usage rename_tag <oldTag> <newTag>');
		exit(1);
	}
	var oldTag = args[0];
	var newTag = args[1];

	'git tag $newTag $oldTag'.run;
	'git tag -d $oldTag'.run;
	'git push origin :refs/tags/$oldTag'.run;
	'git push --tags'.run;
}
