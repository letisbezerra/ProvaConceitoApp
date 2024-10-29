//
//  ContentView.swift
//  memory-app
//
//  Created by Beatriz Peixoto on 04/10/24.
//

import CoreData
import CloudKit
import SwiftUI
import UIKit
import PhotosUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Memory.entity(), sortDescriptors: [], predicate: NSPredicate(format: "descricao == %@", "Teste"), animation: nil
    )
    private var filterMemories: FetchedResults<Memory>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Memory.data, ascending: true)],
        animation: .default)
    private var memories: FetchedResults<Memory>
    
    @State private var titulo: String = ""
    @State private var descricao: String = ""
    @State private var data = Date()
    @State private var imagens: [Data] = []
    @State private var item: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack {
                        //Cria a memória
                        TextField("Título", text: $titulo)
                        TextField("Descricao", text: $descricao)
                        DatePicker("Data", selection: $data, displayedComponents: .date)
                        PhotosPicker(selection: $item, matching: .images) {
                            Text("Selecione uma imagem")
                        }
                        .onChange(of: item) {
                            Task {
                                do {
                                    guard let imagemData = try await item?.loadTransferable(type: Data.self)
                                    else { return }
                                    await MainActor.run {
                                        imagens.append(imagemData)
                                    }
                                }
                            }
                        }
                        ForEach(Array(imagens.enumerated()), id: \.offset) { (_ , data) in
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .padding()
                            }
                        }
                        //arquivo de audio
                        //arquivo de video
                        
                        Button(action: addMemory) {
                            Text("Salvar")
                        }
                    }
                    .buttonStyle(.borderless)
                }
                
                //Exibe a memória
                ForEach(filterMemories) { memoryFile in
//                    Text(memoryFile.description)
                    VStack (alignment: .leading) {
                        if let titulo = memoryFile.titulo {
                            Text(titulo)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
//
                        if let descricao = memoryFile.descricao {
                            Text(descricao)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .padding(.bottom, 5)
                        }

                        if let data = memoryFile.data {
                            Text(data.formatted(date: .numeric, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
//                        //Text(memoryFile.titulo.description)
                        if let midia = memoryFile.midia as? Set<Midia> {
                            let midias = Array(midia.enumerated()) // [(Int, Midia)]
                            HStack {
                                ForEach(midias, id: \.offset) { (_, midia) in
                                    if midia.tipo == "imagem" {
                                        if let arquivo = midia.arquivo, let uiImage = UIImage(data: arquivo) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 150)
                                                .padding()
                                        }
                                    }
                                }
                            }
                        } else {
                            Label("Sem Midia", systemImage: "star")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Crie uma memória")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: addMemory) {
                        Label("Adicionar memória", systemImage: "plus")
                    }
            )
            .toolbar {
                
            }
//            .onAppear {
//
//                for memory in memories {
//                    viewContext.delete(memory)
//                }
//
//                do {
//                    try viewContext.save()
//                } catch {
//                    print(error)
//                }
//
//            }
        }
    }
    
    private func addMemory() {
        withAnimation {
            let newItem = Memory(context: viewContext)
            newItem.titulo = titulo
            newItem.descricao = descricao
            newItem.data = data
            
            for imagem in imagens {
                let midia = Midia(context: viewContext)
                midia.tipo = "imagem"
                midia.arquivo = imagem
                midia.memory = newItem
            }
            
            do {
                try viewContext.save()
                //Limpa os campos após salvar
                titulo = ""
                descricao = ""
                data = Date()
                imagens = []
    
            } catch {
                let nsError = error as NSError
                fatalError("Erro não solucionado \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
    
//    private func deleteMemory(offset: IndexSet) {
//        withAnimation {
//            guard let newItem = Memory(context: viewContext)
//            offset.map { memories[$0] }.forEach(viewContext.delete)
//
//            let newItem = Memory(context: viewContext)
//            newItem.titulo = titulo
//            newItem.descricao = descricao
//            newItem.data = data
//            newItem.midia = Midia.imagem
//
//            // Verifica se existem imagens e salva no CoreData
////            if let imagemData = selectedImagem {
////                newItem.imagem = imagemData
////            }
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Erro não solucionado \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }


//private let editMemory: Memory = {
//    let formatter = Memory()
//    formatter.titulo = titulo
//    formatter.descricao = descricao
//    formatter.data = data
//
//    if let imageData = sel ectedImagem  {
//        formatter.imagem = imagemData
//    }
//
//    return formatter
//}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
