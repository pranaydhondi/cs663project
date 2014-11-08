#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include "opencv2/nonfree/nonfree.hpp"

using namespace cv;
using namespace std;
int main(int argc, char** argv )
{
    Mat image,image1,image2,descriptors1,descriptors2;
    vector<Mat> images;    
    for(int i = 1; i < argc; i++) 
    {
        image1 = imread(argv[i], CV_LOAD_IMAGE_GRAYSCALE);
        if(image1.data )
        {
           images.push_back(image1);
        } else
        {
            cout<< argv[i] << " not available." ;
        }
    }
    if(images.size() < 2)
    {
        cout<< "Not enough images" ;
    }
    int threshold = 5;
    bool orb = false;
    if ( !image1.data || !image2.data)

    //namedWindow("Display Image2", CV_WINDOW_AUTOSIZE );     
    image1 = images[0];
    for (int i=1; i<images.size(); i++)
    {
        image2 = images.at(i);
        vector<KeyPoint> keypoints1,keypoints2;
        if(orb){
            ORB orb(1000,1.2f,8,14,0,2,0,14);
            orb(image1,noArray(),keypoints1,descriptors1);
            orb(image2,noArray(),keypoints2,descriptors2);
        }
        //Surf based detector
        int minHessian = 400;
        SurfFeatureDetector detector( minHessian );
        if(!orb){
            detector.detect( image1, keypoints1 );
            detector.detect( image2, keypoints2 );
            SurfDescriptorExtractor extractor;
         
            extractor.compute( image1, keypoints1, descriptors1 );
            extractor.compute( image2, keypoints2, descriptors2 );
        }
        
        //drawKeypoints(image1,keypoints1,image1,Scalar::all(-1), DrawMatchesFlags::DEFAULT);
        //drawKeypoints(image2,keypoints2,image2,Scalar::all(-1), DrawMatchesFlags::DEFAULT);
        vector< DMatch > matches;
        if(orb){
            BFMatcher matcher(NORM_L2);
            matcher.match(descriptors1, descriptors2, matches);
        } else {
            FlannBasedMatcher matcher;    
            matcher.match(descriptors1, descriptors2, matches);
        }    
        double max_dist = 0; double min_dist = 100;
     
        //-- Quick calculation of max and min distances between keypoints
         for( int i = 0; i < descriptors1.rows; i++ )
         { double dist = matches[i].distance;
         if( dist < min_dist ) min_dist = dist;
         if( dist > max_dist ) max_dist = dist;
         }
         cout<< "max distance:" << max_dist << endl;
         cout<< "min distance:" << min_dist << endl;
         std::vector< DMatch > good_matches;
     
        for( int i = 0; i < descriptors1.rows; i++ )
         { if( matches[i].distance < threshold *min_dist )
         { good_matches.push_back( matches[i]); }
         }
     
        drawMatches(image1, keypoints1, image2, keypoints2, good_matches, image);
        namedWindow("matches", CV_WINDOW_NORMAL ); 
        imshow("matches",image);
        Size s = descriptors1.size();
        vector<Point2f> match1points, match2points;
        for(int i = 0; i < good_matches.size(); i++)
        {
            match1points.push_back(keypoints1.at(good_matches.at(i).queryIdx).pt);
            match2points.push_back(keypoints2.at(good_matches.at(i).trainIdx).pt);
        }
        Mat H = findHomography( match2points, match1points, CV_RANSAC );
        cout << "Homography matrix size: " << H.size() << endl;
        //-- Get the corners from the image_1 ( the object to be "detected" )
          std::vector<Point2f> obj_corners(4);
          obj_corners[0] = cvPoint(0,0); obj_corners[1] = cvPoint( image2.cols, 0 );
          obj_corners[2] = cvPoint( image2.cols, image2.rows ); obj_corners[3] = cvPoint( 0, image2.rows );
          std::vector<Point2f> scene_corners(4);
          perspectiveTransform( obj_corners, scene_corners, H);
          
          //~ //-- Draw lines between the corners (the mapped object in the scene - image_2 )
          //~ line( image, scene_corners[0] + Point2f( image1.cols, 0), scene_corners[1] + Point2f( image1.cols, 0), Scalar(0, 255, 0), 4 );
          //~ line( image, scene_corners[1] + Point2f( image1.cols, 0), scene_corners[2] + Point2f( image1.cols, 0), Scalar( 0, 255, 0), 4 );
          //~ line( image, scene_corners[2] + Point2f( image1.cols, 0), scene_corners[3] + Point2f( image1.cols, 0), Scalar( 0, 255, 0), 4 );
          //~ line( image, scene_corners[3] + Point2f( image1.cols, 0), scene_corners[0] + Point2f( image1.cols, 0), Scalar( 0, 255, 0), 4 );

         Mat image3;
         warpPerspective(image2,image3,H,Size(image1.cols+image2.cols,image1.rows));     
         Mat half(image3,Rect(0,0,image1.cols,image1.rows));   
         image1.copyTo(half);
         Rect roi(0, 0, scene_corners[1].x, image1.rows);
         Mat image_roi = image3(roi);
         image1 = image_roi;
     }
    //imshow("Display Image2", image2);

    namedWindow("panaroma", CV_WINDOW_NORMAL ); 
    imshow("panaroma", image1);
    imwrite("panaroma.png",image1);
    waitKey(0);
    return 0;
}
