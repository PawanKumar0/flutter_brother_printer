import Foundation

// Preprocessor directives found in file:
// #import <Foundation/Foundation.h>
// #import "BRPrinterSession.h"
// import "BRError.h"
// #import <BRLMPrinterKit/BRLMPrinterKit.h>
// #import <BRLMPrinterKit/BRLMPJPrintSettingsPaperSize.h>
class BRPrinterSession: NSObject {
    func print(_ path: String, copies: UInt, model: Int, paperSettingsPath: String, labelSize: String, ipAddress: String, error: NSError) {
        let channel = BRLMChannel(wifiIPAddress: ipAddress)
        
        self.connect(channel, path: path, copies: copies, model: BRLMPrinterModel(rawValue: model)!, paperSettingsPath: paperSettingsPath, labelSize: labelSize, error: error)
    }
    func print(_ path: String, copies: UInt, model: Int, paperSettingsPath: String, labelSize: String, serialNumber: String, error: NSError) {
        let channel = BRLMChannel(bluetoothSerialNumber: serialNumber)
        
        self.connect(channel, path: path, copies: copies, model: BRLMPrinterModel(rawValue: model)!, paperSettingsPath: paperSettingsPath, labelSize: labelSize, error: error)
    }
    func print(_ path: String, copies: UInt, model: Int, paperSettingsPath: String, labelSize: String, bleAdvertiseLocalName: String, error: NSError) {
        let channel = BRLMChannel(bleLocalName: bleAdvertiseLocalName)
        
        self.connect(channel, path: path, copies: copies, model: BRLMPrinterModel(rawValue: model)!, paperSettingsPath: paperSettingsPath, labelSize: labelSize, error: error)
    }
    func connect(_ channel: BRLMChannel, path: String, copies: UInt, model: BRLMPrinterModel, paperSettingsPath: String!, labelSize: String!, error: NSError) {
        let generateResult: BRLMPrinterDriverGenerateResult! = BRLMPrinterDriverGenerator.open(channel)
        var error = error
        
        switch generateResult.error.code {
        case .openStreamFailure:
            error = NSError(domain: BRErrorDomain, code: BROpenChannelErrorCodeOpenStreamFailure, userInfo: nil)
            
            return
        case .timeout:
            error = NSError(domain: BRErrorDomain, code: BROpenChannelErrorCodeTimeout, userInfo: nil)
            
            return
        case .noError:
            break
        default:
            break
        }
        
        if generateResult.driver == nil {
            error = NSError(domain: BRErrorDomain, code: BROpenChannelErrorCodeOpenStreamFailure, userInfo: nil)
            
            return
        }
        
        let printerDriver: BRLMPrinterDriver! = generateResult.driver
        
        self.process(printerDriver, path: path, copies: copies, model: model, paperSettingsPath: paperSettingsPath, labelSize: labelSize, error: error)
        printerDriver.closeChannel()
    }
    func process(_ printerDriver: BRLMPrinterDriver, path: String, copies: UInt, model: BRLMPrinterModel, paperSettingsPath: String!, labelSize: String!, error: NSError) {
        let _: URL! = URL.init(string: path)
        let settings = self.settings(model, paperSettingsPath: paperSettingsPath, labelSize: labelSize)
        
        settings?.numCopies = copies
        
        let printError: BRLMPrintError = printerDriver.printImage(with: (UIImage.init(named: path)?.cgImage)!, settings: settings!)
        
        var error = error
        
        switch printError.code {
        case .noError:
            break
        case .printSettingsError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrintSettingsError, userInfo: nil)
        case .filepathURLError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeFilepathURLError, userInfo: nil)
        case .pdfPageError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePDFPageError, userInfo: nil)
        case .printSettingsNotSupportError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrintSettingsNotSupportError, userInfo: nil)
        case .dataBufferError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeDataBufferError, userInfo: nil)
        case .printerModelError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterModelError, userInfo: nil)
        case .canceled:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeCanceled, userInfo: nil)
        case .channelTimeout:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeChannelTimeout, userInfo: nil)
        case .setModelError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeSetModelError, userInfo: nil)
        case .unsupportedFile:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeUnsupportedFile, userInfo: nil)
        case .setMarginError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeSetMarginError, userInfo: nil)
        case .setLabelSizeError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeSetLabelSizeError, userInfo: nil)
        case .customPaperSizeError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeCustomPaperSizeError, userInfo: nil)
        case .setLengthError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeSetLengthError, userInfo: nil)
        case .tubeSettingError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeTubeSettingError, userInfo: nil)
        case .channelErrorStreamStatusError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeChannelErrorStreamStatusError, userInfo: nil)
        case .channelErrorUnsupportedChannel:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeChannelErrorUnsupportedChannel, userInfo: nil)
        case .printerStatusErrorPaperEmpty:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorPaperEmpty, userInfo: nil)
        case .printerStatusErrorCoverOpen:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorCoverOpen, userInfo: nil)
        case .printerStatusErrorBusy:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorBusy, userInfo: nil)
        case .printerStatusErrorPrinterTurnedOff:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorPrinterTurnedOff, userInfo: nil)
        case .printerStatusErrorBatteryWeak:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorBatteryWeak, userInfo: nil)
        case .printerStatusErrorExpansionBufferFull:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorExpansionBufferFull, userInfo: nil)
        case .printerStatusErrorCommunicationError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorCommunicationError, userInfo: nil)
        case .printerStatusErrorPaperJam:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorPaperJam, userInfo: nil)
        case .printerStatusErrorMediaCannotBeFed:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorMediaCannotBeFed, userInfo: nil)
        case .printerStatusErrorOverHeat:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorOverHeat, userInfo: nil)
        case .printerStatusErrorHighVoltageAdapter:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorHighVoltageAdapter, userInfo: nil)
        case .printerStatusErrorUnknownError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodePrinterStatusErrorUnknownError, userInfo: nil)
        case .unknownError:
            error = NSError(domain: BRErrorDomain, code: BRPrintErrorCodeUnknownError, userInfo: nil)
        default:
            break
        }
    }
    // TODO be able to pass settings from Flutter
    func settings(_ model: BRLMPrinterModel, paperSettingsPath: String?, labelSize: String?) -> (NSObject & NSCoding & BRLMPrintSettingsProtocol & BRLMPrintImageSettings)! {
        switch model {
        case .PJ_673, .pj_763MFi, .PJ_773:
            let settings: BRLMPJPrintSettings! = BRLMPJPrintSettings.init(defaultPrintSettingsWith: model)
            return settings
        case .mw_145MFi, .mw_260MFi, .MW_170, .MW_270:
            let settings: BRLMMWPrintSettings! = BRLMMWPrintSettings.init(defaultPrintSettingsWith: model)
            return settings
        case .rj_4030Ai, .RJ_4040, .RJ_3050, .RJ_3150, .rj_3050Ai, .rj_3150Ai, .RJ_2050, .RJ_2140, .RJ_2150, .RJ_4230B, .RJ_4250WB:
            let settings: BRLMRJPrintSettings! = BRLMRJPrintSettings.init(defaultPrintSettingsWith: model)
            return settings
        case .TD_2120N, .TD_2130N, .TD_4100N, .TD_4420DN, .TD_4520DN, .TD_4550DNWB:
            let settings: BRLMTDPrintSettings! = BRLMTDPrintSettings.init(defaultPrintSettingsWith: model)
            if paperSettingsPath != nil {
                let customPaperFileUrl: URL! = URL.init(string: paperSettingsPath!)
                let paperSize = BRLMCustomPaperSize(file: customPaperFileUrl)
                
                settings.customPaperSize = paperSize
            }
            
            settings.peelLabel = true
            
            return settings
        case .QL_710W, .QL_720NW, .QL_810W, .QL_820NWB, .QL_1110NWB, .QL_1115NWB:
            let settings: BRLMQLPrintSettings! = BRLMQLPrintSettings.init(defaultPrintSettingsWith: model)
            if labelSize != nil {
                var qlLabelSize: BRLMQLPrintSettingsLabelSize?
                
                if labelSize == "DieCutW17H54" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW17H54
                } else if labelSize == "DieCutW17H87" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW17H87
                } else if labelSize == "DieCutW23H23" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW23H23
                } else if labelSize == "DieCutW29H42" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW29H42
                } else if labelSize == "DieCutW29H90" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW29H90
                } else if labelSize == "DieCutW38H90" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW38H90
                } else if labelSize == "DieCutW39H48" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW39H48
                } else if labelSize == "DieCutW52H29" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW52H29
                } else if labelSize == "DieCutW62H29" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW62H29
                } else if labelSize == "DieCutW62H100" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW62H100
                } else if labelSize == "DieCutW60H86" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW60H86
                } else if labelSize == "DieCutW54H29" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW54H29
                } else if labelSize == "DieCutW102H51" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW102H51
                } else if labelSize == "DieCutW102H152" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW102H152
                } else if labelSize == "DieCutW103H164" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dieCutW103H164
                } else if labelSize == "RollW12" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW12
                } else if labelSize == "RollW29" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW29
                } else if labelSize == "RollW38" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW38
                } else if labelSize == "RollW50" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW50
                } else if labelSize == "RollW54" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW54
                } else if labelSize == "RollW62" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW62
                } else if labelSize == "RollW62RB" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW62RB
                } else if labelSize == "RollW102" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW102
                } else if labelSize == "RollW103" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.rollW103
                } else if labelSize == "DTRollW90" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dtRollW90
                } else if labelSize == "DTRollW102" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dtRollW102
                } else if labelSize == "DTRollW102H51" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dtRollW102H51
                } else if labelSize == "DTRollW102H152" {
                    qlLabelSize = BRLMQLPrintSettingsLabelSize.dtRollW102H152
                }
                
                settings.labelSize = qlLabelSize!
            }
            
            settings.autoCut = true
            
            return settings
        case .PT_E550W, .PT_P750W, .PT_D800W, .PT_E800W, .PT_E850TKW, .PT_P900W, .PT_P950NW, .PT_P300BT, .PT_P710BT, .pt_P715eBT, .PT_P910BT:
            let settings: BRLMPTPrintSettings! = BRLMPTPrintSettings.init(defaultPrintSettingsWith: model)
            return settings
        default:
            return nil
        }
    }
}
