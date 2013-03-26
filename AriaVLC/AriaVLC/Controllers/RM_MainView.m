//
//  RM_DragHereViewController.m
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

#import "RM_MainView.h"
#import "RM_AriaSymbolView.h"

#define OUT_ALPHA           0.2f
#define IN_ALPHA            1.0f
#define ANIMATION_DURATION  0.1f
#define EXPANSION_SIZE      10


@interface RM_MainView (Private)

- (void)registerNotification;
- (NSPoint)getCenterWith:(NSSize)frameSize For:(NSRect)parentViewBounds;
- (void)expandDragBox:(NSNotification *)notification;
- (void)restoreDragBox:(NSNotification *)notification;

@end

@implementation RM_MainView
@synthesize dashedBorder;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self registerNotification];
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Crea la vista con il simbolo di AriaVLC e l'aggiunge come sottovista della linea tratteggiata.
    //
    // Usiamo la subclass RM_AriaSymbolView poiché una normale vista NSImageView interferirebbe
    // con il Drag & Drop di questa vista avendo il drag and drop abilitato per default.
    
    NSImage *ariaImage = [NSImage imageNamed:@"ariaVlcSymbol"];
    NSPoint symbolOrigin = [self getCenterWith:[ariaImage size] For:dashedBorder.bounds];
    NSRect symbolFrame = NSMakeRect(symbolOrigin.x, symbolOrigin.y, ariaImage.size.width, ariaImage.size.height);
    
    ariaSymbol = [[RM_AriaSymbolView alloc] initWithFrame:symbolFrame];
    [ariaSymbol setImage:ariaImage];
    [ariaSymbol setAlphaValue:OUT_ALPHA];
    
    [dashedBorder addSubview:ariaSymbol];
    
    // Imposta i margini in autoresize
    [dashedBorder setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMaxYMargin | NSViewMinYMargin];
}

#pragma mark Private Methods Implementation

// Registra il Controller per ricevere le notifiche inviate da DragHereView
- (void)registerNotification
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(expandDragBox:) name:@"DRAGBOX_ENTERED" object:nil];
    [defaultCenter addObserver:self selector:@selector(restoreDragBox:) name:@"DRAGBOX_EXITED" object:nil];
    [defaultCenter addObserver:self selector:@selector(restoreDragBox:) name:@"DRAGBOX_DROPPED" object:nil];
}

// Restituisce le coordinate di un'origine centrata con la vista padre.
- (NSPoint)getCenterWith:(NSSize)frameSize For:(NSRect)parentViewBounds
{
    return NSMakePoint((NSWidth(parentViewBounds) - frameSize.width) / 2,
                       (NSHeight(parentViewBounds) - frameSize.height) / 2);
                       
}

// Avvia l'animazione di espansione del bordo tratteggiato quando un link sta per essere droppato all'interno
- (void)expandDragBox:(NSNotification *)notification
{
    NSSize expandendSize = NSMakeSize(dashedBorder.bounds.size.width + EXPANSION_SIZE,
                                      dashedBorder.bounds.size.width + EXPANSION_SIZE);
    
    NSPoint centerOrigin = [self getCenterWith:expandendSize For:self.view.bounds];
    NSRect expandedFrame = NSMakeRect(centerOrigin.x, centerOrigin.y, expandendSize.width, expandendSize.height);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:ANIMATION_DURATION];
    
    // Espandiamo il frame della linea tratteggiata
    [[dashedBorder animator] setFrame:expandedFrame];
    [dashedBorder setNeedsDisplay:YES];
    
    // Ricentriamo il simbolo
    NSPoint symbolOrigin = [self getCenterWith:ariaSymbol.frame.size For:expandedFrame];
    [[ariaSymbol animator] setFrameOrigin:symbolOrigin];
    
    [[ariaSymbol animator] setAlphaValue:IN_ALPHA];
    [ariaSymbol setNeedsDisplay:YES];
    
    [NSAnimationContext endGrouping];
}

// Avvia l'animazione di contrazione del bordo tratteggiato quando l'azione di Drag di un link esce dall'interno del bordo.
- (void)restoreDragBox:(NSNotification *)notification
{
    NSSize restoredSize = NSMakeSize(dashedBorder.bounds.size.width - EXPANSION_SIZE,
                                     dashedBorder.bounds.size.width - EXPANSION_SIZE);
    NSPoint centerOrigin = [self getCenterWith:restoredSize For:self.view.bounds];
    NSRect restoredFrame = NSMakeRect(centerOrigin.x, centerOrigin.y, restoredSize.width, restoredSize.height);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:ANIMATION_DURATION];
    
    // Contraiamo il frame della linea tratteggiata.
    [[dashedBorder animator] setFrame:restoredFrame];
    [dashedBorder setNeedsDisplay:YES];
    
    // Ricentriamo il simbolo
    NSPoint symbolOrigin = [self getCenterWith:ariaSymbol.frame.size For:restoredFrame];
    [[ariaSymbol animator] setFrameOrigin:symbolOrigin];
    
    [[ariaSymbol animator] setAlphaValue:OUT_ALPHA];
    [ariaSymbol setNeedsDisplay:YES];
    
    [NSAnimationContext endGrouping];
}


@end
