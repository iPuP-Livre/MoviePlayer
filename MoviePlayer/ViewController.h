//
//  ViewController.h
//  MoviePlayer
//
//  Created by Marian PAUL on 10/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController
{
    MPMoviePlayerViewController *_mPlayer;
    UIView *_overlayView;
    UISwitch *_switchOverlay;
    
    MPMoviePlayerController *_movieControllerSmall;
}

- (void) playVideoAtUrl:(NSURL*)movieURL;
- (void) presentMovieEmbedded;
- (void) createOverlayView;

@end
