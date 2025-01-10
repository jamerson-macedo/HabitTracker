//
//  IntroPageItem.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 09/01/25.
//

import SwiftUI
struct IntroPageItem : Identifiable {
    var id: String = UUID().uuidString
    var image : String
    var title : String
    var scale : CGFloat
    var anchor : UnitPoint = .center
    var offset : CGFloat = 0
    var rotation : CGFloat = 0
    var zIndex : Int = 0
    var extraOffset : CGFloat = -350
    var description : String
    
}
let introItens : [IntroPageItem] = [
    .init(image: "calendar.circle.fill",
          title: "Track your daily\nhabits",
          scale: 1,
          description: "Log your habits daily to stay\non track with your personal growth"),
    .init(image: "checkmark.circle.fill",
          title: "Stay consistent and \nbuid routines",
          scale: 0.6,
          anchor: .topLeading,
          offset: -70,
          rotation: 30,
          description: "Form habits that stick by marking \noff tasks and staying consistent each day"),
    .init(image: "star.circle.fill",
          title: "Celebrate your\nsmall wins",
          scale: 0.5,
          anchor: .bottomLeading,
          offset: -60,
          rotation: -35,
          description: "Celebrate milestones to stay\nmotivated and reconize your progress."),
    .init(image: "flame.circle.fill",
          title: "Stay motivated\nevery day",
          scale: 0.4,
          anchor: .bottomLeading,
          offset: -50,
          rotation: 160,
          extraOffset: -120,
          description: "Track streaks and use visual progress\nto stay inspired and motivated"),
    .init(image: "clock.circle.fill",
          title: "Track your time\nand progress",
          scale: 0.35,
          anchor: .bottomLeading,
          offset: -50,
          rotation: 250,
          extraOffset: -100,
          description: "Measure your progress over time and \nadjust your habits for better results.")
    
    
]
