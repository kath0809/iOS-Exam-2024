//
//  SplashScreen.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var rotation: Double = 0
    @State private var text1: CGFloat = -300
    @State private var text2: CGFloat = 500

    var body: some View {
        if isActive {
            MainLayoutView()
        } else {
            ZStack {
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Globe Wire")
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
