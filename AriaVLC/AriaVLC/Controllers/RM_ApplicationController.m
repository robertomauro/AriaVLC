//
//  RM_ApplicationController.m
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RMVlcHasBeenStartedNotification object:self];
}


@end
