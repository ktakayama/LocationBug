//
//  ContentView.swift
//  LocationBug
//
//  Created by Kyosuke Takayama on 2023/07/11.
//

import SwiftUI
import EventKit
import EventKitUI

struct ContentView: View {
    @State private var isShowingEventController = false
    @State private var event: EKEvent?
    let eventStore = EKEventStore()

    var body: some View {
        VStack {
            Spacer()

            Button(action: {
                requestAccessToCalendar {
                    prepareNormalEvent { event in
                        self.event = event
                        self.isShowingEventController = true
                    }
                }
            }) {
                Text("Normal event")
            }
            .sheet(isPresented: $isShowingEventController, content: {
                EventViewControllerWrapper(event: self.event)
            })

            Spacer()

            Button(action: {
                requestAccessToCalendar {
                    prepareBrokenEvent { event in
                        self.event = event
                        self.isShowingEventController = true
                    }
                }
            }) {
                Text("Broken event")
            }
            .sheet(isPresented: $isShowingEventController, content: {
                EventViewControllerWrapper(event: self.event)
            })

            Spacer()

        }
        .padding()
    }

    private func requestAccessToCalendar(completion: @escaping () -> Void) {
        eventStore.requestFullAccessToEvents { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    completion()
                }
            } else if let error = error {
                print("Failed to request access: \(error)")
            }
        }
    }

    private func prepareNormalEvent(completion: @escaping (EKEvent?) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = "normal event"
        event.location = "Apple Store, Union Square 300 Post St, San Francisco, CA  94108, United States"
        DispatchQueue.main.async {
            completion(event)
        }
    }

    private func prepareBrokenEvent(completion: @escaping (EKEvent?) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = "broken event"
        event.location = "Apple Store, Union Square 300 Post St, San Francisco, CA  94108, United States"
        let structureLocation = EKStructuredLocation(title: "Apple Store, Union Square 300 Post St, San Francisco, CA  94108, United States")
        structureLocation.geoLocation = CLLocation(latitude: 37.78874470, longitude: -122.40715290)
        structureLocation.radius = 70.587316
        event.structuredLocation = structureLocation

        DispatchQueue.main.async {
            completion(event)
        }
    }
}

struct EventViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    var event: EKEvent?
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let eventController = EKEventViewController()
        eventController.event = event
        eventController.delegate = context.coordinator
        //        print(event?.location)
        //        print(event?.structuredLocation)
        return UINavigationController(rootViewController: eventController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, EKEventViewDelegate {
        func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
            controller.dismiss(animated: true)
        }
    }
}
