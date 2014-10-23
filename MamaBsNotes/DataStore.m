//
//  DataStore.m
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (instancetype)sharedDataStore {
    static DataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DataStore alloc] init];
    });
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _notesArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void) saveNotes {
    
    NSData *savedArrayData = [NSKeyedArchiver archivedDataWithRootObject:_notesArray];
    
    NSString *fullPath = [self defaultSavePath];
    
    [savedArrayData writeToFile:fullPath atomically:YES];
}

-(void) retrieveNotes {
    
    NSString *fullPath = [self defaultSavePath];
    
    NSData *loadedArrayData = [[NSData alloc] initWithContentsOfFile:fullPath];
    
    NSMutableArray *kaijuNoteArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadedArrayData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.notesArray = kaijuNoteArray;
        NSLog(@"done loading");
    });
}


- (NSString *)defaultSavePath {
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *uniquePath = @"Mama_Bs_Notes";
    
    NSString *fullPath = [docsPath stringByAppendingPathComponent:uniquePath];
    return fullPath;
}

@end
