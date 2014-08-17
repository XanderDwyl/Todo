//
//  Todo.h
//  Todo
//
//  Created by Alexjander Bacalso on 8/14/14.
//  Copyright (c) 2014 Alexjander Bacalso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject

@property (nonatomic, assign) NSInteger uniqueId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSDate *dateUpdated;
@property BOOL done;

@end