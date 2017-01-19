# Partition
A swift project using OpenCV to do Captcha segmentation designed by Ruiji Wang

It also demonstrates how to mix Swift, Objective-C and C++ in one project whilst keeping the code clearly separate. 

The project AppDelegate and View Controller are written in Swift. Swift cannot talk directly to C++ (which we need for OpenCV), so we provide an Objective-C++ wrapper class to mediate between Swift and C++. We also provide an Objective-C++ category on UIImage to mediate between UIImage and CV::Mat image formats. The CVWrapper header file is pure Objective-C.

###Requirements
iOS 9.0+

xCode 8

###Installation 
To run the project you need to install the OpenCV framework using Cocoapods    

1. You have to first install CocoaPods.

2. Run `pod install` in this directory to install OpenCV for the project. From then on, always open the project in XCode from the `SwiftStitch.xcworkspace` file that the pod install creates.

###Usage
Please first unzip `dataset_jaccount`.

OpenCVStitch is a very simple iOS/openCV example showing basic use of the Stitcher class. The c++ code is adapted from a sample included with the openCV distribution.  

The app has almost no user interface. When it starts it will automatically cut the image of CAPTCHAs and print the source path and output path.

###More   
Source Images Folder Name: images

Output Images Folder Name: datImages


