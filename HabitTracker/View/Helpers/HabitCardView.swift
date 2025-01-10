//
//  HabitCardView.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 10/01/25.
//

import SwiftUI

struct HabitCardView: View {
    var animationId : Namespace.ID
    var habit : Habit
    var body: some View {
        VStack(alignment : .leading,spacing: 12){
            HStack(spacing:10){
                VStack(alignment:.leading,spacing: 5){
                    Text(habit.name).font(.callout)
                    Text("Created at " + habit.createdAt.format("dd MMM, YYYY"))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                Spacer(minLength: 0)
                CompletionProgressIndicator()
            }
            HabitCalendarView(createdAt: habit.createdAt, frequencies: habit.frequencies, completedDates: habit.completedDate)
                .applyPaddedBackground(10)
            // para a transição de zoom
                .matchedTransitionSource(id: habit.uniqueId, in: animationId)
            if habit.frequencies.contains(where: {
                $0.rawValue == Date.now.weekDay
            }) && !habit.completedDate.contains(Date.now.startOfDay.timeIntervalSince1970){
                CompleteButton()
            }
        }
    }
    @ViewBuilder
    func CompletionProgressIndicator() ->some View{
        let habitMatchingDateInThisMonth = Date.datesInThisMonth.filter{ date in
            habit.frequencies.contains{
                $0.rawValue == date.weekDay
            } && date.startOfDay >= habit.createdAt.startOfDay
            
        }
        let habitCompletedInThisMonth = habitMatchingDateInThisMonth.filter{
            habit.completedDate.contains($0.timeIntervalSince1970)
        }
        let progress = CGFloat(habitCompletedInThisMonth.count) / CGFloat(habitMatchingDateInThisMonth.count)
        VStack(spacing : 6){
            ZStack{
                Circle().stroke(.fill,lineWidth: 3)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.green.gradient,lineWidth: 3)
                    .rotationEffect(.init(degrees: -90))
            }
            .frame(width: 30,height: 30)
            Text("\(habitCompletedInThisMonth.count)/\(habitMatchingDateInThisMonth.count)")
                .font(.caption2)
                .foregroundStyle(.gray)
            
        }
    }
    @ViewBuilder
    func CompleteButton() ->some View{
        VStack(spacing:10){
            Text("Have you completed the habit today?").font(.callout)
            HStack(spacing:10){
                Button("Yes, completed"){
                    withAnimation(.snappy) {
                        let todayTimestamp = Date.now.startOfDay.timeIntervalSince1970
                        habit.completedDate.append(todayTimestamp)
                        
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .tint(.green)
            }
        }
        .hSpacing(.center)
        .applyPaddedBackground(10)
    }
}

