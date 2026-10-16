import Flutter
import EventKit
import EventKitUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, EKEventEditViewDelegate {
  private var calendarEventStore: EKEventStore?
  private var calendarResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "healthy_app/calendar",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        guard call.method == "createEvent" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.presentCalendarEvent(call.arguments, result: result)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func presentCalendarEvent(_ arguments: Any?, result: @escaping FlutterResult) {
    guard let values = arguments as? [String: Any],
          let title = values["title"] as? String,
          let startMillis = values["startMillis"] as? Int64,
          let endMillis = values["endMillis"] as? Int64,
          let controller = window?.rootViewController else {
      result(FlutterError(code: "invalid_event", message: "Missing calendar event fields", details: nil))
      return
    }

    let store = EKEventStore()
    calendarEventStore = store
    calendarResult = result
    let accessResult: (Bool, Error?) -> Void = { [weak self] granted, error in
      DispatchQueue.main.async {
        guard let self else { return }
        guard granted else {
          self.finishCalendarRequest(with: FlutterError(
            code: "calendar_unavailable",
            message: error?.localizedDescription ?? "Calendar access was not granted",
            details: nil
          ))
          return
        }

        let event = EKEvent(eventStore: store)
        event.title = title
        event.location = values["location"] as? String
        event.notes = values["description"] as? String
        event.startDate = Date(timeIntervalSince1970: Double(startMillis) / 1000)
        event.endDate = Date(timeIntervalSince1970: Double(endMillis) / 1000)
        event.calendar = store.defaultCalendarForNewEvents

        let editor = EKEventEditViewController()
        editor.eventStore = store
        editor.event = event
        editor.editViewDelegate = self
        controller.present(editor, animated: true)
      }
    }
    if #available(iOS 17.0, *) {
      store.requestFullAccessToEvents(completion: accessResult)
    } else {
      store.requestAccess(to: .event, completion: accessResult)
    }
  }

  func eventEditViewController(
    _ controller: EKEventEditViewController,
    didCompleteWith action: EKEventEditViewAction
  ) {
    controller.dismiss(animated: true)
    finishCalendarRequest(with: action == .saved ? "saved" : "cancelled")
    calendarEventStore = nil
  }

  private func finishCalendarRequest(with value: Any?) {
    let result = calendarResult
    calendarResult = nil
    result?(value)
  }
}
