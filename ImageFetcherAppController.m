//
//  ImageFetcherAppController.m
//
//  Created by Alexander Repty on 28.09.09.
// 
//  Copyright (c) 2009, Alexander Repty
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//  Neither the name of Alexander Repty nor the names of his contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

#import "ImageFetcherAppController.h"
#import "ImageFetchOperation.h"

@implementation ImageFetcherAppController

@synthesize window = _window;
@synthesize imageView = _imageView;
@synthesize progressIndicator = _progressIndicator;

- (id)init {
	if (self = [super init]) {
		_queue = [NSOperationQueue new];
	}
	return self;
}

- (void)dealloc {
	[_queue release];
	[super dealloc];
}

- (void)awakeFromNib {
	[_progressIndicator startAnimation:self];
	NSURL *url = [NSURL URLWithString:@"http://alexrepty.com/other/kiwi.jpg"];
	ImageFetchOperation *operation = [[[ImageFetchOperation alloc] initWithURL:url delegate:self] autorelease];
	[_queue addOperation:operation];
}

- (void)didReceiveImage:(NSImage *)image {
	[_progressIndicator stopAnimation:self];
	[_imageView setImage:image];
	NSRect newWindowFrame;
	newWindowFrame.origin = [_window frame].origin;
	newWindowFrame.size = [image size];
	newWindowFrame.size.height += 22; // toolbar
	[_window setFrame:newWindowFrame display:YES animate:YES];
}

- (void)errorOccurred:(NSError *)error {
	[_progressIndicator stopAnimation:self];
	NSAlert *alert = [NSAlert alertWithError:error];
	[alert beginSheetModalForWindow:_window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

@end
