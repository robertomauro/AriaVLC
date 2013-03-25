//
//  RM_PreferencesControllerWindowController.h
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RM_PreferencesController : NSWindowController

@property (assign) IBOutlet NSTextField *audioDelayTextField;
@property (assign) IBOutlet NSButton    *fullScreenCheckBox;

- (IBAction)setFullScreen:(id)sender;
- (IBAction)restoreDefaults:(id)sender;

@end
