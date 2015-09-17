#import <UIKit/UIKit.h>

@class TodoCollectionView;
@class ToDoModel;

@protocol TodoCollectionDelegate <NSObject>

- (void)todoCollectionView:(TodoCollectionView *)collectionView didSelectTodo:(ToDoModel *)todo;

@end

@interface TodoCollectionView : UICollectionView <UICollectionViewDataSource,
                                                  UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) id customDelegate;
@property (nonatomic, assign) CGSize ItemSize;

@end
