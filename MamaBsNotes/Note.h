//
//  Note.h
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : NSObject <NSCoding>

@property (strong, nonatomic) NSString *noteTitle;
@property (strong, nonatomic) NSString *noteBody;
@property (strong, nonatomic) UIImage *noteImage;
@property (strong, nonatomic) NSString *noteTime;

-(instancetype)initNoteWithTitle:(NSString *)title withBody:(NSString *) body withImage:(UIImage *)image withTime:(NSString *)time;

@end
