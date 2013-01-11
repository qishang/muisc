//
//  MusicViewController.h
//  Music
//
//  Created by ibokan on 12-12-27.
//  Copyright (c) 2012年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicViewController : UIViewController
{
    AVAudioPlayer *audioPlayer;
    UIProgressView *pView;
    UILabel *label;
    NSString *str;
    UISlider *slider;
}
@property(nonatomic,retain)NSString *str;

@end
