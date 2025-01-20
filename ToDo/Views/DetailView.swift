//
//  DetailView.swift
//  ToDo
//
//  Created by 이수겸 on 1/20/25.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var item: ToDo
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetailView(item: ToDo(title: "Hello"))
}
