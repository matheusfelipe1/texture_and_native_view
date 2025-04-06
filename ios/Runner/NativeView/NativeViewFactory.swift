//
//  NativeViewFactory.swift
//  Runner
//
//  Created by Matheus Felipe on 05/04/25.
//

import Flutter

class NativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

   init(messenger: FlutterBinaryMessenger) {
       self.messenger = messenger
       super.init()
   }

   func create(
       withFrame frame: CGRect,
       viewIdentifier viewId: Int64,
       arguments args: Any?
   ) -> FlutterPlatformView {
       
       return NativeVideoView(arguments: args)
   }

   func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
       return FlutterStandardMessageCodec.sharedInstance()
   }
}
