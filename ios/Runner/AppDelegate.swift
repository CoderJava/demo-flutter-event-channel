import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var timer: Timer?
    private var counter = 0
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let eventChannel = FlutterEventChannel(name: "timerEventChannel", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: "increaseCounter", userInfo: nil, repeats: true)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func increaseCounter() {
        counter += 1
        eventSink?(counter)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        timer?.invalidate()
        eventSink = nil
        return nil
    }
}
