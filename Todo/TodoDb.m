//
//  TodoDb.m
//  Todo
//
//  Created by Alexjander Bacalso on 8/15/14.
//  Copyright (c) 2014 Alexjander Bacalso. All rights reserved.
//

#import "TodoDb.h"

@interface TodoDb () {
    sqlite3_stmt *_statement;
}
- (BOOL)isDatabaseOpened;
@end

@implementation TodoDb

static TodoDb *_database;

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"todoledo"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    NSLog(@"%@", [[NSDate date] description]);
    return self;
}

+ (TodoDb *)database {
    if (_database == nil) {
        _database = [[TodoDb alloc] init];
    }
    return _database;
}

// open a db connection to sqlite
// and then returns YES if successful or NO if query fails
- (BOOL)isDatabaseOpened
{
    BOOL isOpened = YES;
    // get the App's document dir
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // append file name
    NSString *sqLiteDb = [docPath stringByAppendingString:@"todoledo.db"];
    // get the file from path, or create one if it does not exist
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        isOpened = NO;
        NSLog(@"DB Error: %s", sqlite3_errmsg(_database));
    }
    
    return isOpened;
}


- (NSArray *)todoDbInfos {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT id, title, done, dateCreated, dateUpdated FROM todo ORDER BY id DESC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *titleChar = (char *) sqlite3_column_text(statement, 1);
            int doneInt = sqlite3_column_int(statement, 2);
            char *dateCreatedChar = (char *) sqlite3_column_text(statement, 3);
            char *dateUpdatedChar = (char *) sqlite3_column_text(statement, 4);
            
            // convertions
            BOOL done = doneInt;
            NSString *title = [[NSString alloc] initWithUTF8String:titleChar];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-mm-dd hh:mm:ss Z"];
            
            NSString *dateCreated = [[NSString alloc] initWithUTF8String:dateCreatedChar];
            NSString *dateUpdated = [[NSString alloc] initWithUTF8String:dateUpdatedChar];
            
            Todo *todo = [[Todo alloc]init];
            todo.title = title;
            todo.uniqueId = uniqueId;
            todo.done = done;
            todo.dateCreated = [df dateFromString:dateCreated];;
            todo.dateUpdated = [df dateFromString:dateUpdated];;
            
            [retval addObject:todo];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

- (BOOL)insertNewTodoWithTitle:(NSString *)title
{
    if (![self isDatabaseOpened]) {
        return NO;
    }
    
    BOOL result = YES;
    
    NSString *today = [[NSDate date] description];
    
    NSString *query = [NSString stringWithFormat:@"insert into todo (title, dateCreated, dateUpdated) values (\"%@\", \"%@\", \"%@\")", title, today, today];
    const char *qs = [query UTF8String];
    char *errorMsg;
    
    if (sqlite3_exec(_database, qs, NULL, NULL, &errorMsg) != SQLITE_OK) {
        result = NO;
        NSLog(@"%s", errorMsg);
    }
    
    sqlite3_close(_database);
    return result;
}@end