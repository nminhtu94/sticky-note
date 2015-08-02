#import "DrawingPadView.h"

@interface DrawingPadView()

@end

@implementation DrawingPadView
@synthesize incrementalImage = _incrementalImage;
@synthesize brushColor = _brushColor;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
	{
		[self setMultipleTouchEnabled:NO];
		[self setBackgroundColor:[UIColor whiteColor]];
		_brushColor = [UIColor blackColor];
		_path = [UIBezierPath bezierPath];
		[_path setLineWidth:1.0f];
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	[_incrementalImage drawInRect:rect]; // (3)
	[_path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[_path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[_path addLineToPoint:p];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event // (2)
{
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[_path addLineToPoint:p];
	[self drawBitmap]; // (3)
	[self setNeedsDisplay];
	[_path removeAllPoints]; //(4)
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap // (3)
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
	[_brushColor setStroke];
	if (!_incrementalImage) // first draw; paint background white by ...
	{
		// enclosing bitmap by a rectangle defined by another UIBezierPath object.
		UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
		[[UIColor whiteColor] setFill];
		[rectpath fill]; // filling it with white
	}
	[_incrementalImage drawAtPoint:CGPointZero];
	[_path stroke];
	_incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (UIImage *)getDrawingImage {
	return _incrementalImage;
}

@end
