//
//  ContentView.swift
//  Shared
//
//  Created by Shuichi on 2021/07/03.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        VStack {
            Button("Play") {
                viewModel.playAudio()
                viewModel.handleRecord()
            }
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
