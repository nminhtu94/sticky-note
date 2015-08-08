//
//  ViewNoteViewController.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/27/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "ViewNoteViewController.h"
#import "NoteModel.h"

@interface ViewNoteViewController ()

@end

@implementation ViewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationItem setTitle:self.note.title];
	[self.noteText setAttributedText:[self.note text]];
	[self.drawingImage setImage:[UIImage imageWithData:self.note.sketch]];
	[self.noteImage setImage:[UIImage imageWithData:self.note.image]];
}

@end
