//
//  UnitItem.m
//  CwrsSylfaen
//
//  Created by Neil Taylor on 13/11/2011.
//  Copyright (c) 2011 Aberystwyth University. All rights reserved.
//

#import "UnitItem.h"

@implementation UnitItem


- (NSString *) description { 
    return [NSString stringWithFormat: @"UnitItem: %i", (int) self.unitId];
}

@end
