//
//  ArticlePreview.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 17/03/24.
//

import SwiftUI

struct ArticlePreview: View {
    var body: some View {
        HStack{
            Image(systemName: "1.circle")
            Spacer()
            VStack(alignment: .trailing){
                Text("category")
                Text("info")
                Text("id")
            }
        }
    }
}

struct ArticlePreview_Previews: PreviewProvider {
    static var previews: some View {
        ArticlePreview()
    }
}
