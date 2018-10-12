//
//  QuotesViewController.swift
//  Quotes
//
//  Created by Avazu Holding on 2018/10/11.
//  Copyright © 2018年 Avazu Holding. All rights reserved.
//

import Cocoa

class QuotesViewController: NSViewController {

	@IBAction func clickNextButtom(_ sender: NSButton) {
		//取余实现循环轮播的效果
		currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
	}
	@IBAction func clickPreButton(_ sender: NSButton) {

		currentQuoteIndex = (currentQuoteIndex - 1 + quotes.count) % quotes.count
	}
	@IBOutlet weak var preButton: NSButton!
	@IBOutlet weak var nextButton: NSButton!
	@IBAction func quoteLabel(_ sender: NSTextField) {
	}
	@IBAction func clickQuitButton(_ sender: NSButton) {
		NSApplication.shared.terminate(nil)
	}
	@IBOutlet weak var titleTextField: NSTextField!
	//
	let quotes = Quote.all
	
	var currentQuoteIndex: Int = 0 {
		didSet {
			updateQuote()
		}
	}
	
	func updateQuote() {
//		titleTextField.maximumNumberOfLines = 5
		titleTextField.stringValue = quotes[currentQuoteIndex].description
	}
	override func viewWillAppear() {
		super.viewWillAppear()
		
		currentQuoteIndex = 0
	}
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		setupViews()
		
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.white.cgColor


    }
	
	private func setupViews() {
		
		//Mac最初并没有GPU，都是由CPU完成渲染，所以layer，后来才把iOS的那一套搬过来
		//NSButton设置的背景色无效，需要使用drawRect来进行更改背景色

		
		
	}
	
	
}
