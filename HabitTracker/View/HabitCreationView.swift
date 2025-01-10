//
//  HabitCreationView.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 10/01/25.
//

import SwiftUI
import UserNotifications
struct HabitCreationView: View {
    var habit :Habit?
    @State private var name : String = ""
    @State private var frequencies : [Frequency] = []
    @State private var notificationDate : Date = Date()
    @State private var enableNotifications :Bool = false
    @State private var isNotificationPermissionGranted : Bool = false
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                TextField("Workout for 15 Min's",text: $name)
                    .font(.title)
                    .padding(.bottom,10)
                Text("Habit Frequency")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top,5)
                
                HabitCalendarView(isDemo : isNewHabit,
                                  createdAt: habit?.createdAt ?? .now,
                                  frequencies: frequencies,
                                  completedDates: habit?.completedDate ?? []
                ).applyPaddedBackground(15)
                if isNewHabit{
                    FrequencyPicker()
                        .applyPaddedBackground(10)
                }
                Text("Notification's")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top,5)
                NotificationProperties()
                HabitCreationButton().padding(.top,10)
                
            }.padding(15)
            
        }
        .animation(.snappy,value: enableNotifications)
        .background(.primary.opacity(0.05))
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onAppear{
            // se tiver habit
            guard let habit else {return}
            name = habit.name
            enableNotifications = habit.isNotificationEnabled
            notificationDate = habit.notificationsTiming ?? .now
            frequencies = habit.frequencies
        }
        .task {
            // verificar permissão
            isNotificationPermissionGranted = (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])) ?? false
        }
    }
    @ViewBuilder
    func FrequencyPicker() -> some View {
        HStack(spacing : 5){
            ForEach(Frequency.allCases,id: \.rawValue){ frequency in
                Text(frequency.rawValue.prefix(3))
                    .font(.caption)
                    .hSpacing(.center)
                    .frame(height: 30)
                    .background{
                        if frequencies.contains(frequency){
                            RoundedRectangle(cornerRadius: 8).fill(.fill)
                                
                        }
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy){
                            if frequencies.contains(frequency){
                                frequencies.removeAll(where: {
                                    $0 == frequency
                                })
                            }else {
                                frequencies.append(frequency)
                            }
                        }
                    }
                    
            }
        }
    }
    @ViewBuilder
    func NotificationProperties() -> some View {
        Toggle("Enable Remainder Notification", isOn: $enableNotifications).font(.callout)
            .applyPaddedBackground(12)
            .disableWithOpacity(!isNotificationPermissionGranted)
        if enableNotifications && isNotificationPermissionGranted{
            DatePicker("Preffered Reminder Time", selection: $notificationDate,displayedComponents: [.hourAndMinute]).applyPaddedBackground(12)
                .transition(.blurReplace)
        }
        if !isNotificationPermissionGranted{
            Text("Noficitiation Permission is Denied, Please enable it in settings").font(.caption2).foregroundStyle(.gray)
        }
    }
    @ViewBuilder
    func HabitCreationButton() -> some View {
        HStack(spacing : 10){
            Button{
                createHabit()
            }label: {
                HStack(spacing:10){
                    Text("\(isNewHabit ? "Create" : "Update")Habit")
                    Image(systemName: "checkmark.circle.fill")
                }
                .fontWeight(.semibold)
                .hSpacing(.center)
                .foregroundStyle(.white)
                .padding(.vertical,12)
                .background(.green.gradient,in: .rect(cornerRadius: 10))
                .contentShape(.rect)
            }
            .disableWithOpacity(habitValidation)
            if !isNewHabit{
                Button{
                    guard let habit else{
                        return}
                    dismiss()
                    Task{
                        try? await Task.sleep(for:.seconds(0.2))
                        context.delete(habit)
                        try? context.save()
                    }
                    
                }label: {
                    Image(systemName: "trash").fontWeight(.semibold).foregroundStyle(.white)
                        .padding(14)
                        .background(.red.gradient,in: .circle)
                }
            }
        }
    }
    var habitValidation:Bool{
        frequencies.isEmpty || name.isEmpty
    }
    var isNewHabit:Bool{
        habit == nil
    }
    private func createHabit(){
        Task{
            @MainActor in
            if let habit{
                habit.name = name
                cancelNotifications(habit.notificationsId)
                if enableNotifications{
                    let ids = (try? await scheduleNotifications()) ?? []
                    habit.notificationsTiming = notificationDate
                    habit.notificationsId = ids
                    
                }else {
                    habit.notificationsId = []
                    habit.notificationsTiming = nil
                }
            }else {
                if enableNotifications{
                    let notificationsIDS = (try? await scheduleNotifications()) ?? []
                    let habit = Habit(name: name, frequencies: frequencies, notificationsId: notificationsIDS,notificationsTiming: notificationDate)
                    context.insert(habit)
                }else {
                    let habit = Habit(name: name, frequencies: frequencies)
                    context.insert(habit)
                }
                try? context.save()
                dismiss()
            }
        }
    }
    private func cancelNotifications(_ ids : [String]){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    private func scheduleNotifications() async throws -> [String]{
        var notificationsIDS : [String] = []
        let weekDaySymbols : [String] = Calendar.current.weekdaySymbols
        let content = UNMutableNotificationContent()
        content.title = "Habit Remainder"
        content.body = "Complete your \(name) Habit!"
        for frequency in frequencies{
            let hour = Calendar.current.component(.hour, from: notificationDate)
            let minute = Calendar.current.component(.minute, from: notificationDate)
            let id : String = UUID().uuidString
            if let dayIndex = weekDaySymbols.firstIndex(of: frequency.rawValue){
                var scheduleDateComponent = DateComponents()
                scheduleDateComponent.weekday = dayIndex + 1
                scheduleDateComponent.hour = hour
                scheduleDateComponent.minute = minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: scheduleDateComponent, repeats: true)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                try await UNUserNotificationCenter.current().add(request)
                notificationsIDS.append(id)
            }
        }
        return notificationsIDS
        
    }
}

#Preview {
    HabitCreationView()
}
