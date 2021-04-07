//
//  SettingsView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 03.04.2021.
//

import SwiftUI
import Alamofire

struct SettingsView: View {
    var body: some View {
        ScrollView {
            Form {
                Group {
                    Text("Размер кеша").font(.callout)
                    TextField("Размер кеша", text: .constant("96"))
                        .frame(width: 250)
                    
                    Toggle(isOn: .constant(true), label: {
                        Text("Буфер предзагрузки")
                    }).padding(.vertical)
                    
                    Text("Reader readahead").font(.callout)
                    TextField("Reader readahead", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Режим ретрекеров").font(.callout)
                    Picker(selection: .constant(1), label: EmptyView()) {
                        Text("Не добавлять").tag(1)
                        Text("Добавлять").tag(2)
                        Text("Удалять").tag(3)
                        Text("Заменять").tag(2)
                    }.frame(width: 200)
                    .padding(.bottom)
                    Text("Время отключение торрентов").font(.callout)
                    TextField("Время отключение торрентов", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                }
                Group {
                    Toggle(isOn: .constant(true), label: {
                        Text("Включить IPv6")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Принудительно шифровать")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Отключить TCP")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Отключить UTP")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Отключить UPNP")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Отключить DHT")
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Отключить PEX")
                    })
                }
                Group {
                    Text("Ограничение скорости скачивания").font(.callout)
                        .padding(.top)
                    TextField("Ограничение скорости скачивания", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Ограничение скорости загрузки").font(.callout)
                    TextField("Ограничение скорости загрузки", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Лимит подключений").font(.callout)
                    TextField("Лимит подключений", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Лимит DHT подключений").font(.callout)
                    TextField("Лимит DHT подключений", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Peers listen port").font(.callout)
                    TextField("Peers listen port", text: .constant("96"))
                        .frame(width: 250)
                        .padding(.bottom)
                }
                Button(action: {}, label: {
                    Text("Сохранить")
                })
                Button(action: {}, label: {
                    Text("Сбросить к настройкам по умолчанию")
                })
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
