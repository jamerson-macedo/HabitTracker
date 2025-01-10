//
//  Habit.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 10/01/25.
//
import SwiftUI
import SwiftData
@Model
class Habit{
    var name :String
    var frequencies : [Frequency]
    var createdAt : Date = Date()
    var completedDate : [TimeInterval] = []
    var notificationsId : [String] = []
    var notificationsTiming : Date?
    var uniqueId : String = UUID().uuidString
    init(name: String, frequencies: [Frequency], notificationsId: [String] = [], notificationsTiming: Date? = nil) {
        self.name = name
        self.frequencies = frequencies
        self.notificationsId = notificationsId
        self.notificationsTiming = notificationsTiming
     
    }
    var isNotificationEnabled : Bool{
        return !notificationsId.isEmpty && notificationsTiming != nil
    }
}
