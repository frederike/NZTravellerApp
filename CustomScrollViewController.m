//
//  CustomScrollViewController.m
//  NZTravellerApp
//
//  Created by Frederike Schmitz on 01.11.13.
//  Copyright (c) 2013 Frederike Schmitz. All rights reserved.
//

#import "CustomScrollViewController.h"

@interface CustomScrollViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIButton *buttonMtM;
@property (nonatomic, strong) UIButton *buttonKari;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation CustomScrollViewController

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;
@synthesize buttonMtM, buttonKari;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)pressedMtM:(id)sender {
    
    [self performSegueWithIdentifier:@"MtM" sender:self];
    //perform segue
}

- (IBAction)pressedKari:(id)sender {
    
    [self performSegueWithIdentifier:@"Kari" sender:self];
    //perform segue
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.containerView];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}


- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"NewZealandMap.png"];
    UIImage *starIm = [UIImage imageNamed:@"Star.png"];
    
    // Set up the container view to hold your custom view hierarchy
    CGSize containerSize = image.size;
    
    CGFloat x = image.size.width;
    CGFloat y = image.size.height;
    
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    [self.scrollView addSubview:self.containerView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = CGPointMake(image.size.width/2.0f, image.size.height/2.0f);
    [self.containerView addSubview:imageView];
    
    
    UILabel  *labelMtM = [[UILabel alloc] initWithFrame:CGRectMake(x*0.731,y*0.285,800,200)];
    labelMtM.font=[labelMtM.font fontWithSize:100];
    labelMtM.text = @"Mt. Maunganui";
    [self.containerView addSubview:labelMtM];
    
    buttonMtM = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMtM setImage:starIm forState:UIControlStateNormal];
    buttonMtM.frame = CGRectMake(x*0.711,y*0.288,170,170);
    [buttonMtM addTarget:self action:@selector(pressedMtM:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:buttonMtM];
    
    
    UILabel  *labelKari = [[UILabel alloc] initWithFrame:CGRectMake(x*0.71,y*0.23,800,200)];
    labelKari.font=[labelMtM.font fontWithSize:100];
    labelKari.text = @"Karikari Estate";
    [self.containerView addSubview:labelKari];
    
    buttonKari = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonKari setImage:starIm forState:UIControlStateNormal];
    buttonKari.frame = CGRectMake(x*0.69,y*0.23,170,170);
    [buttonKari addTarget:self action:@selector(pressedKari:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:buttonKari];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    
    // Tell the scroll view the size of the contents
    self.scrollView.contentSize = containerSize;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end