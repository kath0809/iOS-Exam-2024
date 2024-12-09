//
//  SplashScreen.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive = false
    @State var rotation: Double = 0
    @State var text1: CGFloat = -300
    @State var text2: CGFloat = 500
    @State var showNewsImages = false
    
    var body: some View {
        if isActive {
            MainLayoutView()
        } else {
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("GlobeWire")
                        .font(.largeTitle)
                        .foregroundStyle(.splashScreen)
                        .offset(y: text1)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.5)) {
                                text1 = 0
                            }
                        }
                        .padding(.bottom, 20)
                    
                    Image("SplashImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(rotation))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isActive = true
                            }
                        }
                    
                    Text("First with all the latest news")
                        .font(.title)
                        .foregroundStyle(.splashScreen)
                        .offset(y: text2)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.5).delay(0.5)) {
                                text2 = 0
                            }
                        }
                        .padding(.top, 20)
                    
                    HStack(alignment: .center, spacing: 30) {
                        Image("News1")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaleEffect(showNewsImages ? 1 : 0.5)
                            .opacity(showNewsImages ? 1 : 0)
                            .animation(.easeOut(duration: 1).delay(0.6), value: showNewsImages)
                        
                        Image("News2")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaleEffect(showNewsImages ? 1 : 0.5)
                            .opacity(showNewsImages ? 1 : 0)
                            .animation(.easeOut(duration: 1).delay(0.7), value: showNewsImages)
                        
                        Image("News3")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .scaleEffect(showNewsImages ? 1 : 0.5)
                            .opacity(showNewsImages ? 1 : 0)
                            .animation(.easeOut(duration: 1).delay(0.7), value: showNewsImages)
                        
                        Image("News4")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .scaleEffect(showNewsImages ? 1 : 0.5)
                            .opacity(showNewsImages ? 1 : 0)
                            .animation(.easeOut(duration: 1).delay(0.8), value: showNewsImages)
                    }
                    .padding(.top, 100)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showNewsImages = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
