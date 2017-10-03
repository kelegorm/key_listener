library key_listener.src.key_listener;

import 'dart:async';
import 'dart:html';


typedef void KeyEventListener(KeyboardEvent event);


class KeyListener {

  /// Listens for events on document body.
  ///
  /// It never prevent default action for event. You should
  /// do it by your own. If you don't want to broke inputs,
  /// you should check for event target too.
  ///
  /// Example:
  ///
  ///     if (document.activeElement != document.body) return;
  ///     event.preventDefault();
  ///
  /// I didn't mapped all chars, so if you need some more
  /// - just add it.
  static Stream<KeyboardEvent> listenKeyPressed({String keys}) {
    if (keys != null && keys.isNotEmpty) {
      return document.body.onKeyDown
          .where((event) => _isKeyMatched(event, _generateCombos(keys.toLowerCase())));
    } else {
      return document.body.onKeyDown;
    }
  }

  /// Listens for key up and down events and fires key status change.
  ///
  /// Good for listen one button like 'shift' or same. Using for key
  /// combo is bit of odd.
  ///
  /// See docs for [listenKeyPressed] for more.
  static Stream<bool> listenKeyStatus(String keys) {
    StreamController<bool> streamController = new StreamController<
        bool>.broadcast();
    List<_KeyCombo> combos = _generateCombos(keys.toLowerCase());
    document.onKeyDown
        .where((KeyboardEvent event) => _isKeyMatched(event, combos))
        .listen((_) {
          streamController.add(true);
        });
    document.onKeyUp
        .where((KeyboardEvent event) => _isKeyMatched(event, combos))
        .listen((_) {
          streamController.add(false);
        });
    return streamController.stream;
  }


  static List<_KeyCombo> _generateCombos(String keys)
      => keys.split(' ').map((str) => new _KeyCombo.fromString(str)).toList();


  static bool _isKeyMatched(KeyboardEvent event, List<_KeyCombo> combos) {
    _KeyCombo current = new _KeyCombo.fromEvent(event);
    return combos.any((_KeyCombo combo) {
      return combo == current;
    });
  }
}

class _KeyCombo {
  String key = '';
  bool ctrl = false;
  bool shift = false;
  bool alt = false;
  bool meta = false;


  _KeyCombo.fromEvent(KeyboardEvent event) {
    key = _keyToString(event);
    shift = event.shiftKey || event.keyCode == 16;
    ctrl = event.ctrlKey || event.keyCode == 17;
    alt = event.altKey || event.keyCode == 18;
    meta = event.metaKey; //key code for meta isn't consistent cross browsers/os, anyway we don't need it in general,
    //it is required only for key up event, when flags are false for alt/ctrl/shift/meta
  }

  _KeyCombo.fromString(String str) {
    str.trim().split('+').forEach((word) {
      if (word == 'ctrl')
        ctrl = true;
      else if (word == 'shift')
        shift = true;
      else if (word == 'alt')
        alt = true;
      else if (word == 'cmd')
        meta = true;
      else
        key = word;
    });
  }


  String _keyToString(KeyboardEvent event)
      => KEY_CODES[event.keyCode] ?? new String.fromCharCode(event.charCode);

  operator == (_KeyCombo that)
      => that is _KeyCombo && that.key == key && that.alt == alt && that.ctrl == ctrl && that.shift == shift && that.meta == meta;

  String toString() => {
    'key' : key,
    'ctrl' : ctrl,
    'shift' : shift,
    'alt' : alt,
    'meta' : meta,
  }.toString();
}

Map<int, String> KEY_CODES = {
  /*don't parse alt/ctrl/shift as key, we should look at only flags only, otherwise KeyListener
  doesn't work with only one key: alt, ctrl or shift*/
  16: '' /*shift*/,
  17: '' /*'ctrl'*/,
  18: '' /*'alt'*/,
  8: 'backspace',
  9: 'tab',
  13: 'enter',
  27: 'esc',
  32: 'space',
  33: 'pageup',
  34: 'pagedown',
  35: 'end',
  36: 'home',
  37: 'left',
  38: 'up',
  39: 'right',
  40: 'down',
  45: 'insert',
  46: 'del',
  48: '0',
  49: '1',
  50: '2',
  51: '3',
  52: '4',
  53: '5',
  54: '6',
  55: '7',
  56: '8',
  57: '9',
  65: 'a',
  66: 'b',
  67: 'c',
  68: 'd',
  69: 'e',
  70: 'f',
  71: 'g',
  72: 'h',
  73: 'i',
  74: 'j',
  75: 'k',
  76: 'l',
  77: 'm',
  78: 'n',
  79: 'o',
  80: 'p',
  81: 'q',
  82: 'r',
  83: 's',
  84: 't',
  85: 'u',
  86: 'v',
  87: 'w',
  88: 'x',
  89: 'y',
  90: 'z',
  106: '*',
  112: 'f1',
  113: 'f2',
  114: 'f3',
  115: 'f4',
  116: 'f5',
  117: 'f6',
  118: 'f7',
  119: 'f8',
  120: 'f9',
  121: 'f10',
  122: 'f11',
  123: 'f12',
};