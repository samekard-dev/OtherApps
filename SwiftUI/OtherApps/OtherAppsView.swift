//
//  OtherAppsView.swift
//  OtherApps
//
//  Created by MH on 2024/03/10.
//

import SwiftUI

fileprivate let appTable = "OtherApps"
fileprivate let storeTable = "OtherAppsGeneral"

fileprivate let appData = [
    AppData(id: 408709785, image: "KOYUMEISHI P", dir: .portrait, description: "KM"),
    AppData(id: 409203825, image: "KOYUMEISHI L", dir: .landscape, description: "KM"),
    AppData(id: 409201541, image: "KOYUMEISHI P", dir: .portrait, description: "KM"),
    AppData(id: 409183694, image: "KOYUMEISHI L", dir: .landscape, description: "KM"),
]

fileprivate enum ImageDirection {
    case portrait
    case landscape
}

fileprivate struct AppData {
    let id: Int
    let image: String
    let dir: ImageDirection
    let description: LocalizedStringKey
}

struct OtherAppsView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40.0) {
                ForEach(appData, id: \.id) { data in
                    if data.dir == .portrait {
                        HStack(spacing: 20.0) {
                            Image(data.image, bundle: nil)
                                .resizable()
                                .interpolation(.high)
                                .scaledToFit()
                                .frame(maxWidth: 120.0)
                            VStack {
                                Text(data.description, tableName: appTable)
                                Link(String(localized: "Store", table: storeTable),
                                     destination: URL(string: "https://apps.apple.com/app/id\(data.id)")!)
                                .frame(minHeight: 60)
                            }
                        }
                    }
                    if data.dir == .landscape {
                        VStack(spacing: 20.0) {
                            Image(data.image)
                                .resizable()
                                .interpolation(.high)
                                .scaledToFit()
                                .frame(maxHeight: 140.0)
                            HStack{
                                Text(data.description, tableName: appTable)
                                Link(String(localized: "Store", table: storeTable),
                                     destination: URL(string: "https://apps.apple.com/app/id\(data.id)")!)
                                .frame(minWidth: 80)
                            }
                        }
                    }
                }
                .padding()
                .background { 
                    Color.gray.opacity(0.08)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                }
                .padding(.horizontal)
                .frame(maxWidth: 500.0)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    OtherAppsView()
}

