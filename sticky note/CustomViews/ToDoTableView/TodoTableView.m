#import "TodoTableView.h"

static NSString* cellIdentifier = @"TodoTableCell";

@implementation TodoTableView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	if (self) {
		// Initialization code
		NSArray *arrayOfViews =
			[[NSBundle mainBundle] loadNibNamed:@"TodoTableView" owner:self options:nil];
		
		if ([arrayOfViews count] < 1) {
			return nil;
		}
		
		if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[TodoTableView class]]) {
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
	
}

@end
