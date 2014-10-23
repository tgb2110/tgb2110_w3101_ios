//
//  MainViewController.m
//  MamaBsNotes
//
//  Created by OB Troy on 10/22/14.
//  Copyright (c) 2014 OB Troy. All rights reserved.
//

#import "MainViewController.h"
#import "NoteTableViewCell.h"
#import "DataStore.h"
#import "AddNoteViewController.h"
#import "Note.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *noteTableView;
@property (strong, nonatomic) DataStore *dataStore;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    self.noteTableView.delegate = self;
    self.noteTableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
    
    
    NSLog(@"%ld", indexPath.row);
    
    //cell.previewImageView.image;
    cell.noteTitleLabel.text = @"Note label";
    cell.noteBodyLabel.text = @"This is the note body. It should be 3 lines";

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 124.0f;
}

#pragma mark - Table view delegate methods

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Deleting note at position : %ld", indexPath.row);
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddNoteViewController *newVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"newNoteSegue"]) {
        Note *newNote = [[Note alloc] init];
        newVC.selectedNote = newNote;
    }
    else if ([segue.identifier isEqualToString:@"detailNoteSegue"]) {
        //
    }
}


@end
