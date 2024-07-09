//
//  ContentView.swift
//  QRCodeGenerator
//
//  Created by R92 on 09/07/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var text = ""
    @State private var QRCodeImage: UIImage?
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("QR Code Generator")
                    .padding()
                    .font(.largeTitle)
                    .bold()
                
                TextField("Enter the URL", text: $text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                    
                if text != "" {
                    Button("QRCode generator") {
                        QRCodeImage = UIImage(data: generatorQRCode(text: text)!)
                    }
                    .padding()
                    .font(.headline)
                    .foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                    .padding()
                }
                
                
                if QRCodeImage != nil {
                    QRCodeImagePreview(QRCodeImage: $QRCodeImage, text: $text)
                    
                    Button("Save QR-Code in Gallery") {
                        if let renderImage = QRCodeImage {
                            UIImageWriteToSavedPhotosAlbum(renderImage, nil, nil, nil)
                        } else {
                            print("Failed to save image: Image is nil")
                        }
                    }
                } else {
                    Text("Enter some text")
                        .foregroundColor(.indigo)
                        .font(.headline)
                        .frame(width: 200, height: 200)
                }
                Spacer()
                Text("Created By Rahul Sharma")
                    .padding()
                    .foregroundColor(.primary.opacity(0.5))
                    .font(.headline)
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea()
    }
    
    func generatorQRCode(text: String) -> Data? {
        let filter = CIFilter.qrCodeGenerator()
        
        guard let data = text.data(using: .ascii, allowLossyConversion: false) else { return nil }
        filter.message = data
        guard let ciImage = filter.outputImage else { return nil }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = ciImage.transformed(by: transform)
        let uiImage = UIImage(ciImage: scaledImage)
        
        return uiImage.pngData()
    }
}

struct QRCodeImagePreview: View {
    
    @Binding var QRCodeImage: UIImage?
    @Binding var text: String
    
    var body: some View {
        VStack {
            Image(uiImage: QRCodeImage!)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(5)
                .padding()
            
            Text("\(text) QR-Code")
                .padding()
                .frame(width: 400,height: 100)
        }
    }
}

#Preview {
    ContentView()
}
