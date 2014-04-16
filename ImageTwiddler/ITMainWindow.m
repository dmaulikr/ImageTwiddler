//
//  ITMainWindow.m
//  ImageTwiddler
//
//  Created by Ryan Tempas on 4/15/14.
//  Copyright (c) 2014 Tauer Productions. All rights reserved.
//

#import "ITMainWindow.h"
#import "ITImageTableCellView.h"
#import "EffectsConstants.h"
#import "ITImageProcessor.h"
#import "ITRenderedImageObject.h"

static NSInteger NumberOfImages = 11;

static NSString * GaussianBlurEffectTitle = @"Gaussian Blur";
static NSString * BlackAndWhiteEffectTitle = @"Black and White";

@interface ITMainWindow()

@property (nonatomic, retain) NSMutableArray *images;

@end

@implementation ITMainWindow

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}
-(id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if (self)
    {
        [self initializeImages];

        _detailImageView.image = nil;
        _detailImageView.imageScaling = NSScaleProportionally;
    }
    
    return self;
}

-(void) awakeFromNib
{
    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [self initializeEffectPopupButton];
    [self initializeThreadPopupButton];
    
    [_resetButton setAlphaValue:0];
}

-(void) initializeImages
{
    _images = [[NSMutableArray alloc] init];
    for (int i = 0; i < NumberOfImages; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"image%d", i ];
        NSImage *image = [NSImage imageNamed:imageName];
        [_images addObject:image];
    }
}

-(void) initializeThreadPopupButton
{
    [_threadCountPopupButton removeAllItems];
    [_threadCountPopupButton addItemsWithTitles:@[@"1", @"2", @"4", @"8", @"16"]];
}

-(void) initializeEffectPopupButton
{
    [_effectPopupButton removeAllItems];
    [_effectPopupButton addItemsWithTitles:@[BlackAndWhiteEffectTitle, GaussianBlurEffectTitle]];
}


#pragma mark NSTableView datasource methods

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_images count];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    ITImageTableCellView *result = (ITImageTableCellView *)[tableView makeViewWithIdentifier:ImageTableCellIdentifier owner:self];
    
    result.imageView.image = _images[row];
    return result;
    
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = [_tableView selectedRow];

    if (selectedRow != -1) {
        _detailImageView.image =_images[selectedRow];
        _detailImageView.alphaValue = 1;
    }
    else {
        _detailImageView.image = nil;
    }
}

- (IBAction)renderButtonPressed:(id)sender {
    [self enableControls:NO];
    _resetButton.alphaValue = 1;
    
    NSInteger selectedThreadIndex = [_threadCountPopupButton indexOfSelectedItem];
    NSInteger numberOfThreads = pow(2, selectedThreadIndex);
    
    ITImageEffect effectToApply = (ITImageEffect)[_effectPopupButton indexOfSelectedItem];
    
    NSImage *selectedImage = _images[[_tableView selectedRow]];
    CGImageSourceRef source;
    source = CGImageSourceCreateWithData((__bridge CFDataRef)[selectedImage TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    ITRenderedImageObject * result = [ITImageProcessor ApplyEffect:effectToApply toSourceImage:maskRef withThreads:numberOfThreads];
    
    NSImage *resultImage = [[NSImage alloc] initWithCGImage:result.image size:selectedImage.size];
    _detailImageView.image = resultImage;
}

- (IBAction)resetButtonPressed:(id)sender {
    [self enableControls:YES];
    _resetButton.alphaValue = 0;
    
    _detailImageView.image = _images[[_tableView selectedRow]];
}

-(void) enableControls:(BOOL)enable
{
    [_renderButton setEnabled:enable];
    [_threadCountPopupButton setEnabled:enable];
    [_effectPopupButton setEnabled:enable];
}
@end
