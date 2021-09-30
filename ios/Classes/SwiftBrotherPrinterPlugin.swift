import Flutter

// Preprocessor directives found in file:
// #import <Flutter/Flutter.h>
// #import "BrotherPrinterPlugin.h"
// #import <BRLMPrinterKit/BRPtouchDeviceInfo.h>
// #import "BRPrinterDiscovery.h"
// #import "BRPrinterSession.h"
//import BRError.h

public class SwiftBrotherPrinterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel: FlutterMethodChannel! = FlutterMethodChannel(name: "brother_printer", binaryMessenger: registrar.messenger())
        let instance = SwiftBrotherPrinterPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if "searchDevices" == call.method {
            self.searchDevices(call, result: result)
        } else if "printPDF" == call.method {
            
//            self.print(call, result: result)
            
        } else if "printImage" == call.method {
            
            self.print(call, result: result)
            
        } else {
            result(FlutterMethodNotImplemented)
        }
}
func searchDevices(_ call: FlutterMethodCall!, result: FlutterResult?) {
    
    if let args = call.arguments as? Dictionary<String, Any>,
       let delay = args["delay"] as? NSNumber,
       let isEnableIPv6Search = args["isEnableIPv6Search"] as? NSNumber,
       let printerNames = args["printerNames"] as? NSArray {
        BRPrinterDiscovery.sharedInstance().start(CInt(delay.intValue), printerNames: printerNames, isEnableIPv6Search: isEnableIPv6Search.boolValue) { (devices: NSArray?, error: Error?) -> Void in
            if error != nil {
                result!(self.handleError(error! as NSError))
                
                return
            }
            
            result!(devices)
        }
    } else {
        result!(FlutterError.init(code: "bad args", message: nil, details: nil))
    }
    
}
func print(_ call: FlutterMethodCall!, result: FlutterResult) {
    if let args = call.arguments as? Dictionary<String, Any>,
       let path = args["path"] as? String,
       let copies = args["copies"] as? NSNumber,
       let model = args["modelCode"] as? NSNumber,
       let paperSettingsPath = args["paperSettingsPath"] as? String,
       let labelSize = args["labelSize"] as? String
    {
        
        
        let ipAddress = args["ipAddress"] as? String
        let serialNumber = args["serialNumber"] as? String
        let bleAdvertiseLocalName = args["bleAdvertiseLocalName"] as? String
        
        let session = BRPrinterSession()
        var error: NSError!
        
        if ipAddress != nil  {
            session.print(path, copies: copies.uintValue, model: model.intValue, paperSettingsPath: paperSettingsPath, labelSize: labelSize, ipAddress: ipAddress!, error: error)
        } else if serialNumber != nil  {
            session.print(path, copies: copies.uintValue, model: model.intValue, paperSettingsPath: paperSettingsPath, labelSize: labelSize, serialNumber: serialNumber!, error: error)
        } else if bleAdvertiseLocalName != nil  {
            session.print(path, copies: copies.uintValue, model: model.intValue, paperSettingsPath: paperSettingsPath, labelSize: labelSize, bleAdvertiseLocalName: bleAdvertiseLocalName!, error: error)
        } else {
            result(self.handleError(NSError(domain: BRErrorDomain, code: BRPrintErrorCodeMissingParameterError, userInfo: nil)))
            
            return
        }
        
        if error != nil {
            result(self.handleError(error))
        } else {
            result(nil)
        }
    }
    else {
        result(FlutterError.init(code: "bad args", message: nil, details: nil))
    }
    
    
}
func handleError(_ error: NSError) -> FlutterError! {
    if error.domain == BRErrorDomain {
        var code: String!
        
        switch error.code {
        case BRFailedToStartDiscoveryError:
            code = "BRFailedToStartDiscoveryError"
        case BRDiscoveryInProgressError:
            code = "BRDiscoveryInProgressError"
        case BROpenChannelErrorCodeOpenStreamFailure:
            code = "BROpenChannelErrorCodeOpenStreamFailure"
        case BROpenChannelErrorCodeTimeout:
            code = "BROpenChannelErrorCodeTimeout"
        case BRPrintErrorCodeMissingParameterError:
            code = "BRPrintErrorCodeMissingParameterError"
        case BRPrintErrorCodePrintSettingsError:
            code = "BRPrintErrorCodePrintSettingsError"
        case BRPrintErrorCodeFilepathURLError:
            code = "BRPrintErrorCodeFilepathURLError"
        case BRPrintErrorCodePDFPageError:
            code = "BRPrintErrorCodePDFPageError"
        case BRPrintErrorCodePrintSettingsNotSupportError:
            code = "BRPrintErrorCodePrintSettingsNotSupportError"
        case BRPrintErrorCodeDataBufferError:
            code = "BRPrintErrorCodeDataBufferError"
        case BRPrintErrorCodePrinterModelError:
            code = "BRPrintErrorCodePrinterModelError"
        case BRPrintErrorCodeCanceled:
            code = "BRPrintErrorCodeCanceled"
        case BRPrintErrorCodeChannelTimeout:
            code = "BRPrintErrorCodeChannelTimeout"
        case BRPrintErrorCodeSetModelError:
            code = "BRPrintErrorCodeSetModelError"
        case BRPrintErrorCodeUnsupportedFile:
            code = "BRPrintErrorCodeUnsupportedFile"
        case BRPrintErrorCodeSetMarginError:
            code = "BRPrintErrorCodeSetMarginError"
        case BRPrintErrorCodeSetLabelSizeError:
            code = "BRPrintErrorCodeSetLabelSizeError"
        case BRPrintErrorCodeCustomPaperSizeError:
            code = "BRPrintErrorCodeCustomPaperSizeError"
        case BRPrintErrorCodeSetLengthError:
            code = "BRPrintErrorCodeSetLengthError"
        case BRPrintErrorCodeTubeSettingError:
            code = "BRPrintErrorCodeTubeSettingError"
        case BRPrintErrorCodeChannelErrorStreamStatusError:
            code = "BRPrintErrorCodeChannelErrorStreamStatusError"
        case BRPrintErrorCodeChannelErrorUnsupportedChannel:
            code = "BRPrintErrorCodeChannelErrorUnsupportedChannel"
        case BRPrintErrorCodePrinterStatusErrorPaperEmpty:
            code = "BRPrintErrorCodePrinterStatusErrorPaperEmpty"
        case BRPrintErrorCodePrinterStatusErrorCoverOpen:
            code = "BRPrintErrorCodePrinterStatusErrorCoverOpen"
        case BRPrintErrorCodePrinterStatusErrorBusy:
            code = "BRPrintErrorCodePrinterStatusErrorBusy"
        case BRPrintErrorCodePrinterStatusErrorPrinterTurnedOff:
            code = "BRPrintErrorCodePrinterStatusErrorPrinterTurnedOff"
        case BRPrintErrorCodePrinterStatusErrorBatteryWeak:
            code = "BRPrintErrorCodePrinterStatusErrorBatteryWeak"
        case BRPrintErrorCodePrinterStatusErrorExpansionBufferFull:
            code = "BRPrintErrorCodePrinterStatusErrorExpansionBufferFull"
        case BRPrintErrorCodePrinterStatusErrorCommunicationError:
            code = "BRPrintErrorCodePrinterStatusErrorCommunicationError"
        case BRPrintErrorCodePrinterStatusErrorPaperJam:
            code = "BRPrintErrorCodePrinterStatusErrorPaperJam"
        case BRPrintErrorCodePrinterStatusErrorMediaCannotBeFed:
            code = "BRPrintErrorCodePrinterStatusErrorMediaCannotBeFed"
        case BRPrintErrorCodePrinterStatusErrorOverHeat:
            code = "BRPrintErrorCodePrinterStatusErrorOverHeat"
        case BRPrintErrorCodePrinterStatusErrorHighVoltageAdapter:
            code = "BRPrintErrorCodePrinterStatusErrorHighVoltageAdapter"
        case BRPrintErrorCodePrinterStatusErrorUnknownError:
            code = "BRPrintErrorCodePrinterStatusErrorUnknownError"
        case BRPrintErrorCodeUnknownError:
            code = "BRPrintErrorCodeUnknownError"
        default:
            break
        }
        
        return FlutterError(code: code, message: nil, details: nil)
    } else {
        return FlutterError(code: "Unknown error", message: error.localizedDescription, details: nil)
    }
}
}
