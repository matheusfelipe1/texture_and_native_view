import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private let getTextureId = "getTextureId"
    private let closeTextureView = "closeTextureView"
    private let channelName = "com.example.texture_and_native_view"
    
    private var videoTextView: TextureView?
    private var pluginRegistrar: FlutterPluginRegistrar?
    private let nativeViewFactoryName = "com.example.native_view_factory_name"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let textureChannel = FlutterMethodChannel(
        name: channelName,
        binaryMessenger: controller.binaryMessenger
      )
      
      self.pluginRegistrar = self.registrar(forPlugin: self.channelName)
      self.appChannelSettings(textureChannel)
      
      if let messenger =  self.pluginRegistrar?.messenger() {
          let factory = NativeViewFactory(messenger: messenger)
          self.pluginRegistrar?.register(factory, withId: nativeViewFactoryName)
      }
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    private func appChannelSettings(_ textureChannel: FlutterMethodChannel) -> Void {
        textureChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
                case self.getTextureId:
                self.startVideoPlayer(args: call.arguments, result: result)
                
            case self.closeTextureView:
                self.stopVideoPlayer()
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func startVideoPlayer(args: Any?, result: @escaping FlutterResult) {
        if let args = args as? [String: Any?], let path = args["path"] as? String {
            let url = URL(fileURLWithPath: path)
            
            if let textureRegistry = self.pluginRegistrar?.textures()  {
                self.videoTextView = TextureView(
                    url: url,
                    result: result,
                    textureRegistry: textureRegistry
                )
            }
        }
    }
    
    private func stopVideoPlayer() {
        self.videoTextView?.stop()
        self.videoTextView = nil
    }
}

