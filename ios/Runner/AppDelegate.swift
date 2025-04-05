import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private let getTextureId = "getTextureId"
    private let closeTextureView = "closeTextureView"
    private let channelName = "com.example.texture_and_native_view"
    
    private var pluginRegistrar: FlutterPluginRegistrar?
    private var videoTextView: TextureView?
    
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
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func appChannelSettings(_ textureChannel: FlutterMethodChannel) -> Void {
        textureChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            switch call.method {
                case self.getTextureId:
                if let path = call.arguments as? String {
                    let url = URL(fileURLWithPath: path)
                    
                    guard let textureRegistry = self.pluginRegistrar?.textures() else {
                        result(
                            FlutterError(
                                code: "400",
                                message: "Não foi possível obter a instância do TextureRegistry",
                                details: nil
                            )
                        )
                        return
                    }
                    
                    self.videoTextView = TextureView(url: url, result: result, textureRegistry: textureRegistry)
                }
            case self.closeTextureView:
                self.videoTextView?.stop()
                self.videoTextView = nil
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
