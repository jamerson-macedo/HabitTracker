//
//  IntroPageView.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 09/01/25.
//

import SwiftUI

struct IntroPageView: View {
    @State private var selectedItem : IntroPageItem = staticIntroItens.first!
    @State private var introItems : [IntroPageItem] = staticIntroItens
    @State private var activeIndex : Int = 0
    @State private var askUserName : Bool = false
    @AppStorage("username") private var username : String = ""
    var body: some View {
        VStack(spacing : 0){
            Button{
                updateItem(isForward: false)
            }label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(.green.gradient)
                    .contentShape(.rect)
            }
            .padding(15)
            .frame(maxWidth: .infinity,alignment: .leading)
            // visivel apenas no segundo item
            .opacity(selectedItem.id != introItems.first?.id ? 1 : 0)
            // parte dos icones
            ZStack{
                // icons animados
                ForEach(introItems) { item in
                    AnimatedIconView(item)
                }
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            // indicador
            VStack(spacing:6){
                HStack(spacing: 4) {
                    ForEach(introItems) { item in
                        Capsule().fill((selectedItem.id == item.id ? Color.green : .gray).gradient)
                            .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
                    }
                }
                Text(selectedItem.title)
                    .font(.title.bold())
                    .contentTransition(.numericText())
                Text(selectedItem.description)
                    .contentTransition(.numericText())
                    .font(.caption2)
                    .foregroundStyle(.gray)
                Button{
                    // se for ultimo
                    if selectedItem.id == introItems.last?.id {
                        askUserName.toggle()
                    }
                    updateItem(isForward:true)
                }label: {
                    Text(selectedItem.id == introItems.last?.id ? "Continue" : "Next")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .frame(width: 250)
                        .padding()
                        .background(.green.gradient,in:.capsule)
                }
                .padding(.top,25)
            }.multilineTextAlignment(.center)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
        }
        
    }
    
    @ViewBuilder
    func AnimatedIconView(_ item : IntroPageItem) -> some View {
        let isSelected = selectedItem.id == item.id
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120,height: 120)
            .background(.green.gradient, in: .rect(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.background)
                    .shadow(color: .primary.opacity(0.2), radius: 1,x:1, y:1)
                    .shadow(color: .primary.opacity(0.2), radius: 1,x:-1, y:-1)
                    .padding(-3)
                    .opacity(selectedItem.id == item.id ? 1 : 0)
            }
        // resetando a rotação
            .rotationEffect(.init(degrees: -item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x:item.offset)
            .rotationEffect(.init(degrees: item.rotation))
            .zIndex(isSelected ? 2 : item.zIndex)
        
    }
    func updateItem(isForward : Bool){
        guard isForward ? activeIndex != introItems.count - 1 : activeIndex != 0 else { return }
        
        var fromIndex : Int
        var extraOffset : CGFloat
        
        if isForward{
            activeIndex += 1
        }
        else {
            activeIndex -= 1
        }
        
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = introItems[activeIndex].extraOffset
        }else {
            extraOffset = introItems[activeIndex].extraOffset
            fromIndex = activeIndex + 1
        }
        // reseting zindex
        for index in introItems.indices {
            introItems[index].zIndex = 0
        }
        Task {[fromIndex,extraOffset] in
            withAnimation(.bouncy(duration:3)){
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                introItems[fromIndex].offset = introItems[activeIndex].offset
                introItems[activeIndex].offset = extraOffset
                
                introItems[fromIndex].zIndex = 1
            }
            try? await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration:0.9)){
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].anchor = .center
                introItems[activeIndex].offset = .zero
                selectedItem = introItems[activeIndex]
            }
        }
    }
}

#Preview {
    IntroPageView()
}
