//
//  RM_DragHereView.m
//  AriaVLC
//
//  Created by Roberto Mauro on 23/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_DragHereView.h"

@implementation RM_DragHereView
@synthesize delegate;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, nil]];
    }
    
    return self;
}


- (NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSPasteboardTypeString]) {
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_ENTERED" object:self]];
        return NSDragOperationGeneric;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSPasteboardTypeString]) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_EXITED" object:self]];
    }
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_DROPPED" object:self]];
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSString *movieUrl = [pboard stringForType:NSPasteboardTypeString];
    
    if([[self delegate] respondsToSelector:@selector(openVideoAt:)])
    {
        [[self delegate] openVideoAt:movieUrl];
    }
    
}

@end
