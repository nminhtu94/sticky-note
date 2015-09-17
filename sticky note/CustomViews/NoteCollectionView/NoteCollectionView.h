#import <UIKit/UIKit.h>

@class NoteCollectionView;
@class NoteModel;

@protocol NoteCollectionViewDelegate <NSObject>

- (void)noteCollectionView:(NoteCollectionView *)collectionView didSelectNote:(NoteModel *)note;

@end

@interface NoteCollectionView : UICollectionView<UICollectionViewDataSource,
												 UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, assign) id customDelegate;

@end
