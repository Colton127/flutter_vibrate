//
//  HapticEngine.swift
//  gaimon
//
//  Created by Dimitri Dessus on 28/01/2022.
//

import Foundation
import CoreHaptics

@available(iOS 13.0, *)
class HapticEngineManager: NSObject {
  private var engine: CHHapticEngine!
  private var advancedPlayer: CHHapticAdvancedPatternPlayer?
  //private var continuousPlayer: CHHapticPatternPlayer!
  

    func stopAdvancedPlayer() {
      do {
        try advancedPlayer?.stop(atTime: CHHapticTimeImmediate)
      } catch {
        print("stopAdvancedPlayer error: \(error)")
      }
    }
    func createAdvancedPlayer(duration: Double, amplitude: Float, result: @escaping FlutterResult) {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
      do {
      self.engine = try CHHapticEngine();
      try self.engine?.start()
      let vibrate = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: amplitude),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        ],
        relativeTime: duration,
        duration: duration)
      
      
        let pattern = try CHHapticPattern(events: [vibrate], parameters: [])
        advancedPlayer = try engine.makeAdvancedPlayer(with: pattern)
        advancedPlayer!.loopEnabled = true
        try engine.start()
        try advancedPlayer?.start(atTime: CHHapticTimeImmediate)
        result(true);
      } catch let error as NSError {
        result(FlutterError(code: String(error.code), message: "\(error.localizedDescription)", details: "\(error.localizedDescription)"));
      }
    }
}
