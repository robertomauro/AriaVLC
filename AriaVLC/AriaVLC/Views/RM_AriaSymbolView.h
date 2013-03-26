//
//  RM_AriaSymbolView.h
//  AriaVLC
//
//  Created by Roberto Mauro on 26/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RM_AriaSymbolView : NSView {
    NSImage *image;
}

- (void)setImage:(NSImage *)newImage;

@end
