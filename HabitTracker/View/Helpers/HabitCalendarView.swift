//
//  HabitCalendarView.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 10/01/25.
//

import SwiftUI

struct HabitCalendarView: View {
    var isDemo:Bool = false
    var createdAt:Date // data de criação do habito
    var frequencies : [Frequency]
    var completedDates : [TimeInterval]
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7),spacing: 12) {
            if !isDemo {
                ForEach(Frequency.allCases,id: \.rawValue){frequency in
                    // prefix pega as 3 primeira letras de cada
                    Text(frequency.rawValue.prefix(3)).font(.caption).foregroundStyle(.gray)
                }
            }
          
            ForEach(0..<Date.startOffsetOfThisMonth,id: \.self){ _ in
                Circle().fill(.clear).frame(height: 30).hSpacing(.center)
            }
            ForEach(Date.datesInThisMonth,id: \.self){ date in
                let day = date.format("dd")
                Text(day)
                    .font(.caption)
                    .frame(height: 30)
                    .hSpacing(.center)
                    .background {
                        // verifica se a data atual esta na lista completadas
                        let isHabitCompleted = completedDates.contains{
                            $0 == date.timeIntervalSince1970
                        }
                        // verifica se a data atual é um habbito a ser realizado
                        let isHabitDay = frequencies.contains{
                            $0.rawValue == date.weekDay
                        } && date.startOfDay >= createdAt.startOfDay
                        
                        let isFutureHabit = date.startOfDay > Date()
                        if isHabitCompleted && isHabitDay{
                            Circle().fill(.green.tertiary)
                        }else if isHabitDay && !isFutureHabit && !isDemo{
                            Circle().fill((date.isToday ? Color.yellow : Color.red).tertiary)
                        }
                        else {
                            if isHabitDay{
                                Circle().fill(.fill)
                            }
                        }
                    }
                
            }
        }
    }
}

#Preview {
    HabitCalendarView(createdAt: .now, frequencies: [.friday,.wednesday], completedDates: [])
}
