//
//  Forever_StarsView.m
//  Forever Stars
//
//  Created by Schlotts on 30/09/2009.
//  Copyright (c) 2009, opanoid.com. All rights reserved.
//

#import "Forever_StarsView.h"


@implementation Forever_StarsView

// Declare all required variables
#define stars 500
#define star_top_speed 200

int		i, 
		overall_speed;
float	x_position[stars],
		y_position[stars],
		z_position[stars],
		star_speed[stars];
float	screen_x,
		screen_y,
		old_x, 
		old_y;
float	red_colour, 
		blue_colour, 
		green_colour;
NSTimer *timer;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		[self setAnimationTimeInterval:1/60.0];
		
		// Set up variables required
		//screen_size = [self bounds].size;
		overall_speed=SSRandomFloatBetween(20,star_top_speed);
		
		// Set First Colour of Stars
		red_colour=SSRandomFloatBetween(0.1,1);
		blue_colour=SSRandomFloatBetween(0.1,1);
		green_colour=SSRandomFloatBetween(0.1,1);
		
		// Loop through the X,Y,Z and speed of the stars populating each field
		for (i=0; i<stars; i++)
		{
			star_speed[i] = SSRandomIntBetween(1,10); 
			x_position[i] = SSRandomFloatBetween(-([self bounds].size.width*2), ([self bounds].size.width*2));
			y_position[i] = SSRandomFloatBetween(-([self bounds].size.height*2), ([self bounds].size.height*2));		
			z_position[i] = SSRandomFloatBetween(100, 500);
		}
		
    }
	// Sets up a timer of 10 seconds, which changes the colour and speed when called.
	timer = [NSTimer scheduledTimerWithTimeInterval: 10
											target: self
										  selector: @selector(handleTimer:)
										  userInfo: nil
										   repeats: YES];
    return self;
	
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
	// Now paint the background black
	[[NSColor blackColor] set];
	[NSBezierPath fillRect: [self bounds]];
	
	// Loop Through the Stars
	for (i=0; i<stars; i++)
	{
		// Get the Current Position of the Star before we move it.
		old_x = (x_position[i]/z_position[i])*500 + [self bounds].size.width/2;
		old_y = y_position[i]/z_position[i]*500 + [self bounds].size.height/2;
		
		// Move the Stars Z position (in effect moving it close to us
		z_position[i]=z_position[i]-(star_speed[i]+overall_speed);
		
		// Get the Current Position of the Star after adjusting it's position
		screen_x=(x_position[i]/z_position[i])*500 + [self bounds].size.width/2;
		screen_y=(y_position[i]/z_position[i])*500 + [self bounds].size.height/2;
		
		// Check the Star has not gone off the screen
		if ((screen_x>[self bounds].size.width) || (screen_x<0) || (screen_y>[self bounds].size.height) || (screen_y<0) || (z_position[i]<=0)) 
		{ 
			// If the star has gone of the screen create a new star X,Y,Z and Speed
			star_speed[i] = SSRandomIntBetween(1,10); 
			x_position[i] = SSRandomFloatBetween(-([self bounds].size.width*2), ([self bounds].size.width*2));
			y_position[i] = SSRandomFloatBetween(-([self bounds].size.height*2), ([self bounds].size.height*2));		
			z_position[i] = SSRandomFloatBetween(100, 10000);
			// Because it has left the screen make sure the old position is the same as the new position else a 'flashing' of the line will appear
			old_x = screen_x;
			old_y = screen_y;
		}
		
		// Set the colour for the star to be drawn
		[[NSColor colorWithCalibratedRed:red_colour green:green_colour blue:blue_colour alpha:1.0f] set]; 
		
		// The all important Drawing of the Line.
		// This moves to the last point of the star then to the new point a thus creates a 'warp' effect of the line.
		// This is a useful technique rather than plotting a point as the point will appear to 'jump' position as it moves making it look a bit rubbish
		NSBezierPath* draw_line = [NSBezierPath bezierPath];
		[draw_line moveToPoint:NSMakePoint(old_x,old_y)];
		[draw_line lineToPoint:NSMakePoint(screen_x, screen_y)];
		[draw_line setLineWidth:1.5];
		[draw_line stroke];
	}
	
	
	// If you want to draw something on top of all the stars, here is the place to do it
	
    return;	
}

- (void) handleTimer: (NSTimer *) timer
{
    overall_speed=SSRandomFloatBetween(20,star_top_speed);
	red_colour=SSRandomFloatBetween(0.1,1);
	blue_colour=SSRandomFloatBetween(0.1,1);
	green_colour=SSRandomFloatBetween(0.1,1);
	
} 

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
