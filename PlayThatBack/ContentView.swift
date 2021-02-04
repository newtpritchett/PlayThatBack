//
//  ContentView.swift
//  PlayThatBack
//
//  Created by trevor on 2/4/21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    var body: some View {
        
        Home()
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var record = false
    @State var session : AVAudioSession!
    @State var recorder : AVAudioRecorder!
    @State var alert = false
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                Button(action: {
                    self.record.toggle()
                }) {
                    
                    ZStack{
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 70, height: 70)
                        
                        if self.record{
                            
                            Circle()
                                .stroke(Color.white,lineWidth:6)
                                .frame(width: 85, height: 85)
                            
                        }
                    }
                }
                .padding(.vertical, 25)
            }
            .navigationBarTitle("Record Audio")
        }
        .alert(isPresented: self.$alert, content: {
            Alert(title: Text("Error"), message: Text("Enable Access"), dismissButton: <#T##Alert.Button?#>)
        })
        .onAppear {
            do{
                
                //initializing
                
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                //requesting
                //this requires microphone usage description in info.plist
                
                self.session.requestRecordPermission{ (status) in
                    
                    if !status{
                        
                        //error message
                        self.alert.toggle()
                    }
                }
            }catch {
                
                print(error.localizedDescription)
                
            }
        }
        
    }
}
