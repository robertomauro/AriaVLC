//
//  RM_ApplicationController.m
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_ApplicationController.h"
#import "DDLog.h"

@implementation RM_ApplicationController

/*
 * Apre VLC con il comando da terminale:
 *
 *      $ /Applications/VLC.app/Contents/MacOS/VLC --audio-desync=-1900 --fullscreen
 *
 */
- (void)openVideoAt:(NSString *)videoUrl {
    DDLogInfo(@"Richiesta di apertura del video al percorso: %@", videoUrl);
    
    // Chiude VLC nel caso in cui sia già aperto per evitare l'avvio di un'altra sessione.
    NSArray *runninVLCs = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"org.videolan.vlc"];
    
    for (NSRunningApplication *app in runninVLCs)
    {	
        [app terminate];
    }
    
    NSString *vlcPath = @"/Applications/VLC.app/Contents/MacOS/VLC";
    
    NSString *audioDelayValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentAudioDelay"];
    bool fullscreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"CurrentFullScreen"];
    
    NSString *audioDelay = [NSString stringWithFormat:@"--audio-desync=-%@", audioDelayValue];

    NSMutableArray *args = [NSMutableArray arrayWithObjects:videoUrl, audioDelay, nil];
    
    if(fullscreen)
    {
        [args addObject:@"--fullscreen"];
    }
    
    DDLogCInfo(@"Lacio VLC in un thread separato");
    
    // Esegue VLC in un thread separato per non bloccare il thread principale.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^(void){
        NSTask *task = [[NSTask alloc]init];
        NSFileHandle *nullDevice = [NSFileHandle fileHandleWithNullDevice];
        
        [task setLaunchPath:vlcPath];
        [task setArguments:args];
        [task setStandardOutput:nullDevice];
        
        [task launch];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VLC_HAS_BEEN_STARTED" object:self];
}


@end
