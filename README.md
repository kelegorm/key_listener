# keypress_listener
Helper to catch key combinations

Usage:

    import 'package:key_listener/key_listener.dart';
    
    class SomeElement extends HtmlElement {
    
      StreamSubscription<KeyboardEvent> _duplicateKeySub;
    
      //...
    
      @override
      void attached() {
        super.attached();
        
        _duplicateKeySub = KeyListener.listenKeyPressed(keys: 'ctrl+d cmd+d')
            .listen(keyListener_onDuplicateKey);
      }
      
      @override
      void detached() {
        _duplicateKeySub?.cancel();
        _duplicateKeySub = null;
        
        super.detached();
      }
      
      void keyListener_onDuplicateKey(KeyboardEvent e) {
        //skip events from text field (if you need)
        if (document.activeElement == document.body) {
          e.preventDefault();
          // TODO something
        }
      }
    }
