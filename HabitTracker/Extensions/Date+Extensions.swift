//
//  View+Extensions.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 09/01/25.
//

import Foundation
import SwiftUI
extension Date{
    // PEGA O NOME DOS DIAS E O MENOS 1 FICA POR EXEMPLO DOMINGO = 0 SEGUNDA 1 ...
    var weekDay: String{
        let calendar = Calendar.current
        let weekDay = calendar.weekdaySymbols[calendar.component(.weekday, from: self)-1]
        return weekDay
    }
    // retorna o inicio do dia exemplo 12/12/2025 00:00
    var startOfDay : Date{
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    // retorna se o dia é hj
    var isToday : Bool{
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    // metodo para retornar o primeiro dia do mes
    static var startDateOfThisMonth : Date{
        let calendar = Calendar.current
        guard let date = calendar.date(from: calendar.dateComponents([.year, .month], from: .now)) else { fatalError("não foi possivel recuperar a data ")
        }
        return date
    }
    static var datesInThisMonth : [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: .now) else {
            fatalError("não foi possivel recuperar a data ")
        }
        return range.compactMap {
            calendar.date(byAdding: .day,value : $0 - 1, to: .startDateOfThisMonth)
        }
    } // retorna todos os dias do mes corrente

    
}
