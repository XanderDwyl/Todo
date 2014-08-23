//
//  TodoDb.h
//  Todo
//
//  Created by Alexjander Bacalso on 8/15/14.
//  Copyright (c) 2014 Alexjander Bacalso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Todo.h"

@interface TodoDb : NSObject {
    sqlite3 *_database;
}

+ (TodoDb *)database;
- (NSArray *)todoDbInfos;
- (BOOL)insertNewTodoWithTitle:(NSString *)title;
- (BOOL)deleteTodoWithId:(int)id;

@end
