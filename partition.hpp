//
//  partition.hpp
//  SwiftStitch
//
//  Created by apple on 12/9/16.
//  Copyright © 2016 ellipsis.com. All rights reserved.
//

#ifndef partition_hpp
#define partition_hpp

#include <opencv2/opencv.hpp>

cv::Mat partition (cv::Mat image);
std::vector<cv::Mat> partNum (cv::Mat src);

#endif /* partition_hpp */
