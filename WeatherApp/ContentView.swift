//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mohammed Elnaggar on 14/12/2025.
//

import CoreData
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    if let timestamp = item.timestamp {
                        NavigationLink {
                            Text("\(L10n.itemAt) \(timestamp, formatter: itemFormatter)")
                        } label: {
                            Text(timestamp, formatter: itemFormatter)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label(L10n.addItem, systemImage: "plus")
                    }
                }
            }
            Text(L10n.selectAnItem)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping
                // application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("\(L10n.unresolvedError) \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping
                // application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("\(L10n.unresolvedError) \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
