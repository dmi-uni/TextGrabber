//
//  ContentView.swift
//  TextGrabber
//
//  Created by Danil Masnaviev on 10/12/21.
//

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    @State private var enabled = false
    
    var startColor: Color
    var endColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(configuration.isPressed ? 0.5 : 1))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .shadow(radius: 4)
            .font(.largeTitle)
    }
}

struct ContentView: View {
    
    @State private var showScanner = false
    @State private var texts: [ScanData] = []
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: {
            textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        texts.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if texts.count > 0 {
                        List {
                            ForEach(texts) { text in
                                NavigationLink(
                                    destination: ScrollView{
                                        Text(text.content)
                                            .textSelection(.enabled)
                                    },
                                    label: {
                                        Text(text.content).lineLimit(1)
                                    }
                                )
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    else {
                        Text("No scanned documents").font(.headline)
                    }
                }
                VStack {
                    Spacer()
                    Button {
                        self.showScanner = true
                    } label: {
                        HStack {
                            Image(systemName: "doc.viewfinder.fill")
                        }
                    }
                    .buttonStyle(GradientButtonStyle(startColor: Color.accentColor, endColor: Color.accentColor))
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Documents")
                .sheet(isPresented: $showScanner, content: {
                    self.makeScannerView()
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
