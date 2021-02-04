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
    //fetch Audios
    @State var audios : [URL] = []
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                List(self.audios,id: \.self){i in
                    
                    // printing only file name
                    Text(i.relativeString)
                }
                
                Button(action: {
                    
                    do {
                        
                        if self.record {
                            
                            //already Started Recording Means stoppping and saving
                            self.recorder.stop()
                            self.record.toggle()
                            
                            //updating data for every rcd
                            self.getAudios()
                            return
                            
                        }
                        
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        
                        //same file name
                        //so we're updating based on audio count
                        
                        let filName = url.appendingPathComponent("myRcd\(self.audios.count + 1).m4a")
                        
                        let settings = [
                            
                            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey : 12000,
                            AVNumberOfChannelsKey : 1,
                            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                            
                        ]
                        
                        self.recorder = try AVAudioRecorder(url: filName, settings: settings)
                        self.recorder.record()
                        self.record.toggle()
                        
                    } catch {
                        
                        print(error.localizedDescription)
                    }
                    
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
            Alert(title: Text("Error"), message: Text("Enable Access"))
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
                    else{
                        //if permission granted means fetching all
                        self.getAudios()
                    }
                }
            }catch {
                
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    func getAudios() {
        
        do{
            
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            //updatng means remove all old data
            
            self.audios.removeAll()
            
            for i in result{
                
                self.audios.append(i)
            }
        }
        catch{
            
            print(error.localizedDescription)
        }
    }
}
