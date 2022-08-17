//
//  WebView.swift
//  MarvelAPIApp
//
//  Created by Md Shah Alam on 7/20/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        
        view.load(URLRequest(url: url))
        
        return view
        
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
