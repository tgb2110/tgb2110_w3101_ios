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
    
    [self setUpVariablesAndDelegates];

}

-(void)viewWillAppear:(BOOL)animated {
    [self.noteTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpVariablesAndDelegates {
    self.dataStore = [DataStore sharedDataStore];
    self.noteTableView.delegate = self;
    self.noteTableView.dataSource = self;
    [self.dataStore retrieveNotesWithBlock:^(BOOL success) {
        if (success) {
            [self.noteTableView reloadData];
        }
    }];
}

#pragma mark - Tableview Datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataStore.notesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
    
    Note *currentNote = self.dataStore.notesArray[indexPath.row];
    
    cell.previewImageView.image = currentNote.noteImage;
    cell.noteTitleLabel.text = currentNote.noteTitle;
    cell.noteBodyLabel.text = currentNote.noteBody;
    cell.noteTimeLabel.text = currentNote.noteTime;

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
    
    [self.dataStore.notesArray removeObjectAtIndex:indexPath.row];
    [self.dataStore saveNotes];
    [self.noteTableView reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.noteTableView indexPathForSelectedRow];
    
    AddNoteViewController *newVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"detailNoteSegue"]) {
        newVC.selectedNote = [self.dataStore.notesArray objectAtIndex:indexPath.row];
    }
}


@end
