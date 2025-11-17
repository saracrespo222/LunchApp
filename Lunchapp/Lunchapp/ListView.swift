//
//  ListView.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 11/11/25.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        VStack{
            List{
                Text("Plantano")
                Text("Payaya")
                Text("Manzana")
            }
        }
    }
}

#Preview {
    ListView()
}
