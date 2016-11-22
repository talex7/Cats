//
//  Photo.m
//  Cats
//
//  Created by Thomas Alexanian on 2016-11-21.
//  Copyright © 2016 Thomas Alexanian. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithInfo:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _title = [NSString stringWithFormat: @"%@", dict[@"title"]];
        _url = [NSString stringWithFormat: @"https://farm%@.staticflickr.com/%@/%@_%@.jpg", dict[@"farm"], dict[@"server"], dict[@"id"], dict[@"secret"]];
    }
    return self;
}



@end
