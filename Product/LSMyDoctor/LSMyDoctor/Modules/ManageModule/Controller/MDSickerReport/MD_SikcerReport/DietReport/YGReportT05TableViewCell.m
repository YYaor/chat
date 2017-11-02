//
//  YGReportT05TableViewCell.m
//  YouGeHealth
//
//  Created by luuuujun on 05/11/2016.
//
//

#import "YGReportT05TableViewCell.h"
#import "ThreeDimV.h"

@interface YGReportT05TableViewCell ()

@property (weak, nonatomic) IBOutlet ThreeDimV *radarMapView;

@end

@implementation YGReportT05TableViewCell

- (void)awakeFromNib {
    
    self.radarMapView.standardx = 100;
    self.radarMapView.standardy = 100;
    self.radarMapView.standardz = 100    ;
    
    self.radarMapView.x = 80;
    self.radarMapView.y = 60;
    self.radarMapView.z = 55;
}

- (void)setNamex:(NSString *)namex
{
    _namex = namex;
    self.radarMapView.namex = namex;
}

- (void)setNamey:(NSString *)namey
{
    _namey = namey;
    self.radarMapView.namey = namey;
}

- (void)setNamez:(NSString *)namez
{
    _namez = namez;
    self.radarMapView.namez = namez;
}

- (void)setStandardx:(CGFloat)standardx
{
    _standardx = standardx;
    self.radarMapView.standardx = standardx;
}

- (void)setStandardy:(CGFloat)standardy
{
    _standardy = standardy;
    self.radarMapView.standardy = standardy;
}

- (void)setStandardz:(CGFloat)standardz
{
    _standardz = standardz;
    self.radarMapView.standardz = standardz;
}

- (void)setX:(CGFloat)x
{
    _x = x;
    self.radarMapView.x = x;
}

- (void)setY:(CGFloat)y
{
    _y = y;
    self.radarMapView.y = y;
}

- (void)setZ:(CGFloat)z
{
    _z = z;
    self.radarMapView.z = z;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
