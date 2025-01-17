//
//  ContentView.swift
//  ToDo
//
//  Created by 이수겸 on 1/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var name: String = ""
    @State private var isDone: Bool = false
    @State private var showPopup: Bool = false
    @State private var textFieldValue: String = ""
    @State private var isImportant: Bool = false
    @State private var searchValue: String = ""
    @State private var showCompletionMessage: Bool = false

    
    @Environment(\.modelContext) private var modelContext
    @Query private var todos: [ToDo]
    
    private var filteredTodos: [ToDo] {
        if searchValue.isEmpty {
            return todos
        } else {
            return todos.filter { $0.name.contains(searchValue) }
        }
    }
    
    private var sortedTodos: [ToDo] {
        filteredTodos.sorted { $0.isImportant && !$1.isImportant }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TextField("할 일 검색", text: $searchValue)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                            // 입력창 클리어 버튼. 한 군데만 작성해주면 모든 텍스트필드에 적용
                        }
                    List {
                        ForEach(sortedTodos) { item in
                            HStack {
                                Image(systemName: item.isImportant ? "pin.fill" : "")
                                    .resizable()
                                    .frame(width: 8, height: 13, alignment: .top)
                                    .foregroundStyle(Color.orange)
                                Text(item.name)
                                
                                Spacer()
                                Button(action: {
                                    item.isDone.toggle()
                                    checkCompletion()
                                }, label: {
                                    Image(systemName: item.isDone ? "checkmark.square.fill" : "square" )
                                        .foregroundStyle(Color.orange)
                                    
                                })
                                
                                
                                
                            }
                            .contextMenu {
                                Button(action: {
                                    item.isImportant.toggle()
                                    
                                }, label: {
                                    Text(item.isImportant ? "상단에 고정 해제" : "상단에 고정")
                                })
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .navigationTitle("ToDo")
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                                .foregroundStyle(Color.orange)
                        }
                        
                    }
                    Button(action: {
                        showPopup.toggle()
                        searchValue = ""
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color.orange)
                    })
                    .font(.largeTitle)
                    .padding()
                    .sheet(isPresented: $showPopup) {
                        VStack {
                            Spacer()
                            TextField("할 일 입력", text: $textFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.title)
                                .padding()
                            
                            Button("추가") {
                                if textFieldValue != "" {
                                    addItem(name: textFieldValue)
                                    showPopup.toggle()
                                    textFieldValue = ""
                                }
                            }
                            .foregroundStyle(Color.orange)
                            .padding()
                            Spacer()
                        }
                        .padding()
                        
                    }
                }
                if showCompletionMessage {
                    Text("할 일 완료!")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding()
                        .transition(.scale)
                        .zIndex(1)
                    
                }
            }
        }
    }
    
    private func addItem(name: String) {
        withAnimation {
            let newItem = ToDo(name: name, isDone: false, isImportant: false)
            modelContext.insert(newItem)
            saveItems(item: newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(todos[index])
            }
        }
    }
    
    private func saveItems(item: ToDo) {
        do {
            try modelContext.save()
        } catch {
            print("저장실패 \(error)")
        }
    }
    
    private func checkCompletion() {
        if todos.allSatisfy({ $0.isDone }) {
            withAnimation {
                showCompletionMessage = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showCompletionMessage = false
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: ToDo.self, inMemory: true)
}
