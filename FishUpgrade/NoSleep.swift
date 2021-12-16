//
//  NoSleep.swift
//  FishUpgrade
//
//  Created by Lakr Aream on 2021/12/16.
//

import Foundation

import IOKit.pwr_mgt

var noSleepAssertionID: IOPMAssertionID = 0
var noSleepReturn: IOReturn?
// Could probably be replaced by a boolean value, for example 'isBlockingSleep', just make sure 'IOPMAssertionRelease' doesn't get called, if 'IOPMAssertionCreateWithName' failed.

func disableScreenSleep(reason: String = "Unknown reason") -> Bool? {
    guard noSleepReturn == nil else { return nil }
    noSleepReturn = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                reason as CFString,
                                                &noSleepAssertionID)
    return noSleepReturn == kIOReturnSuccess
}

func enableScreenSleep() -> Bool {
    if noSleepReturn != nil {
        _ = IOPMAssertionRelease(noSleepAssertionID) == kIOReturnSuccess
        noSleepReturn = nil
        return true
    }
    return false
}
