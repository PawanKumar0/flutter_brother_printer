import Foundation

// Preprocessor directives found in file:
// #ifndef BRPrinterDiscovery_h
// #define BRPrinterDiscovery_h
// #import <Foundation/Foundation.h>
// #endif /* BRPrinterDiscovery_h */
// import BRError.h
// #import "BRPrinterDiscovery.h"
// #import <BRLMPrinterKit/BRLMPrinterKit.h>
// #import <BRLMPrinterKit/BRPtouchNetworkManager.h>
// #import <BRLMPrinterKit/BRPtouchBluetoothManager.h>
// #import <BRLMPrinterKit/BRPtouchBLEManager.h>
typealias BRPrinterDiscoveryCompletion = ((NSArray?, Error?) -> Void)?

class BRPrinterDiscovery: NSObject, BRPtouchNetworkDelegate {
    private var _networkManager: BRPtouchNetworkManager!
    private var _completion: BRPrinterDiscoveryCompletion!
    private var _bleDevices: Array<BRPtouchDeviceInfo>?
    
    static func sharedInstance() -> BRPrinterDiscovery {
        let sharedInstance: BRPrinterDiscovery = BRPrinterDiscovery()
        
        return sharedInstance
    }
    func start(_ delay: CInt, printerNames: NSArray, isEnableIPv6Search: Bool, completion: BRPrinterDiscoveryCompletion) {
        assert(completion != nil)
        assert(delay > 0)
        
        if _networkManager == nil {
            _networkManager = BRPtouchNetworkManager()
            _networkManager.delegate = self
            _bleDevices = [BRPtouchDeviceInfo]()
        }
        
        _networkManager.startSearch(delay)
        _networkManager.setPrinterNames(printerNames as? [Any]) // if empty doesn't seems to work
        
        // Already in progress
        if _completion != nil {
            _completion?(nil, NSError(domain: BRErrorDomain, code: BRDiscoveryInProgressError, userInfo: nil))
            
            return
        }
        
        _completion = completion
        
        let ret: CInt = _networkManager.startSearch(delay)
        
        if ret != RET_TRUE {
            _completion?(nil, NSError(domain:BRErrorDomain, code: BRFailedToStartDiscoveryError, userInfo: nil))
            _completion = nil
        }
        
        _bleDevices?.removeAll()
        BRPtouchBLEManager.shared().startSearch { (device: BRPtouchDeviceInfo!) -> Void in
            self._bleDevices?.append(device)
        }
    }
    func didFinishSearch(_ manager: Any!) {
        guard let manager = manager as? BRPtouchNetworkManager else {
            return
        }
        BRPtouchBLEManager.shared().stopSearch()
        
        let devicesJSON = NSMutableArray()
        
        for device in manager.getPrinterNetInfo() {
            devicesJSON.add(self.convertDeviceInfoToJson((device as! BRPtouchDeviceInfo), source: "network") ?? [])
        }
        
        for device in _bleDevices ?? [] {
            devicesJSON.add(self.convertDeviceInfoToJson(device, source: "ble") ?? [])
        }
        
        for device in BRPtouchBluetoothManager.shared().pairedDevices() {
            devicesJSON.add(self.convertDeviceInfoToJson(device as? BRPtouchDeviceInfo, source: "bluetooth") ?? [])
        }
        
        _completion?(devicesJSON, nil)
        _completion = nil
    }
    func convertDeviceInfoToJson(_ device: BRPtouchDeviceInfo!, source: String!) -> NSDictionary! {
        return ["source": source, "ipAddress": (device.strIPAddress != nil) ? device.strIPAddress : NSNull(), "location": (device.strLocation != nil) ? device.strLocation : nil, "modelName": (device.strModelName != nil) ? device.strModelName : nil, "printerName": (device.strPrinterName != nil) ? device.strPrinterName : nil, "serialNumber": (device.strSerialNumber != nil) ? device.strSerialNumber : nil, "nodeName": (device.strNodeName != nil) ? device.strNodeName : nil, "macAddress": (device.strMACAddress != nil) ? device.strMACAddress : nil, "bleAdvertiseLocalName": (device.strBLEAdvertiseLocalName != nil) ? device.strBLEAdvertiseLocalName : nil]
    }
}
