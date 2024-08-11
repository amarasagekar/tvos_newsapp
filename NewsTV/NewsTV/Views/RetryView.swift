//
//  RetryView.swift
//  NewsTV
//
//  Created by AMAR on 11/08/24.
//

import SwiftUI

struct RetryView: View {
    let text: String
    let rettryAction: () -> ()
    
    var body: some View {
        VStack(spacing:8){
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: rettryAction){
                Text("Try Action")
            }
        }
    }
}

#Preview {
    RetryView(text: "", rettryAction: {})
}
