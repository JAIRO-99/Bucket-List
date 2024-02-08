//
//  ContentView.swift
//  BucketList
//
//  Created by New on 31/01/24.
//
import MapKit
//import LocalAuthentication
import SwiftUI
//uju

/*
struct User:Comparable, Identifiable{
    let id = UUID()
    var firtsName: String
    var lastName: String
    
    static func <(lhs: User, rhs: User) -> Bool{
        lhs.lastName < rhs.firtsName
    }
}
*/
/*
struct Location: Identifiable{
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}
*/
struct ContentView: View {
    /*
     /*
      let users = [
      User(firtsName: "Jiaro", lastName: "lAURENTE"),
      User(firtsName: "asd", lastName: "Asd"),
      User(firtsName: "Jaja", lastName: "eje")
      ].sorted()
      */
     /*
      let locations = [
      Location(name: "Buckingham", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
      Location(name: "Tower of london", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
      ]
      @State private var position = MapCameraPosition.region(
      MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -13.40985, longitude: -76.13235), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
      )
      */
     
     @State private var isUnlocked = false
     */
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 56,longitude: -3),
    span: MKCoordinateSpan(latitudeDelta: 10,longitudeDelta: 10)
    ))
    @State private var viewModel = ViewModel()
    var body: some View {
        /*
         /*
          List(users){user in
          Text("\(user.firtsName),\(user.lastName)")
          }
          */
         /*
          VStack{
          Map{
          ForEach(locations){ location in
          Annotation(location.name, coordinate: location.coordinate){
          Text(location.name)
          .font(.headline)
          .padding()
          .background(.green.gradient)
          .clipShape(.capsule)
          }
          .annotationTitles(.hidden)
          }
          }
          
          /*
           HStack(spacing: 50){
           Button("Lima"){
           position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -77.0282400, longitude: 12.0431800), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
           }
           Button("Tokyo"){
           position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
           }
           }
           */
          }
          */
         VStack{
         if isUnlocked{
         Text("Unlocked")
         }else{
         Text("Locked")
         }
         }
         .onAppear(perform:authenticate)
         }
         func authenticate(){
         let context = LAContext()
         var error: NSError?
         
         if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
         let reason = "We need to unlock your data."
         
         context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){success, authenticationError in
         if success{
         isUnlocked = true
         }else{
         //there was a problem
         }
         }
         }else{
         //no biometrics
         }
         }
         */
        
        if viewModel.isUnlocked{
            MapReader{ proxy in
                Map(initialPosition: startPosition){
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate){
                            Image(systemName: "figure.wave")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blue)
                                .frame(width: 44,height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture{
                                    viewModel.selectedPlace = location
                                }
                            
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local){
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace){place in
                    EditView(location: place){
                        viewModel.update(location: $0)
                    }
                }
            }
        }else{
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .font(.headline)
                .clipShape(.capsule)
        }
    }
}
#Preview {
    ContentView()
}
