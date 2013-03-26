//
//  RM_MainWindowController.m
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//
//  This file is part of AriaVLC
//
//  AriaVLC is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  AriaVLC is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with AriaVLC.  If not, see <http://www.gnu.org/licenses/>.

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
