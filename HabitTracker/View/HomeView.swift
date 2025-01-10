//
//  HomeView.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 10/01/25.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("username") private var username : String = ""
    
    var body: some View {
        ScrollView(.vertical){
            LazyVStack(spacing:15){
                headerView()
            }.padding(15)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
    @ViewBuilder
    func headerView() -> some View{
        VStack(alignment: .leading){
            Text("Welcome Back, \(username)!")
                .font(.title.bold())
                .lineLimit(1)
        }.hSpacing(.leading)
    }
}

#Preview {
    HomeView()
}
