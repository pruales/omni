import SwiftUI
import AppKit

class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

class SearchWindowManager: ObservableObject {
    private var window: NSWindow?
    @Published var searchText: String = ""
    @Published var commandOutput: String = ""
    @Published var shouldFocus: Bool = false
    @Published var isVisible: Bool = false {
        didSet {
            if isVisible {
                showWindow()
            } else {
                hideWindow()
            }
        }
    }
    
    init() {
        setupWindow()
    }
    
    private func setupWindow() {
        let contentView = SearchWindow(
            searchText: Binding(
                get: { self.searchText },
                set: { self.searchText = $0 }
            ),
            isVisible: Binding(
                get: { self.isVisible },
                set: { self.isVisible = $0 }
            ),
            commandOutput: Binding(
                get: { self.commandOutput },
                set: { self.commandOutput = $0 }
            ),
            shouldFocus: Binding(
                get: { self.shouldFocus },
                set: { self.shouldFocus = $0 }
            )
        )
        
        let hostingController = NSHostingController(rootView: contentView)
        
        window = FloatingPanel(contentViewController: hostingController)
        window?.styleMask = [.borderless, .fullSizeContentView, .nonactivatingPanel]
        window?.level = .floating
        window?.isOpaque = false
        window?.backgroundColor = .clear
        window?.hasShadow = true
        window?.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient]
        window?.isMovableByWindowBackground = true
        
        centerWindow()
    }
    
    private func centerWindow() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        // Set initial size
        window.setContentSize(NSSize(width: 600, height: 60))
        
        let screenFrame = screen.frame
        let windowFrame = window.frame
        
        // Center horizontally and position at 70% from bottom
        let x = (screenFrame.width - windowFrame.width) / 2
        let y = screenFrame.height * 0.7
        
        window.setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    private func showWindow() {
        searchText = ""
        commandOutput = ""
        shouldFocus = false
        
        window?.makeKeyAndOrderFront(nil)
        window?.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
        
        // Force the window to become key and trigger focus
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let window = self?.window else { return }
            window.makeKey()
            self?.shouldFocus = true
        }
    }
    
    private func hideWindow() {
        window?.orderOut(nil)
        // Clear search text and output when hiding
        searchText = ""
        commandOutput = ""
    }
    
    func toggle() {
        isVisible.toggle()
    }
}
