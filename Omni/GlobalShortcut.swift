import SwiftUI
import Carbon

class GlobalShortcut {
    private var eventHandler: EventHandlerRef?
    private let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    func register() {
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        let handler: EventHandlerUPP = { _, event, userData in
            let shortcut = Unmanaged<GlobalShortcut>.fromOpaque(userData!).takeUnretainedValue()
            shortcut.callback()
            return noErr
        }
        
        InstallEventHandler(GetApplicationEventTarget(), handler, 1, &eventType, Unmanaged.passUnretained(self).toOpaque(), &eventHandler)
        
        // Register Ctrl+Space
        var hotKeyID = EventHotKeyID(signature: OSType(0x4F4D4E49), id: 1) // "OMNI" in hex
        var hotKeyRef: EventHotKeyRef?
        
        // controlKey + space (49)
        RegisterEventHotKey(UInt32(49), UInt32(controlKey), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }
    
    func unregister() {
        if let handler = eventHandler {
            RemoveEventHandler(handler)
        }
    }
}
