//
//  ViewController.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit
#if CREATOR
class MainViewController: FinderColorsViewController { }
#elseif MULTIPLACE
class MainViewController: MultiPlaceHeadingViewController { }
#else
class MainViewController: SinglePlaceHeadingViewController {}
#endif
