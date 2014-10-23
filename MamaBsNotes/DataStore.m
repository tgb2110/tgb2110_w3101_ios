//
//  DataStore.m
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import "DataStore.h"
#import "Note.h"

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

-(void)createNoteInDataStoreWithTitle:(NSString *)title withBody:(NSString *)body withImage:(UIImage *)image {
    
    Note *newNote = [[Note alloc] initNoteWithTitle:title withBody:body withImage:image];

    [self.notesArray addObject:newNote];
}

-(void) saveNotes {
    
    NSData *savedArrayData = [NSKeyedArchiver archivedDataWithRootObject:_notesArray];
    
    NSString *fullPath = [self defaultSavePath];
    
    [savedArrayData writeToFile:fullPath atomically:YES];
}

- (void)retrieveNotesWithBlock:(void (^)(BOOL))completion {
    
    NSString *fullPath = [self defaultSavePath];
    
    NSData *loadedArrayData = [[NSData alloc] initWithContentsOfFile:fullPath];
    
    NSMutableArray *noteArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadedArrayData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (noteArray != NULL) {
            self.notesArray = noteArray;
        }
        completion(YES);
    });

}

- (NSString *)defaultSavePath {
    
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *uniquePath = @"Mama_Bs_Notes";
    
    NSString *fullPath = [docsPath stringByAppendingPathComponent:uniquePath];
    return fullPath;
}

@end
