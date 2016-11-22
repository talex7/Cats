//
//  Photo.h
//  Cats
//
//  Created by Thomas Alexanian on 2016-11-21.
//  Copyright © 2016 Thomas Alexanian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Photo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) UIImage *image;


- (instancetype)initWithInfo:(NSDictionary*)dict;


@end
