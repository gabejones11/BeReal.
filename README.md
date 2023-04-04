# Project 6 - *BeReal. Part 2*

Submitted by: **Gabriel Jones**

**BeReal.** is an app that leverages ParseSwift and Back4App to enable user creation and authentication, and to allow posting on the platform. Its purpose is to resemble BeReal, although it operates in a manner similar to Instagram, where users can browse their feed and share photos from either the camera or camera roll, along with captions. Additionally, the app incorporates a feature that blurs posts if a user hasn't posted in the last 24 hours. All of this data is stored in a Back4App-hosted database. 

Time spent: **11** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] User can launch camera to take photo instead of photo library
- [x] User session persists when application is closed and relaunched
- [x] Users are able to log out and return to sign in page
- [x] Users are NOT able to see other photos until they upload their own

The following **additional** features are implemented:

- [x] App was created exclusively using UIKit instead of storyboard except for the launchscreen

## Video Walkthrough

Here's a walkthrough of implemented user stories:

Objective #1 (Users can launch camera to take photo instead of photo library)

![BeReal.](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMTQwNmFlZmVhMTBmYWMyMWNiNjI4OTYzOTkxNDI1ZmJkYThlYjQwYSZjdD1n/iBaMWha1x76diBawA8/giphy.gif)

Objective #2 and #3 (User session persists when application is closed and relaunched, and users are able to log out and return to sign in page)

![BeReal.](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMmE4MTNlNzM0MzQ2M2U2N2NjZWE5ZGViOGUyOTMzYzYxMDNjYWY0MyZjdD1n/dwVNlyttwy4I6uPnPi/giphy.gif)

Objective #4 (Users are NOT able to see other photos until they upload their own)

![BeReal.](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYWJlN2VkOTQyNjk1YmFlZDFiMTYzYWFkNzNmNzlmNDZkNDg2NzA0OCZjdD1n/xVqj2yGrUCEmP9Jlnk/giphy.gif)



## Notes

During my work on part two of this project, the most significant hurdle I faced was incorporating the blur view. Initially, I believed that I needed to include the effect in the prepareForReuse function. However, I later discovered that it was only necessary to add it to the setupUI function, and upon testing, it functioned correctly.

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
