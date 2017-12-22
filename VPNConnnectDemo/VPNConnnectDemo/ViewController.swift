//
//  ViewController.swift
//  VPNConnnectDemo
//
//  Created by Avazu Holding on 2017/12/21.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

import UIKit
import NetworkExtension
class ViewController: UIViewController {

	
	var vpnManager: NETunnelProviderManager? = nil;
	@IBOutlet weak var descLB: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	
		
		NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
			
			guard let managers = managers else{return}
			let manager: NETunnelProviderManager
			if managers.count > 0 {
				manager = managers[0]
			}else{
				manager = self.createProviderManager()
			}
			self.vpnManager = manager;
			self.addManagerObserver(manager: manager)
			//保存 VPN至系统中，每次调用这个方法都会 新建一个VPN，所有应该先读取所有的VPN条目，避免重复调用
			manager.saveToPreferences { (error) in
				if error != nil{
					print(error!);
					return;
				}
				NSLog("to do")
				manager.loadFromPreferences(completionHandler: { (error) in
					if error != nil {
						print(error!)
						return;
					}
					self.descLB.text = "can connection"
					
				})
			}
		}
	}

	func createProviderManager() -> NETunnelProviderManager {
		
		let manager = NETunnelProviderManager();
		let conf = NETunnelProviderProtocol()
		conf.serverAddress = "you are leader"
		//如果用于 macOS ，需要配置bundleIdentifier
//		conf.providerBundleIdentifier = "com.dotcunited.VPNConnnectDemo.PacketTunnelProvider"
		
		
		let proxySettings = NEProxySettings()
		proxySettings.autoProxyConfigurationEnabled = true
		proxySettings.proxyAutoConfigurationJavaScript = "function FindProxyForURL(url, host) {return \"SOCKS 127.0.0.1:\(80)\";}"
		proxySettings.httpEnabled = true
		proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: 80)
		proxySettings.httpsEnabled = true
		proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: 80)
		conf.proxySettings = proxySettings
		
		manager.protocolConfiguration = conf
		manager.localizedDescription = "leader VPN"
		manager.isEnabled = true
		
		return manager;
	}
	

	@IBAction func switchVPN(_ sender: UISwitch) {
		
		if sender.isOn {
			try! self.vpnManager!.connection.startVPNTunnel()
		}else{
			try! self.vpnManager!.connection.stopVPNTunnel()
		}
	}

	func addManagerObserver(manager:NETunnelProviderManager) -> Void {
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: manager.connection.status, queue: OperationQueue.main) { (notify) in
			NSLog("connection.status changed")
			print(notify.object)
		}
	}
}

