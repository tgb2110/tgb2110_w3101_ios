//
//  Note.m
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)init
{
    UIImage *placeholderImage = [UIImage imageNamed:@"Note-Icon.jpg"];
    NSString *placeholderTitle = @"Please enter your note title here.";
    NSString *placeholderBody = @"Please enter the body of your note here.";
    NSString *placeholderTime = @"";
    return [self initNoteWithTitle:placeholderTitle withBody:placeholderBody withImage:placeholderImage withTime:placeholderTime];
}

-(instancetype)initNoteWithTitle:(NSString *)title withBody:(NSString *) body withImage:(UIImage *)image withTime:(NSString *)time {
    self = [super init];
    if (self) {
        NSDate *today = [NSDate date];
        NSString *dateAndTime = [NSString stringWithFormat:@"Note Created : %@", today];
        _noteTitle = title;
        _noteBody = body;
        _noteImage = image;
        _noteTime = dateAndTime;
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.noteTitle forKey:NSStringFromSelector(@selector(noteTitle))];
    [aCoder encodeObject:self.noteBody forKey:NSStringFromSelector(@selector(noteBody))];
    [aCoder encodeObject:self.noteImage forKey:NSStringFromSelector(@selector(noteImage))];
    [aCoder encodeObject:self.noteTime forKey:NSStringFromSelector(@selector(noteTime))];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.noteTitle = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(noteTitle))];
        self.noteBody = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(noteBody))];
        self.noteImage = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(noteImage))];
        self.noteTime = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(noteTime))];
    }
    return self;
}

@end
