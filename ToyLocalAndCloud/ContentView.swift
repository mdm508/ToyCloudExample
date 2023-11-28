//
//  ContentView.swift
//  ToyLocalAndCloud
//
//  Created by m on 11/1/23.
//

import SwiftUI
import CoreData


/*
 Next time see if you can write some local data and then verify that its not actually uploaded
 to the cloud
 */
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Word.sortNumber, ascending: true)],
        animation: .default)
    private var words: FetchedResults<Word>
    
    var body: some View {
        VStack{
            
            Button(action: deleteEverythingOnCloud){
                Label("Delete Cloud", systemImage: "minus")
            }
            Button(action: addWordsToCloud) {
                Label("Add Cloud", systemImage: "plus")
            }
            Button(action: addWordsToLocal) {
                Label("Add Local", systemImage: "plus")
            }
            List {
                
                ForEach(words) { w in
                    HStack{
                        Text(w.word ?? "")
                        Text(w.definition ?? "")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                }
                ToolbarItem {
                }
            }
        }
    }
    
}
extension ContentView {
    //use when you want a fresh start
    func deleteEverythingOnCloud(){
        self.words.forEach(viewContext.delete)
        try! viewContext.save()
    }
    func addWordsToLocal(){
        if try! viewContext.fetch(Word.fetchRequest()).count <= 0{
            for i in 0..<10 {
                let newItem = Word()
                newItem.definition = "Definiton for word \(i)"
                newItem.sortNumber = Int64(i)
                newItem.word = "Word \(i)" //merging on this
//                newItem.status = 1
                do {
                    viewContext.assign(newItem, to: viewContext.persistentStoreCoordinator!.persistentStores[1])
                    try! viewContext.save()
                }
            }
        }
    }
    /// Adds 10 words to the cloud if there aren't already 10 words there
    func addWordsToCloud(){
        if try! viewContext.fetch(Word.fetchRequest()).count <= 0 {
            for i in 0..<10 {
                let newItem = Word(context: viewContext)
//                newItem.definition = "Definiton for word \(i)"
//                newItem.sortNumber = Int64(i)
                newItem.word = "Word \(i)" //merging on this
                newItem.status = 1
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }

        
    }
    func deleteLocal(){
        
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
