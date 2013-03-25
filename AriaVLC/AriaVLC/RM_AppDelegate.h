//
//  RM_AppDelegate.h
//  AriaVLC
//
//  Created by Roberto Mauro on 23/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RM_MainWindow;
@class RM_PreferencesController;


@interface RM_AppDelegate : NSObject <NSApplicationDelegate> {
    RM_MainWindow *mainWindow;
    RM_PreferencesController *preferencesController;
}

- (IBAction) showPreferences:(id)sender;

@end
