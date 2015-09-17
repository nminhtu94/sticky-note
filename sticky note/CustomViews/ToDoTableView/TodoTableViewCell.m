#import "TodoTableViewCell.h"

#import "Utility.h"

@interface TodoTableViewCell()

@property (nonatomic, assign) STATES state_;

@end

@implementation TodoTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
  [self.contentView setBackgroundColor:THEME_COLOR_DARKER];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)enableEditting {
	[self.txfTitle setEnabled:YES];
  [self.btnSave setImage:[UIImage imageNamed:@"check_todo"] forState:UIControlStateNormal];
  self.state_ = EDITING;
	[self.txfTitle becomeFirstResponder];
}

- (void)disableEditting {
	[self.txfTitle setEnabled:NO];
  [self.btnSave setImage:[UIImage imageNamed:@"remove_todo"] forState:UIControlStateNormal];
  self.state_ = DISABLED;
	[self.txfTitle resignFirstResponder];
}

- (void)shakeView {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
	animation.duration = 0.05;
	animation.byValue = @(20);
	animation.autoreverses = YES;
	animation.repeatCount = 3;
	[self.contentView.layer addAnimation:animation forKey:@"Shake"];
}

- (IBAction)onSave:(id)sender {
  if (self.delegate) {
    if (self.state_ == EDITING) {
      [self.delegate saveTodoForCell:self];
    } else if (self.state_ == DISABLED) {
      [self.delegate removeTodoForCell:self];
    }
  }
}

@end
