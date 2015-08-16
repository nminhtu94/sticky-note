#import "DrawingPadView.h"

@interface DrawingPadView()

@end

@implementation DrawingPadView
@synthesize incrementalImage = _incrementalImage;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
	{
		[self setMultipleTouchEnabled:NO];
		[self setBackgroundColor:[UIColor whiteColor]];
		self.brushColor = [UIColor blackColor];
		_path = [UIBezierPath bezierPath];
		[_path setLineWidth:1.0f];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[_incrementalImage drawInRect:rect]; // (3)
	[_path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[_path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	[_path addLineToPoint:p];
	[self drawBitmap];
	[self setNeedsDisplay];
	[_path removeAllPoints];
	[_path moveToPoint:p];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
	[self.brushColor setStroke];
	if (!_incrementalImage) // first draw; paint background white by ...
	{
		// enclosing bitmap by a rectangle defined by another UIBezierPath object.
		UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
		[[UIColor whiteColor] setFill];
		[rectpath fill]; // filling it with white
	}
	[_incrementalImage drawInRect:self.bounds];
	[_path stroke];
	_incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)setSketchImage:(UIImage *)sketchImage {
	_incrementalImage = sketchImage;
	[_incrementalImage drawInRect:self.bounds];
	[self setNeedsDisplay];
}
@end
