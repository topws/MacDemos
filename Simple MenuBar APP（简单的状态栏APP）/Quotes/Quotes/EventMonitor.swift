//
//  EventMonitor.swift
//  Quotes
//
//  Created by Avazu Holding on 2018/10/12.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

import Foundation
import Cocoa
public class EventMonitor {
	private var monitor: AnyObject?
	private let mask: NSEvent.EventTypeMask
	private let handler: (NSEvent?) -> ()
	
	public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
		self.mask = mask
		self.handler = handler
	}
	
	deinit {
		stop()
	}
	
	public func start() {
		monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
	}
	
	public func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}
}

