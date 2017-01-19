//
//  partition.cpp
//  SwiftStitch
//
//  Created by apple on 12/9/16.
//  Copyright © 2016 ellipsis.com. All rights reserved.
//

#include "partition.hpp"
#include <iostream>
#include <fstream>

//openCV 2.4.x
//#include "opencv2/stitching/stitcher.hpp"

//openCV 3.x
#include "opencv2/stitching.hpp"

using namespace std;
using namespace cv;

int cutPoint[10];       //存储切割点横坐标
int cutNum=0;               //切割点数目
int height = 1;    //阈值，投影array元素大于height才代表此处存在有效数字
int width = 1;     //阈值，投影array连续0数目大于width才代表此处数字疏离

cv::Mat partition (cv::Mat image){
    
    Mat src=image;
    Mat dst;    //输出图
    Mat gray;   //灰度图
    Mat edge;   //用于降噪
    Mat ero;    //用于腐蚀
    Mat dil;    //用于膨胀
    
    //创建与src同类型和大小的矩阵(dst)
    dst.create( src.size(), src.type() );
    
    //将原图像转换为灰度图像
    cvtColor( src, gray, CV_BGR2GRAY );
    
    //先用使用 3x3内核来降噪
    //blur( gray, edge, Size(3,3));
    
    // 转为二值图
    threshold(gray, ero , 150 , 255, THRESH_BINARY);
    // 参数：输入数组src，输出数组dst，阈值（otsu算法自动生成），阈值类型最大值，阈值类型
    
    //腐蚀操作
    erode(ero,dil,Mat(3,3,CV_8U),Point(0,0),0);
    //参数：输入，输出，腐蚀单元大小（5*5，8位），腐蚀位置中心，腐蚀次数
    //单元越大，效果越明显
    
    //膨胀操作
    dilate(dil,dst,Mat(3,3,CV_8U),Point(0,0),0);
    //参数：输入，输出，单元大小，膨胀位置，膨胀次数
    
    //垂直方向进行累加（积分）
    int i,j;
    int count = 0;  //缓存当前连续空白数组元素个数
    int* v = new int[dst.cols*2];   //统计每列黑色像素数量
    int k=0;
    
    for( i=0; i<dst.cols; i++)          //列
    {
        //初始化
        v[i]=0;
        cutNum=0;
        for( j=0; j<dst.rows; j++)      //行
        {
            if( dst.at<uchar>( j, i ) == 0)    //统计的是黑色像素的数量
                v[i]++;
        }
    }
    
    k=0;
    for( i=0; i<dst.cols; i++)
    {
        if(v[i]<=height)    count += 1;
        else if(count>width)
        {
            cutPoint[k]=i-count/2;    //标记切割点
            cutPoint[k+1]=-1;//标记下一个cutPoint为无效
            k++;
            cutNum++;
            count=0;
        }//如果当前是连续0进入!0状态，则计算切割点
        else count=0;       //否则说明在连续!0状态，归零count即可
    }
    delete [] v;
    return dst;
}

std::vector<cv::Mat> partNum(Mat src){
    
    std::vector<cv::Mat> dstImages;
    partition(src);
    int index = 0;
    int left;
    int right;
    int height = src.size().height;
    Mat roi;
    
    for (index=0;index<cutNum;index++){
        //切割，提取第index个部分，index从0取到cutNum-1
        //即提取cutPoint[index]到cutpoint[index＋1]之间的图片
        
        left = (index==0?0:cutPoint[index]);
        //如果index为第一个分割点，则将下一个分割点设置为图片最左端
        right = (cutPoint[index+1]==-1?src.size().width:cutPoint[index+1]);
        //如果index为最后一个分割点，则将下一个分割点设置为图片最右端
        
        Rect rect(left,0,right-left,height);
        //参数为：（x，y）坐标，宽度，高度
        src(rect).copyTo(roi);
        dstImages.push_back(roi);
    }
    return dstImages;
}
