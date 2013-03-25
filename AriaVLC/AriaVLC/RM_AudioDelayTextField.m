//
//  RM_AudioDelayTextField.m
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_AudioDelayTextField.h"
#import "DDLog.h"

@implementation RM_AudioDelayTextField


// Permette di inserire soltato numeri
-(void)textDidChange:(NSNotification *)notification
{
    NSString *currentString = [self stringValue];
    NSMutableString *resultString = [NSMutableString stringWithCapacity:currentString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:currentString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        
        if([scanner scanCharactersFromSet:numbers intoString:&buffer])
        {
            [resultString appendString:buffer];
        }
        else
        {
            [scanner setScanLocation:[scanner scanLocation] +1];
        }
    }
    
    [self setStringValue:resultString];
    
    if ([[self delegate] respondsToSelector:@selector(setAudioDelay:)]) {
        [[self delegate] performSelector:@selector(setAudioDelay:) withObject:resultString];
    }

}

@end
