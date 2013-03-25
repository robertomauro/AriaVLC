//
//  RM_MainWindowController.m
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_MainWindow.h"
#import "DDLog.h"

#import "RM_MainView.h"

@interface RM_MainWindow ()

@end

@implementation RM_MainWindow

-(id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if(self)
    {
        viewController = [[RM_MainView alloc] initWithNibName:@"RM_MainView" bundle:[NSBundle mainBundle]];
        self.window.contentView = viewController.view;
    }
    
    return self;
}

- (void)windowWillLoad
{
    [super windowWillLoad];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

}

- (void)windowWillClose:(NSNotification *)notification
{
    DDLogInfo(@"Richiesta chiusura applicazione");
    [[NSApplication sharedApplication] terminate:nil];
}

@end
