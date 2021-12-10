#! /usr/bin/env dcli

import 'dart:io';

/// dcli script generated by:
/// dcli create ipaddr.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main() {
  NetworkInterface.list().then((interfaces) {
    for (final interface in interfaces) {
      print('name: ${interface.name}');
      var i = 0;
      for (final address in interface.addresses) {
        print('  ${i++}) ${address.address}');
      }
    }
  });
}
