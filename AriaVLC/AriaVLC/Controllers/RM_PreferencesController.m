//
//  RM_PreferencesControllerWindowController.m
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_PreferencesController.h"

#import "DDLog.h"

@interface RM_PreferencesController ()
-(void)loadPrefs;
@end

@implementation RM_PreferencesController
@synthesize audioDelayTextField, fullScreenCheckBox;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    [self loadPrefs];
}


- (IBAction)setFullScreen:(id)sender
{
    NSInteger checkboxState = [fullScreenCheckBox state];
    [[NSUserDefaults standardUserDefaults] setBool:checkboxState forKey:@"CurrentFullScreen"];
    
}

- (void)setAudioDelay:(NSString *)delay
{
    [[NSUserDefaults standardUserDefaults] setValue:delay forKey:@"CurrentAudioDelay"];
}

- (IBAction)restoreDefaults:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setValue:RMDefaultAudioDelay forKey:@"CurrentAudioDelay"];
    [[NSUserDefaults standardUserDefaults] setBool:RMDefaultFullScreenMode forKey:@"CurrentFullScreen"];
    
    [self loadPrefs];
}

#pragma mark Private Methods Implementation
- (void)loadPrefs
{
    NSString *audioDelay = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentAudioDelay"];
    NSInteger checboxState = [[NSUserDefaults standardUserDefaults] boolForKey:@"CurrentFullScreen"];
    
    [audioDelayTextField setStringValue: audioDelay];
    [fullScreenCheckBox setState:checboxState];
}



@end
