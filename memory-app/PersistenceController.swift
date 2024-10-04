//
//  PersistenceTes.swift
//  ProvaConceitoApp
//
//  Created by Leticia Bezerra on 27/09/24.
//

import CoreData
import CloudKit
import SwiftUI
import UIKit
import PhotosUI

struct PersistenceController {
    static let shared = PersistenceController()
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<1 {
            let newItem = Memory(context: viewContext)
            newItem.idmemory = UUID()
            newItem.titulo = "Novo título"
            newItem.descricao = "Nova descrição"

            if let imagem = UIImage(systemName: "star"), let imagemData = imagem.pngData() {
                let midia = Midia(context: viewContext)
                midia.arquivo = imagemData
                midia.tipo = "Imagem"
                midia.memory = newItem
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erro não solucionado \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Memory")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
//        container.persistentStoreDescriptions.first?.cloudKitContainerOptions?.databaseScope = .public
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if (error as NSError?) != nil {
                
            }
        })
    
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
