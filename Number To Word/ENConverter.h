//
//  ENConverter.h
//  English Number
//
//  Created by Ning Ke on 9/18/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENConverter : NSObject
@property NSString *number;
@property NSDictionary *order;
@property unsigned int orderMax;
- (ENConverter *)initWithString:(NSString *)num Longscale:(BOOL)uselong LargestUnit:(NSString *)largestUnit;
- (NSString *)englishRep;
- (NSString *)threeDigitRepWithOnes:(unsigned int)ones tens:(unsigned int)tns hundreds:(unsigned int)hds;

+ (BOOL)defaultUseLongScale;
+ (NSString *)getUnitStringFromValue:(float)value LongScale:(BOOL)longScale;
+ (float)getOrderValue:(NSString *)ord LongScale:(BOOL)longScale;
+ (NSString *)unitNameFromOrder:(unsigned int)order LongScale:(BOOL)longScale;
@end
