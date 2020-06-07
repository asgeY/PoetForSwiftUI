//
//  HelloData-Screen.swift
//  Poet
//
//  Created by Stephen E. Cotner on 6/2/20.
//  Copyright © 2020 Steve Cotner. All rights reserved.
//

import Combine
import SwiftUI

struct HelloData {}

extension HelloData {
    struct Screen: View {
        
        typealias Action = Evaluator.Action
        
        let evaluator: Evaluator
        let translator: Translator
        
        init() {
            evaluator = Evaluator()
            translator = evaluator.translator
        }
        
        @State var navBarHidden: Bool = true
        
        var body: some View {
            ZStack {
                Hideable(isShowing: translator.shouldShowMusicResults) {
                    ScrollView() {
                        Spacer().frame(height: 50)
                        HStack {
                            Spacer()
                            ObservingTextView(self.translator.musicType)
                                .font(FontSystem.largeTitle)
                            Spacer()
                        }
                        
                        Spacer().frame(height: 20)
                        
                        MusicResultsView(musicResults: self.translator.musicResults)
                    }
                }
                
                Hideable(isShowing: translator.shouldShowLoadButton) {
                    VStack(spacing: 0) {
                        Spacer()
                            Button(action: {
                                self.evaluator.evaluate(Action.loadMusic(.albums))
                            }) {
                                Text("Load Albums")
                                    .foregroundColor(.primary)
                                    .font(Font.headline)
                                    .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                                    .background(Capsule().fill(Color.primary.opacity(0.04)))
                            }
                        Spacer()
                    }
                }
                
                Hideable(isShowing: translator.shouldShowMusicResults) {
                    VStack {
                        HStack {
                            VStack {
                                Spacer().frame(height: 16)
                                HStack(spacing: 20) {
                                    
                                    // Albums button
                                    
                                    Button(action: {
                                        self.evaluator.evaluate(Action.loadMusic(.albums))
                                    }) {
                                        Image(systemName: "rectangle.stack")
                                    }
                                    
                                    // Hot Tracks button
                                    
                                    Button(action: {
                                        self.evaluator.evaluate(Action.loadMusic(.hotTracks))
                                    }) {
                                        Image(systemName: "flame")
                                    }
                                    
                                    // New Releases button
                                    
                                    Button(action: {
                                        self.evaluator.evaluate(Action.loadMusic(.newReleases))
                                    }) {
                                        Image(systemName: "music.note")
                                    }
                                    
                                    Spacer()
                                }
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .padding(EdgeInsets(top: 12, leading: 30, bottom: 14, trailing: 0))
                            Spacer()
                        }
                        .frame(height: 54)
                        .background(Color(UIColor.systemBackground))
                        Spacer()
                    }
                }
                
                VStack {
                    DismissButton(orientation: .right)
                    Spacer()
                }
                
                AlertPresenter(translator.alert)
                BusyPresenter(translator.busy)
            }.onAppear {
                self.evaluator.viewDidAppear()
                self.navBarHidden = true
            }
                
            // MARK: Hide Navigation Bar
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.navBarHidden = true
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(self.navBarHidden)
        }
    }
}

struct MusicResultsView: View {
    @ObservedObject var musicResults: ObservableArray<MusicResult>
    
    var body: some View {
        return VStack {
            ForEach(musicResults.array, id: \.id) { result in
                return VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        
                        ImageFromURL(url: result.artworkUrl100, size: 100)
                            .frame(width: 100, height: 100)
                        
                        Spacer().frame(width: 20)
                        VStack {
                            HStack {
                                Text(result.name)
                                    .font(Font.headline)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            
                            HStack {
                                Text(result.artistName ?? "")
                                    .font(Font.subheadline)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    Spacer().frame(height: 20)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
    }
}

struct ImageFromURL: View {
    let url: URL
    let size: CGFloat
    
    @State var imageData: Data?
    
    var body: some View {
        return VStack {
            Rectangle()
                .fill(Color.primary.opacity(0.1))
            if imageData != nil {
                VStack {
                    AnyView(EmptyView())
                    if UIImage(data: imageData!) != nil {
                        AnyView(
                            Image(uiImage: UIImage(data: imageData!)!)
                                .resizable()
                                .frame(width: size, height: size)
                        )
                    }
                }
            }
        }.onAppear {
            URLSession.shared.dataTask(with: self.url) { (data, response, error) in
                if let data = data {
                    self.imageData = data
                }
            }.resume()
        }
        .onDisappear {
            
        }
    }
}
