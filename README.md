# Project 5 - *BeReal.*

Submitted by: **Gabriel Jones**

**BeReal.** is an app that takes advantage of ParseSwift and Back4App to create and authenticate users to post on the platform.  This is meant to be a BeReal. look a like although the app functions more or less the same as instagram where users can browser their feed and post pictures that contain captions.  All of this information is stored in a database hosted by Back4App. 

Time spent: **10** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] User can register a new account
- [x] User can log in with newly created account
- [x] App has a feed of posts when user logs in
- [x] User can upload a new post which takes in a picture from photo library and a caption	
 
The following **optional** features are implemented:

- [x] User is able to logout
- [x] User stays logged in when app is closed and open again	

The following **additional** features are implemented:

- [x] App was created exclusively using UIKit instead of storyboard except for the launchscreen

## Video Walkthrough

Here's a walkthrough of implemented user stories:

User creating a new account

![BeReal.](https://media.giphy.com/media/H4pC8FqUsRskPk4kdU/giphy.gif)

User logging into newly created account and making a post

![BeReal.](https://media.giphy.com/media/LzyVxErR89mNSivGsk/giphy.gif)

## Notes

While developing this app, I encountered a significant hurdle in creating a custom navigation bar. My goal was to maintain a black navigation bar at all times, even when the user was scrolling. However, by default, the navigation bar changed color while scrolling and also hid the logo and two buttons within it. After some research, I discovered that the solution was to create a UINavigationBarAppearance attribute and apply it to all three states of the navigation bar. In addition, I learned that the navigation bar has bar button items, which meant that the normal UIButtons that I originally created would not work placed on top of the navigation bar. I had to refactor the code to create UIBarButtonItems that would provide the same functionality as my original UIButtons.

## License

    Copyright [2023] [Gabriel Jones]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
