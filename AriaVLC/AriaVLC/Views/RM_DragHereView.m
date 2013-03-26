//
//  RM_DragHereView.m
//  AriaVLC
//
//  Created by Roberto Mauro on 23/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_DragHereView.h"
#import "DDLog.h"

@interface RM_DragHereView ()
-(BOOL)isValidFile:(NSURL *)fileURL;
@end

@implementation RM_DragHereView
@synthesize delegate;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, NSURLPboardType, nil]];
    }
    
    return self;
}

#pragma mark Private Methods Implementation
// Verifica se il file è valido.
// All'interno del contesto di questa applicazione,
// per essere un file valido si deve trattare di un filmato o di un audio.
-(BOOL)isValidFile:(NSURL *)fileURL
{
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSString *type;
    NSError *error;
    
    if([fileURL getResourceValue:&type forKey:NSURLTypeIdentifierKey error:&error])
    {
        if ([workspace type:type conformsToType:@"public.movie"] ||
            [workspace type:type conformsToType:@"public.audio"])
        {
            return YES;
        }
    }
    else
    {
        DDLogError(@"Si è verificato un errore nel trascinamento del file al percorso: %@\n%@", [fileURL absoluteString], [error localizedDescription]);
    }
    
    return NO;
}

#pragma mark Drag Operations Implementation

// Quando inizia il trascinamento di un elemento
// Verifichiamo che si tratti di una stringa o di un singolo file.
// Quando si tratta di un file, ne verifichiamo il tipo permettendo il trascinamento
// esclusivamente di filmati e musica.
- (NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSPasteboardTypeString])
    {
        DDLogInfo(@"Inizio trascinamento di una stringa");
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_ENTERED" object:self]];
        return NSDragOperationGeneric;
    }
    else if ([[pboard types] containsObject:NSURLPboardType])
    {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        if([self isValidFile:fileURL])
        {
            DDLogInfo(@"Inizio trascinamento di un filmato o un audio");
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_ENTERED" object:self]];
            return NSDragOperationGeneric;
        }
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSPasteboardTypeString])
    {
        DDLogInfo(@"Terminato il trascinamento di una stringa");
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_EXITED" object:self]];
    }
    else if ([[pboard types] containsObject:NSURLPboardType])
    {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        if([self isValidFile:fileURL])
        {
            DDLogInfo(@"Terminato il trascinamento di una filmato o un audio");
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_EXITED" object:self]];
        }
    }
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    // Informa la vista che un elemento è stato droppato per concludere l'animazione.
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DRAGBOX_DROPPED" object:self]];
    
    // recupera la Pasteboard con gli elementi trascinati
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSString *movieUrl;
    
    if ([[pboard types] containsObject:NSPasteboardTypeString])
    {
        movieUrl = [pboard stringForType:NSPasteboardTypeString];
    }
    else if([[pboard types]containsObject:NSURLPboardType])
    {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        movieUrl = [fileURL absoluteString];
    }
    
    if([[self delegate] respondsToSelector:@selector(openVideoAt:)])
    {
        [[self delegate] openVideoAt:movieUrl];
    }
    
}

@end
