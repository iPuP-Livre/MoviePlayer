//
//  ViewController.m
//  MoviePlayer
//
//  Created by Marian PAUL on 10/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        UIButton *localButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [localButton addTarget:self action:@selector(playVideoLocally:) forControlEvents:UIControlEventTouchUpInside];
        [localButton setTitle:@"Local" forState:UIControlStateNormal];
        [localButton setFrame:CGRectMake(30, 30, 115, 30)];
        [self.view addSubview:localButton];
        
        UIButton *webButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [webButton addTarget:self action:@selector(playVideoFromWeb:) forControlEvents:UIControlEventTouchUpInside];
        [webButton setTitle:@"Web" forState:UIControlStateNormal];
        [webButton setFrame:CGRectMake(175, 30, 115, 30)];
        [self.view addSubview:webButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 260, 30)];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Afficher vos propres contrôles ?";
        [self.view addSubview:label];
        
        _switchOverlay = [[UISwitch alloc] initWithFrame:CGRectMake(120, 130, 0, 0)];
        [self.view addSubview:_switchOverlay];
        
        
        [self presentMovieEmbedded];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Actions
- (void) playVideoFromWeb :(id)sender {
    [self playVideoAtUrl:[NSURL URLWithString:@"http://www.ipup.fr/livre/Lucky_man_pres.mov"]];
}

- (void) playVideoLocally :(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Lucky_man_pres" ofType:@"mov"];    
    if (path) {
        [self playVideoAtUrl:[NSURL fileURLWithPath:path]];
    }
}

- (void) pauseResumeVideo : (id) sender 
{
    UIButton *but = (UIButton*)sender;
    
    if (but.selected)
        [_mPlayer.moviePlayer play];
    else
        [_mPlayer.moviePlayer pause];
    
    // on change l'état du bouton
    but.selected = !but.selected;
}

- (void) exitVideo : (id) sender 
{
    [_mPlayer.moviePlayer stop];
}

#pragma mark - Video Player

- (void) createOverlayView 
{
    // si elle existe déjà, on quitte
    if (_overlayView) return;
    // sinon, on la crée
    _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    // on peut définir une opacité
    _overlayView.alpha = 0.8;
    
    UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pauseButton addTarget:self action:@selector(pauseResumeVideo:) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseButton setTitle:@"Resume" forState:UIControlStateSelected];
    [pauseButton setFrame:CGRectMake(175, 30, 115, 30)];
    [_overlayView addSubview:pauseButton];    
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [quitButton addTarget:self action:@selector(exitVideo:) forControlEvents:UIControlEventTouchUpInside];
    [quitButton setTitle:@"Stop" forState:UIControlStateNormal];
    [quitButton setFrame:CGRectMake(25, 30, 115, 30)];
    [_overlayView addSubview:quitButton];  
 
}

- (void) playVideoAtUrl:(NSURL*)movieURL {
    if(!_mPlayer)
        _mPlayer = [[MPMoviePlayerViewController alloc] init];
    
    _mPlayer.moviePlayer.contentURL = movieURL;

    // on met la vidéo en plein écran
    _mPlayer.moviePlayer.fullscreen = YES;
    
    if (_switchOverlay.on)
    {
        // on ajoute la vue d'overlay
        [self createOverlayView];
        if ([_overlayView superview] == nil) {
            [_mPlayer.moviePlayer.view addSubview:_overlayView];
        }
        // on enlève les controls pour mettre les nôtres
        _mPlayer.moviePlayer.controlStyle = MPMovieControlStyleNone;
    }
    else 
    {
        // on l'enlève
        [_overlayView removeFromSuperview];
        // on mets les contrôles par défaut en mode plein écran
        _mPlayer.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;    
    }
    
    // on affiche la vidéo
    [self presentMoviePlayerViewControllerAnimated:_mPlayer];
    // on joue
    [_mPlayer.moviePlayer play];
}

#pragma mark - Petit lecteur 

- (void) presentMovieEmbedded 
{
    // la vue qui va contenir notre lecteur
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(30, 200, 260, 200)];
    
    // initialisation du contrôleur
    _movieControllerSmall = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.ipup.fr/livre/Lucky_man_pres.mov"]];
    // on définit sa taille
    _movieControllerSmall.view.frame = CGRectMake(0, 0, 260, 200);
    // on définit la couleur du fond
    _movieControllerSmall.backgroundView.backgroundColor = [UIColor clearColor];
    // on définit une répétion de la lecture lorsque la vidéo est finie
    _movieControllerSmall.repeatMode = MPMovieRepeatModeOne;
    // on ajoute le player
    [myView addSubview:_movieControllerSmall.view];
    // on ajoute la vue
    
    [self.view addSubview:myView];
    // on lance la lecture
    [_movieControllerSmall play];
}

#pragma mark - Notification

- (void) moviePlayBackDidFinish : (NSNotification*)notif {
    NSLog(@"%@", notif);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
