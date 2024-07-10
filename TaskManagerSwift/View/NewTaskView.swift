//
//  NewTaskView.swift
//  TaskManagerSwift
//
//  Created by Mohamed Shameer on 7/9/24.
//

import SwiftUI

struct NewTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var taskTitle : String = ""
    @State private var taskDate : Date = Date()
    @State private var taskColor : String = "teal"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .tint(.red)
            })
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Task Title")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                
                
                TextField("Go for a Walk...", text: $taskTitle)
                    .padding(12)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in : .rect(cornerRadius: 10))

            })
            .padding(.top, 5)
            
            HStack(spacing :12 ,content: {
                VStack(alignment: .leading, spacing : 8, content: {
                    Text("Task Date")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                        .padding(.leading, -7)
                })
                .padding(.top, 5)
                .padding(.trailing, -15)
                
                VStack(alignment : .leading, spacing : 15, content :{
                    Text("Task Color")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    
                     
                    let colors : [String] = ["teal", "green", "gray", "yellow", "blue"]
                    
                    HStack(spacing : 0){
                        ForEach(colors, id:\.self){ color in
                            Circle()
                                .fill(Color[color])
                                .frame(width:20, height:20)
                                .background(content : {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                })
                                .frame(maxWidth: .infinity,alignment: .center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.snappy){
                                        taskColor = color
                                    }
                                }
//
                        }
                    }
                    .padding(.bottom, 5)
                })
            })
            
            Spacer()
            
            Button(action: {
                let task = Task(taskTitle: taskTitle, creationDate: taskDate, tint: taskColor)
                do{
                    context.insert(task)
                    try context.save()
                } catch{
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Create New Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.black)
                    .frame(maxWidth : .infinity ,alignment: .center)
                    .padding(12)
                    .background(Color[taskColor], in: .rect(cornerRadius: 10))
                    
                    
            })
        }
        .padding(15)
    }
}

struct ColorArray : Hashable{
    var name : String
    var color : Color
}
#Preview {
    NewTaskView()
}
