//
//  ViewController.m
//  OctcatRun
//
//  Created by fujiwara.kota on 2015/01/16.
//  Copyright (c) 2015年 fujiwara.kota. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) UIImageView *octcatView;
@property (nonatomic) float octcatX;
@property (nonatomic) float octcatY;
@property (nonatomic) float octcatVelocityY;

@property (nonatomic) float enemyX;
@property (nonatomic) float enemyY;
@property (nonatomic) UIImageView *enemyView;

@property (nonatomic) int score;
@property (nonatomic) UILabel *scoreLabel;

@property (nonatomic) BOOL gameOver;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    UIView *controlView = [[UIView alloc] initWithFrame:windowFrame];
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [controlView addGestureRecognizer:singleTapRecognizer];
    
    UIImage *octcatImage = [UIImage imageNamed:@"Octocat.png"];
    self.octcatView = [[UIImageView alloc] initWithImage:octcatImage];

    UIImage *enemyImage = [UIImage imageNamed:@"Octocat.png"];
    self.enemyView = [[UIImageView alloc] initWithImage:enemyImage];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 40, 100, 30)];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 350, windowFrame.size.width, 1)];
    horizontalLine.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scoreLabel];
    [self.view addSubview:horizontalLine];
    [self.view addSubview:self.enemyView];
    [self.view addSubview:self.octcatView];
    [self.view addSubview:controlView];
    
    [self resetGame];
}

- (void)resetGame
{
    self.gameOver = NO;
    
    self.score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.score];
    
    self.octcatX = 0;
    self.octcatY = 300;
    self.octcatVelocityY = 0;
    [self moveOctcat];
    
    self.enemyX = 320;
    self.enemyY = 300;
    self.octcatVelocityY = 0;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
}

- (void)moveOctcat
{
    self.octcatView.frame = CGRectMake(self.octcatX, self.octcatY, 50, 50);
}

- (void)moveEnemy
{
    self.enemyView.frame = CGRectMake(self.enemyX, self.enemyY, 50, 50);
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.gameOver) {
        [self resetGame];
        return;
    }
    if (self.octcatY >= 295) {
        self.octcatVelocityY = -7.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTick:(NSTimer *)timer {
   
    self.octcatY += self.octcatVelocityY;
    if (self.octcatY <= 230) {
        self.octcatVelocityY = 7.0;
    } else if (self.octcatY > 300){
        self.octcatY = 300.0;
        self.octcatVelocityY = 0;
    }
    [self moveOctcat];
    
    self.enemyX -= 8.0;
    if (self.enemyX < -50) {
        self.enemyX = [[UIScreen mainScreen] bounds].size.width;
    }
    [self moveEnemy];
    
    if (self.octcatX + 25 >= self.enemyX && self.octcatX <= self.enemyX + 25) {
        if (self.octcatY <= self.enemyY && self.octcatY + 30 >= self.enemyY) {
            [timer invalidate];
            self.gameOver = YES;
        }
    }
    
    self.score += 1;
    self.scoreLabel.text = [NSString stringWithFormat:@"score:%d",self.score];
}

@end
