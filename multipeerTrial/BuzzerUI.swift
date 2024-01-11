import SwiftUI
import AVFoundation

struct BuzzerUI: View {
    @EnvironmentObject var screenEnvironmentObject: ScreenEnvironmentObject
    @State var animation: Bool = true // Start animation initially
    @State var isButtonDisabled: Bool = false
    @State private var showingAlert = false
    let multipeerService = MultipeerService.shared
    
    var body: some View {
       VStack(spacing: 30) {
           HStack {
               Spacer()
               Button {
                   showingAlert = true
               } label: {
                   Image(systemName: "xmark.circle")
                       .resizable()
                       .frame(width: 30, height: 30)
                       .foregroundColor(.accentColor)
               }
               .padding(.horizontal)
               .padding(.top)
               .alert("Are you sure you want to quit?", isPresented: $showingAlert) {
                   Button("No", role: .cancel) {
                   }
                   Button("Yes", role: .none) {
                       multipeerService.session?.disconnect()
                       screenEnvironmentObject.screenToDisplay = 0
                   }
               }
           }

           Spacer()
           Text("PRESS THE BUZZER")
               .font(.headline)
               .opacity(animation ? 1 : 0)
               .animation(Animation.easeInOut(duration: 1.5), value: animation)
               .foregroundColor(.accentColor)

           Button(action: {
               self.multipeerService.send()
               isButtonDisabled = true
               playSound(sound: "BuzzerSound", type: "mp3")
           }, label: {
               ZStack {
                   Circle()
                       .stroke(Color.white.opacity(0.9), lineWidth: 10)
                       .overlay(
                           Circle()
                               .fill(isButtonDisabled ? LinearGradient(gradient: Gradient(colors: [Color.gray, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing) :  LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                       )
                       .frame(width: 260, height: 260, alignment: .center)
                       .padding()

                   Image(systemName: "speaker.wave.3.fill")
                       .scaleEffect(animation ? (isButtonDisabled ? 1 : 1.5) : 1)
                       .animation(
                           Animation
                               .easeOut(duration: 1.5)
                               .repeatForever(),
                           value: animation && !isButtonDisabled
                       )
                       .foregroundColor(.white)
               }
               .scaleEffect(isButtonDisabled ? 1.1 : 1)
               .animation(
                   Animation
                       .easeOut(duration: 1.5)
                       .repeatForever(),
                   value: (isButtonDisabled ? false : true )
               )
           })
           .onAppear() {
              //animation = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   animation = true
               }
               multipeerService.buzzerDelegate = self
           }
           .disabled(isButtonDisabled)
           .animation(nil, value: isButtonDisabled)
           .animation(Animation.easeInOut(duration: 1.5), value: animation && !isButtonDisabled)

           Spacer()
       }
   }
}

struct BuzzerUI_Previews: PreviewProvider {
    static var previews: some View {
        BuzzerUI()
    }
}

extension BuzzerUI: BuzzerScreenDelegate {
    func permissionChanged(manager: MultipeerService) {
        isButtonDisabled = false
    }
}
