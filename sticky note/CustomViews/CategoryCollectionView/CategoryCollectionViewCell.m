#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell

- (void)awakeFromNib {
  [self.imgIcon.layer setCornerRadius:5.0f];
  [self.imgIcon setClipsToBounds:YES];
}

@end
