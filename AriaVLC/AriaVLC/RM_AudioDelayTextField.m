//
//  RM_AudioDelayTextField.m
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
