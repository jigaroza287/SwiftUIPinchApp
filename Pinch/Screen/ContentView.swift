//
//  ContentView.swift
//  Pinch
//
//  Created by Jigar Oza on 24/08/24.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Property
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    @State private var pageIndex: Int = 0
    
    let pages: [Page] = pageData
    
    //MARK: - Function
    func resetImageState() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex].imageName
    }
    
    //MARK: - Content
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                //MARK: - Page Image
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: - 1. Double Tap Gesture
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    })//: Double Tap Gesture
                //MARK: - 2. Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = gesture.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )//: Drag Gesture
                //MARK: - 3. Magnification Gesture
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 0.4)) {
                                    imageScale = value
                                }
                            })
                            .onEnded({ value in
                                if value > 5 {
                                    imageScale = 5
                                } else if value < 1 {
                                    resetImageState()
                                }
                            })
                    )//: Magnification Gesture
            } //: ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            //MARK: - Info Panel
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            
            //MARK: - Controls
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        //: Scale down
                        Button {
                            withAnimation(.spring()) {
                                if imageScale - 1 > 1 {
                                    imageScale -= 1
                                } else {
                                    imageScale = 1
                                }
                            }
                        }label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        //: Reset
                        Button {
                            resetImageState()
                        }label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        //: Scale up
                        Button {
                            withAnimation(.spring()) {
                                if imageScale + 1 < 5 {
                                    imageScale += 1
                                } else {
                                    imageScale = 5
                                }
                            }
                        }label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                        
                    }//: Controls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30)
            }
            
            //MARK: - Drawer
            .overlay(alignment: .topTrailing) {
                HStack(spacing: 12) {
                    //MARK: - Drawer Handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    //MARK: - Drawer Thumbnail
                    ForEach(pages) { page in
                        Image(page.thumbnailImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    
                    Spacer()
                } //: Drawer
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20: 215)
            }
        } //: Navigation Stack
    }
}

#Preview {
    ContentView()
}
