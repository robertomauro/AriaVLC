//
//  RM_DragHereView.m
//  AriaVLC
//
//  Created by Roberto Mauro on 23/03/13.
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
        [[NSNotificationCenter defaultCenter] postNotificationName:RMDashedBoxDragOperationStartedNotification object:self];
        return NSDragOperationGeneric;
    }
    else if ([[pboard types] containsObject:NSURLPboardType])
    {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        if([self isValidFile:fileURL])
        {
            DDLogInfo(@"Inizio trascinamento di un filmato o un audio");
            [[NSNotificationCenter defaultCenter] postNotificationName:RMDashedBoxDragOperationStartedNotification object:self];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:RMDashedBoxDragOperationEndedNotification object:self];
    }
    else if ([[pboard types] containsObject:NSURLPboardType])
    {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        if([self isValidFile:fileURL])
        {
            DDLogInfo(@"Terminato il trascinamento di una filmato o un audio");
            [[NSNotificationCenter defaultCenter] postNotificationName:RMDashedBoxDragOperationEndedNotification object:self];
        }
    }
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    // Informa la vista che un elemento è stato droppato per concludere l'animazione.
    [[NSNotificationCenter defaultCenter] postNotificationName:RMDashedBoxDragOperationDroppedNotification object:self];
    
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
