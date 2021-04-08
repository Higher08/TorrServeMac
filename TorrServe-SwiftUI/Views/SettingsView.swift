//
//  SettingsView.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 03.04.2021.
//

import SwiftUI
import Alamofire

struct User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

struct SettingsView: View {
    
    @State var settings: BTSets = BTSets()
    @State var retrackers: Int = 0
    @State private var user = User()
    
    var body: some View {
        ScrollView {
            Form {
                Group {
                    Text("Размер кеша").font(.callout)
                    IntField(text: "Размер кеша", int: $settings.CacheSize)
                        .frame(width: 250)
                    
                    Toggle(isOn: $settings.PreloadBuffer, label: {
                        Text("Буфер предзагрузки")
                    }).padding(.vertical)
                    
                    Text("Reader readahead").font(.callout)
                    IntField(text: "Reader readahead", int: $settings.ReaderReadAHead)
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Режим ретрекеров").font(.callout)
                    Picker(selection: $retrackers, label: EmptyView()) {
                        Text("Не добавлять").tag(0)
                        Text("Добавлять").tag(1)
                        Text("Удалять").tag(2)
                        Text("Заменять").tag(3)
                    }.frame(width: 200)
                    .padding(.bottom)
                    Text("Время отключение торрентов").font(.callout)
                    IntField(text: "Время отключение торрентов", int: $settings.TorrentDisconnectTimeout)
                        .frame(width: 250)
                        .padding(.bottom)
                }
                Group {
                    Toggle(isOn: $settings.EnableIPv6, label: {
                        Text("Включить IPv6")
                    })
                    Toggle(isOn: $settings.ForceEncrypt, label: {
                        Text("Принудительно шифровать")
                    })
                    Toggle(isOn: $settings.DisableTCP, label: {
                        Text("Отключить TCP")
                    })
                    Toggle(isOn: $settings.DisableUTP, label: {
                        Text("Отключить UTP")
                    })
                    Toggle(isOn: $settings.DisableUPNP, label: {
                        Text("Отключить UPNP")
                    })
                    Toggle(isOn: $settings.DisableDHT, label: {
                        Text("Отключить DHT")
                    })
                    Toggle(isOn: $settings.DisablePEX, label: {
                        Text("Отключить PEX")
                    })
                }
                Group {
                    Text("Ограничение скорости скачивания").font(.callout)
                        .padding(.top)
                    IntField(text: "Ограничение скорости скачивания", int: $settings.DownloadRateLimit)
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Ограничение скорости загрузки").font(.callout)
                    IntField(text: "Ограничение скорости загрузки", int: $settings.UploadRateLimit)
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Лимит подключений").font(.callout)
                    IntField(text: "Лимит подключений", int: $settings.ConnectionsLimit)
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Лимит DHT подключений").font(.callout)
                    IntField(text: "Лимит DHT подключений", int: $settings.DhtConnectionLimit)
                        .frame(width: 250)
                        .padding(.bottom)
                    Text("Peers listen port").font(.callout)
                    IntField(text: "Peers listen port", int: $settings.PeersListenPort)
                        .frame(width: 250)
                        .padding(.bottom)
                }
                Button(action: {
                        ServerNetworkManager().setSettings(settings: settings) { (error) in
                            print(error)
                }
                }) {
                    Text("Сохранить")
                }
                Button(action: {
                    ServerNetworkManager().defSettings { (error) in
                        if error == nil {
                            ServerNetworkManager().getSettings { (newSettings, error) in
                                if error == nil {
                                    self.settings = newSettings ?? BTSets()
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Сбросить к настройкам по умолчанию")
                })
            }
        }
        .onAppear() {
            ServerNetworkManager().getSettings { (settings, error) in
                if error == nil {
                    print("succes")
                    self.settings = settings ?? BTSets()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

func ??<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
    return Binding(get: {
        binding.wrappedValue ?? fallback
    }, set: {
        binding.wrappedValue = $0
    })
}

struct IntField: View {
    @State var text: String
    @Binding var int: Int
    @State private var intString: String  = ""
    var body: some View {
        return TextField(text, text: $intString)
            .onChange(of: intString) { value in
                if let i = Int(value) { int = i }
                else { intString = "\(int)" }
            }
            .onChange(of: int) { (value) in
                if String(value) != intString {
                    intString = String(value)
                }
            }
            .onAppear(perform: {
                intString = "\(int)"
            })
    }
}
