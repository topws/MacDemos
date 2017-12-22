//
//  PacketTunnelProvider.swift
//  PacketTunnelProvider
//
//  Created by Avazu Holding on 2017/12/21.
//  Copyright © 2017年 Avazu Holding. All rights reserved.
//

import Foundation
import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
	
	override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
		let ipv4Settings = NEIPv4Settings(addresses: ["211.95.63.218"], subnetMasks: ["255.255.255.0"])
		// 这里RemoteAddress可任意填写。
		let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
		networkSettings.mtu = 1500
		networkSettings.ipv4Settings = ipv4Settings
		setTunnelNetworkSettings(networkSettings) {
			error in
			guard error == nil else {
				NSLog(error.debugDescription)
				completionHandler(error)
				return
			}
			//当completionHandler()执行后VPN连接就会显示在手机上了。
			completionHandler(nil)
		}

	}
	
	override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
		
	}
	
	
//	override var packetFlow: NEPacketTunnelFlow {
//		
//		return NEPacketTunnelFlow()
//	}
}

