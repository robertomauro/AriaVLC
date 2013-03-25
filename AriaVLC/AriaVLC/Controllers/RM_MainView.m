//
//  RM_DragHereViewController.m
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import "RM_MainView.h"

#define OUT_ALPHA           0.2f
#define IN_ALPHA            1.0f
#define ANIMATION_DURATION  0.1f
#define EXPANSION_SIZE      10


@interface RM_MainView (Private)

- (void)registerNotification;
- (NSPoint)getOriginWith:(NSSize)frameSize For:(NSView *)parentView;
- (void)expandDragBox:(NSNotification *)notification;
- (void)restoreDragBox:(NSNotification *)notification;

@end

@implementation RM_MainView
@synthesize dottedLineBorder, ariaSymbol;

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
    
    // Resetta l'opacità del simbolo AriaVLC
    [ariaSymbol setAlphaValue:OUT_ALPHA];
    
    // Imposta i margini in autoresize
    [dottedLineBorder setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMaxYMargin | NSViewMinYMargin];
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
- (NSPoint)getOriginWith:(NSSize)frameSize For:(NSView *)parentView
{
    return NSMakePoint((NSWidth([parentView bounds]) - frameSize.width) / 2,
                       (NSHeight([parentView bounds]) - frameSize.height) / 2);
                       
}

// Avvia l'animazione di espansione del bordo tratteggiato quando un link sta per essere droppato all'interno
- (void)expandDragBox:(NSNotification *)notification
{
    NSSize expandendSize = NSMakeSize(dottedLineBorder.bounds.size.width + EXPANSION_SIZE,
                                      dottedLineBorder.bounds.size.width + EXPANSION_SIZE);
    
    NSPoint centerOrigin = [self getOriginWith:expandendSize For:self.view];
    NSRect expandedFrame = NSMakeRect(centerOrigin.x, centerOrigin.y, expandendSize.width, expandendSize.height);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:ANIMATION_DURATION];
    
    [[dottedLineBorder animator] setFrame:expandedFrame];
    [dottedLineBorder setNeedsDisplay:YES];
    
    [[ariaSymbol animator] setAlphaValue:IN_ALPHA];
    [ariaSymbol setNeedsDisplay:YES];
    
    [NSAnimationContext endGrouping];
}

// Avvia l'animazione di contrazione del bordo tratteggiato quando l'azione di Drag di un link esce dall'interno del bordo.
- (void)restoreDragBox:(NSNotification *)notification
{
    NSSize restoredSize = NSMakeSize(dottedLineBorder.bounds.size.width - EXPANSION_SIZE,
                                     dottedLineBorder.bounds.size.width - EXPANSION_SIZE);
    NSPoint centerOrigin = [self getOriginWith:restoredSize For:self.view];
    NSRect restoredFrame = NSMakeRect(centerOrigin.x, centerOrigin.y, restoredSize.width, restoredSize.height);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:ANIMATION_DURATION];
    
    [[dottedLineBorder animator] setFrame:restoredFrame];
    [dottedLineBorder setNeedsDisplay:YES];
    
    [[ariaSymbol animator] setAlphaValue:OUT_ALPHA];
    [ariaSymbol setNeedsDisplay:YES];
    
    [NSAnimationContext endGrouping];
}


@end
