//
//  DataStore.h
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataStore : NSObject

@property (strong, nonatomic) NSMutableArray *notesArray;



+ (instancetype)sharedDataStore;

-(void) saveNotes;

- (void)retrieveNotesWithBlock:(void (^)(BOOL))completion;

-(void)createNoteWithTitle:(NSString *)title withBody:(NSString *)body withImage:(UIImage *)image;

@end
