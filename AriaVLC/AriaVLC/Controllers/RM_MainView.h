//
//  RM_DragHereViewController.h
//  AriaVLC
//
//  Created by Roberto Mauro on 25/03/13.
//  Copyright (c) 2013 Roberto Mauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DDLog.h"

@class RM_AriaSymbolView;

@interface RM_MainView : NSViewController {
    RM_AriaSymbolView *ariaSymbol;
}

@property (assign) IBOutlet NSImageView *dottedLineBorder;





@end
