//
//  UnitItem.h
//  CwrsSylfaen
//
//  Created by Neil Taylor on 13/11/2011.
//  Copyright (c) 2011 Aberystwyth University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitItem : NSObject

@property (assign, nonatomic) NSInteger unitId; 
@property (retain, nonatomic) NSString *english; 
@property (retain, nonatomic) NSString *north; 
@property (retain, nonatomic) NSString *south; 

@end
