//
//  RM_AppDelegate.m
//  AriaVLC
//
//  Created by Roberto Mauro on 23/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_AppDelegate.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#import "RM_MainWindow.h"
#import "RM_PreferencesController.h"

#define DEFAULT_AUDIO_DELAY    @"1900"
#define DEFAULT_FULLSCREEN     YES

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

-(void)setPrefsAtFistLaunch
{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"FirstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstLaunch"];
        
        [[NSUserDefaults standardUserDefaults] setValue:DEFAULT_AUDIO_DELAY forKey:@"DefaultAudioDelay"];
        [[NSUserDefaults standardUserDefaults] setBool:DEFAULT_FULLSCREEN forKey:@"DefaultFullScreen"];
        
        [[NSUserDefaults standardUserDefaults] setValue:DEFAULT_AUDIO_DELAY forKey:@"CurrentAudioDelay"];
        [[NSUserDefaults standardUserDefaults] setBool:DEFAULT_FULLSCREEN forKey:@"CurrentFullScreen"];
    }
}

#pragma mark Private Methods Implementation

-(void)registerNotifications
{
    // Aggiunge un observer per ricevere le notifiche di nuove applicazioni aperte.
    // All'apertura di un'applicazione viene richiamato il metodo applicationDidLaunch:
    NSNotificationCenter *defaultCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidLaunch:)
                          name:NSWorkspaceDidLaunchApplicationNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(applicationDidTerminate:)
                          name:NSWorkspaceDidTerminateApplicationNotification object:nil];
}

// Questo metodo viene richiamato da Notification Center quando un'applicazione viene aperta.
- (void) applicationDidLaunch: (NSNotification *)notification
{
    // Se l'applicazione lanciata è VLC nascondiamo la finestra di principale di AriaVLC.
    NSString *appName = notification.userInfo[@"NSApplicationName"];
    if([appName isEqualToString:@"VLC"])
    {
        DDLogInfo(@"VLC è stato aperto. Nascondo la finestra principale di Aria VLC.");
        [mainWindow.window orderOut:self];
    }
    
}

// Questo metodo viene richiamato da Notification Center quando un'applicazione viene chiusa.
- (void) applicationDidTerminate: (NSNotification *)notification
{
    // Se l'applicazione lanciata è VLC nascondiamo la finestra di principale di AriaVLC.
    NSString *appName = notification.userInfo[@"NSApplicationName"];
    if([appName isEqualToString:@"VLC"])
    {
        DDLogInfo(@"VLC è stato chiuso. Mostro la finestra principale di Aria VLC.");
        [mainWindow.window orderFront:self];
    }
    
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
