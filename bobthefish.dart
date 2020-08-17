#! /usr/bin/env dshell
import 'package:dshell/dshell.dart';

/// dshell script generated by:
/// dshell create bob.dart
///
/// See
/// https://pub.dev/packages/dshell#-installing-tab-
///
/// For details on installing dshell.
///

void main() {
  print('''Bob is a fish who really, Really, REALLY wants a cat.
Sadly however, Bob's father is a horrible tyrannical fish who hates the poor innocent cat race.
So, he wont allow his sweet beautiful child get a cat. 
How cruel :(''');
  var horrible = confirm(
       magenta("Do you think Bob's father is a horrible fish being."));
  if (horrible) {
    print(blue('''"Yay!!!!!:)
I knew you would agree with me.
I mean how could anyone think someone who doesn't like cats could be anything but EVIL >:("'''));
  } else {
    print(
        '''Bob, got so angry with your horrendous claim of his father being right that Bob killed you very slowly and painfully.
you are now dead.
${red("I wish you a horrible time in hell:)")}''');
  }
}
