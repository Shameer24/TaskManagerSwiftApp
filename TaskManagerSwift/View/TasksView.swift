//
//  TasksView.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/9/24.
//

import Foundation
import SwiftUI
import SwiftData

struct TasksView : View {
    
    @Binding var currentDate : Date
    @Query private var Tasks : [Task]
    
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: currentDate.wrappedValue)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = #Predicate<Task> {
            return $0.creationDate >= startDate && $0.creationDate < endDate
        }
        let sort = [SortDescriptor(\Task.creationDate, order: .forward)]
        
        self._Tasks = Query(filter: predicate, sort : sort, animation: .snappy)
        
    }
    
    var body: some View {
        VStack(alignment : .leading, spacing: 35){
            ForEach(Tasks) {task in
                HStack(alignment : .top, spacing: 15){
                    Circle()
                        .fill(task.isCompleted ? .red : .green)
                        .frame(width: 10, height: 10)
                        .padding(4)
                    
                    VStack(alignment : .leading, spacing: 8){
                        Text(task.taskTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .strikethrough(task.isCompleted,  pattern: .solid, color: .black)
                        
                        Label(task.creationDate.format("hh:mm a"), systemImage : "clock")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(15)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .background(Color[task.tint], in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15, bottomTrailingRadius: 15, topTrailingRadius: 15))
                    .offset(y : -8)
                    
                }
                .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.vertical, .top, .leading], 15)
        .overlay {
            if Tasks.isEmpty{
                Text("No Tasks Found")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(width: 150)
            }
        }
    }
}
#Preview {
    ContentView()
}
