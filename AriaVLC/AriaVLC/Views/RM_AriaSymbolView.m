//
//  RM_AriaSymbolView.m
//  AriaVLC
//
//  Created by Roberto Mauro on 26/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_AriaSymbolView.h"

@implementation RM_AriaSymbolView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)setImage:(NSImage *)newImage
{
    image = newImage;
    
    [image setFlipped:YES];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
