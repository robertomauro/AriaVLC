//
//  RM_AppDelegate.m
//  AriaVLC
//
//  Created by Roberto Mauro on 23/03/13.
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

#import "RM_AppDelegate.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#import "RM_MainWindow.h"
#import "RM_PreferencesController.h"


@implementation RM_AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
    // Load the window
    mainWindow = [[RM_MainWindow alloc] initWithWindowNibName:@"RM_MainWindow"];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Configura il logger CocoaLumberjack per
    // inviare log alla Console di Mac OS X e al Terminale di XCode (se disponibile)
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Imposta i valori di default per le preferenze
    [self setPrefsAtFistLaunch];
    
    [self registerNotifications];
}

- (IBAction) showPreferences:(id)sender
{
    preferencesController = [[RM_PreferencesController alloc] initWithWindowNibName:@"RM_PreferencesController"];
    [preferencesController.window makeKeyAndOrderFront:nil];

}

// Imposta le preferenze dell'applicazione al primo avvio
-(void)setPrefsAtFistLaunch
{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"FirstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstLaunch"];
        [[NSUserDefaults standardUserDefaults] setValue:RMDefaultAudioDelay forKey:@"CurrentAudioDelay"];
        [[NSUserDefaults standardUserDefaults] setBool:RMDefaultFullScreenMode forKey:@"CurrentFullScreen"];
    }
}

#pragma mark Private Methods Implementation

-(void)registerNotifications
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidLaunch:)
                          name:RMVlcHasBeenStartedNotification
                        object:nil];
    
}

// Questo metodo viene richiamato da Notification Center quando VLC viene aperto.
- (void) applicationDidLaunch: (NSNotification *)notification
{
    DDLogInfo(@"VLC è stato aperto. Nascondo la finestra principale di Aria VLC.");
    [mainWindow.window orderOut:self];
}


// Quando l'applicazione diventa attiva, mostra la finestra se non è visibile.
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if(![mainWindow.window isVisible])
    {
        [mainWindow.window makeKeyAndOrderFront:nil];
    }
}

@end
