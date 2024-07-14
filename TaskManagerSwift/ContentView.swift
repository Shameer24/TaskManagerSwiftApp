//
//  ContentView.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/8/24.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var currentDate : Date = .init()
    @State private var weekslider : [[Date.Weekday]] = []
    @State private var currentWeekIndex = 1
    @State private var isCreateNewTask : Bool = false
//    @State private var tasks : [Task]
    

    var body: some View {
        
        VStack(){
            Header(currentDate: $currentDate, currentWeekIndex: $currentWeekIndex, weekslider : $weekslider)
            ScrollView(.vertical){
                VStack{
                    TasksView(currentDate : $currentDate)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(maxHeight : .infinity, alignment: .top)
        .overlay(alignment : .bottomTrailing,content: {
            Button(action: {
                isCreateNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .frame(width: 55, height: 55)
                    .background(Color(.blue), in: .circle)
            })
            .padding(15)
        })
        .onAppear(perform: {
            if weekslider.isEmpty{
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekslider.append(firstDate.fetchPreviousWeek())
                }
                weekslider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekslider.append(lastDate.fetchNextWeek())
                }
            }
        })
        .sheet(isPresented: $isCreateNewTask, content: {
            NewTaskView()
                .presentationDetents([.height(300)])
        })
    }
}

#Preview {
    ContentView()
}

struct Header : View {
    @State var calendarId: Int = 0
    @Binding var currentDate : Date
    @Binding var currentWeekIndex : Int
    @Binding var weekslider : [[Date.Weekday]]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6){
            HStack(spacing : 10){
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.blue)
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.blue)
                Image(systemName: "calendar")
                    .font(.title3)
                    .overlay{
                        DatePicker(
                            "",
                            selection: $currentDate,
                            displayedComponents: [.date]
                        )
                        .id(calendarId)
                        .labelsHidden()
                        .blendMode(.destinationOver)
                        .scaleEffect(1.5, anchor: .leading)
                        .padding(.leading, -150)
                        .onChange(of: currentDate) { oldValue, newValue in
                            let components = Calendar.current.dateComponents([.year, .month], from: oldValue, to: newValue)
                            guard components.year == 0 && components.month == 0 else {
                                return
                            }
                            calendarId += 1
                            print(newValue)
                            weekslider.removeAll()
                            print(weekslider)
                            let currentWeek = newValue.fetchWeek(Calendar.current.startOfDay(for: newValue))
                            
                            if let firstDate = currentWeek.first?.date {
                                weekslider.append(firstDate.fetchPreviousWeek())
                            }
                            weekslider.append(currentWeek)
                            
                            if let lastDate = currentWeek.last?.date {
                                weekslider.append(lastDate.fetchNextWeek())
                            }
                            print(weekslider)
                            currentWeekIndex = 1
                        }
                        
                    }
            }
            .frame(maxWidth : .infinity, alignment: .leading)
            .font(.title.bold())
            .onChange(of: currentDate){
                
            }
            
            
            
            HStack(spacing : 0){
                Text(currentDate.formatted(date: .complete, time: .omitted))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.gray)
                
            }
            TabView(selection: $currentWeekIndex){
                ForEach(0..<weekslider.count, id: \.self) { index in
                    let week = weekslider[index]
                    WeekView(currentDate: $currentDate, week : week)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
            .onChange(of: currentWeekIndex) { oldvalue, newvalue in
                if let firstDate = weekslider[currentWeekIndex].first?.date, newvalue == 0 {
                    weekslider.insert(firstDate.fetchPreviousWeek(), at: 0)
                    weekslider.removeLast()
                    currentWeekIndex = 1
                }
                if let lastDate = weekslider[currentWeekIndex].last?.date, newvalue == weekslider.count - 1 {
                    weekslider.append(lastDate.fetchNextWeek())
                    weekslider.removeFirst()
                    currentWeekIndex = 1
                }
                
            }
        }
        .padding(15)
        .background(.white)
        
    }
}


struct WeekView : View {
    
    @Binding var currentDate : Date
    @Namespace private var animation
    var week : [Date.Weekday]
    
    var body: some View {
        HStack(alignment: .top){
            ForEach(week) { day in
                VStack( alignment : .leading, spacing : 8){
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 30)
                        .background(content: {
                            if Date().isSameDate( day.date, currentDate){
                                Circle()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .offset(y : 25)
                                
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .frame(maxWidth : .infinity, alignment: .center)
                .onTapGesture {
                    withAnimation(.snappy){
                        currentDate = day.date
                    }
                }
            }
        }
    }
}
