//
//  ContentView.swift
//  BucketList
//
//  Created by New on 31/01/24.
//
import MapKit
//import LocalAuthentication
import SwiftUI

struct ContentView: View {
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 56,longitude: -3),
    span: MKCoordinateSpan(latitudeDelta: 10,longitudeDelta: 10)
    ))
    @State private var viewModel = ViewModel()
    var body: some View {
        
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
