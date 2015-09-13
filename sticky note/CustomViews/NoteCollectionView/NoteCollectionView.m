//
//  NoteCollectionView.m
//  sticky note
//
//  Created by Nguyen Minh Tu on 7/4/15.
//  Copyright (c) 2015 Apps Fellow. All rights reserved.
//

#import "NoteCollectionView.h"
#import "NoteHelper.h"
#import "CAImageCollectionLayout.h"
#import "NoteCollectionViewCell.h"

@implementation NoteCollectionView
@synthesize notes, customDelegate;

static NSString* cellIdentifier = @"NoteCollectionCell";

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews =
			[[NSBundle mainBundle] loadNibNamed:@"NoteCollectionView" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[NoteCollectionView class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        [self setFrame:frame];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    [self setDelegate:self];
    [self setDataSource:self];
}

- (void)setup {
    [self registerNib:
	 	[UINib nibWithNibName:@"NoteCollectionViewCell"
					   bundle:[NSBundle mainBundle]]
		forCellWithReuseIdentifier:cellIdentifier];
    [self setBackgroundColor:[UIColor clearColor]];
	CAImageCollectionLayout* imageLayout = [[CAImageCollectionLayout alloc] init];
	[imageLayout setItemSize:CGSizeMake(100, 100)];
	[imageLayout setNumberOfColumns:self.frame.size.width / 100];
	[imageLayout setItemInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	[self setCollectionViewLayout:imageLayout];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section {
    return notes.count;
}

#pragma mark <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteCollectionViewCell *cell =
		(NoteCollectionViewCell *)[self dequeueReusableCellWithReuseIdentifier:cellIdentifier
																  forIndexPath:indexPath];
    
    NoteModel *note = [notes objectAtIndex:indexPath.row];
    [cell.lblTitle setText:note.title];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
	didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NoteModel *note = (NoteModel *)[notes objectAtIndex:indexPath.row];
	
	if (customDelegate) {
		[customDelegate noteCollectionView:self didSelectNote:note];
	}
}

@end
