//
//  MusicViewController.m
//  Music
//
//  Created by ibokan on 12-12-27.
//  Copyright (c) 2012年 ibokan. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController
@synthesize str;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [audioPlayer release];
    [label release];
    [pView release];
    [str release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=str;
    
    NSString *path=[[NSBundle mainBundle]pathForResource:str ofType:@"mp3"];//获取本地音频资源
 
    NSURL *url=[[[NSURL alloc]initFileURLWithPath:path]autorelease];//创建本地url
    NSError *error;
   
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];//创建音乐播放器使用本地url
    if (error) {
        
        NSLog(@"%@",[error localizedDescription]);
    }//判断是否创建成功
    
    
    [audioPlayer prepareToPlay];//创建成功后准备播放
    
    NSMutableArray *items=[[NSMutableArray alloc]initWithObjects:@"play",@"pause",@"stop",@"rewind",@"forwar", nil];
    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:items];
    segment.frame=CGRectMake(0, 360, 320, 40);
    segment.segmentedControlStyle=UISegmentedControlStylePlain;
    [segment addTarget:self action:@selector(segmentTapped:) forControlEvents:(UIControlEventValueChanged)];
    segment.selectedSegmentIndex=1;
    [self.view addSubview:segment];
    
    UISwitch *theSwith=[[UISwitch alloc]initWithFrame:CGRectMake(100, 100, 60, 30)];
    theSwith.on=YES;
    [theSwith addTarget:self action:@selector(closeOrOpen:) forControlEvents:(UIControlEventValueChanged)];
    theSwith.onTintColor=[UIColor redColor];
    [self.view addSubview:theSwith];
    
    slider=[[UISlider alloc]initWithFrame:CGRectMake(10, 50, 310, 30)];
    slider.backgroundColor=[UIColor clearColor];
    slider.minimumValue=0.0;
    slider.maximumValue=1.0;
    slider.value=0.5;
    [slider addTarget:self action:@selector(sliderEvent) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:slider];
    
    pView=[[UIProgressView alloc]initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    pView.progressTintColor=[UIColor redColor];
    pView.trackTintColor=[UIColor yellowColor];
    pView.frame=CGRectMake(50, 200, 220, 30);
    pView.progress=0;
    [self.view addSubview:pView];
    
    label=[[UILabel alloc]init];
    label.textColor=[UIColor blackColor];
    label.frame=CGRectMake(50, 230, 220, 50);
    [self.view addSubview:label];
    
    [self ziDingYiDaoHangKongZhiQi];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showProgress) userInfo:nil repeats:YES];

    [url  release];
    [url release];
    [slider release];
    [theSwith release];
    [items release];
    [segment release];
}

-(void)sliderEvent
{
    audioPlayer.volume=slider.value;
}
-(void)ziDingYiDaoHangKongZhiQi
{
    UIView *view=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, 46, 44))];
    UIButton *but=[UIButton buttonWithType:(UIButtonTypeCustom)];
    but.frame=CGRectMake(5, 5, 52, 30);
    [but setTitle:@"返回" forState:(UIControlStateNormal)];
    [but addTarget:self action:@selector(doBack) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:but];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:view]autorelease];
    [view release];
}
-(void)doBack
{
    [audioPlayer stop];
    audioPlayer.currentTime=0;
    pView.progress=0;
    label.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showProgress
{
     
    if (audioPlayer.isPlaying) {
        pView.progress=audioPlayer.currentTime/audioPlayer.duration;
        int percent=(int)(pView.progress *100);
        int current=(int)audioPlayer.currentTime;
        int duration=(int)audioPlayer.duration;
//        NSString *temp=[NSString stringWithFormat:@"进度:%3d%% %3d/%3d",percent,current,duration];
//        
//        label.text=temp;
//        
        
        label.text=[NSString stringWithFormat:@"进度:%3d%% %3d/%3d",percent,current,duration];
        
        
    }
}
-(void)closeOrOpen:(UISwitch *)s
{
    audioPlayer.volume=s.on;
}
-(void)segmentTapped:(UISegmentedControl *)seg
{
    
    int selectedIndex=seg.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            
            [audioPlayer play];
            break;
        case 1:
            [audioPlayer pause];
            break;
        case 2:
            [audioPlayer stop];
            audioPlayer.currentTime=0;
            pView.progress=0;
            label.text=@"";
            break;
        case 3:
            audioPlayer.currentTime-=3 ;
            [self showProgress];
            break;
        case 4:
            audioPlayer.currentTime+=3 ;
            [self showProgress];;
            break;
            
        default:
            break;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
