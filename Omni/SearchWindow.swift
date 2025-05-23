import SwiftUI

struct SearchWindow: View {
    @Binding var searchText: String
    @Binding var isVisible: Bool
    @Binding var commandOutput: String
    @Binding var shouldFocus: Bool
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16))
                
                TextField("Type a command or search...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18))
                    .focused($isSearchFieldFocused)
                    .onSubmit {
                        executeCommand()
                    }
                    .onKeyPress(.escape) {
                        isVisible = false
                        return .handled
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        commandOutput = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            
            Divider()
                .opacity(0.3)
            
            if !commandOutput.isEmpty {
                VStack(alignment: .leading) {
                    Text(commandOutput)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.black.opacity(0.1))
            }
        }
        .frame(width: 600)
        .frame(minHeight: commandOutput.isEmpty ? 60 : 120)
        .animation(.easeInOut(duration: 0.2), value: commandOutput)
        .background(
            VisualEffectView()
                .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .onAppear {
            // Delay focus to ensure window is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFieldFocused = true
            }
        }
        .onChange(of: shouldFocus) { _, newValue in
            if newValue {
                isSearchFieldFocused = true
                shouldFocus = false
            }
        }
    }
    
    private func executeCommand() {
        let trimmedCommand = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedCommand.lowercased() == "hello" {
            commandOutput = "Hello, World!"
        } else {
            commandOutput = "Unknown command: \(trimmedCommand)"
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}