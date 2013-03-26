//
//  RM_NotificationNames.m
//  AriaVLC
//
//  Created by Roberto Mauro on 26/03/13.
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
//


// Application Constant
NSString * const RMDefaultAudioDelay        = @"1900";
BOOL const RMDefaultFullScreenMode          = NO;


// View Animation Constant
float const RMDragAnimationOutAlpha         = 0.2f;
float const RMDragAnimationInAlpha          = 1.0f;
float const RMDragAnimationDuration         = 0.1f;
float const RMDragAnimationDashedBoxGrowth  = 10.0f;


// Notification Names
NSString * const RMVlcHasBeenStartedNotification                = @"VLC_HAS_BEEN_STARTED_NOTIFICATION";
NSString * const RMDashedBoxDragOperationStartedNotification    = @"DASHED_BOX_DRAG_OPERATION_STARTED_NOTIFICATION";
NSString * const RMDashedBoxDragOperationEndedNotification      = @"DASHED_BOX_DRAG_OPERATION_ENDED_NOTIFICATION";
NSString * const RMDashedBoxDragOperationDroppedNotification    = @"DASHED_BOX_DRAG_OPERATION_DROPPED_NOTIFICATION";
