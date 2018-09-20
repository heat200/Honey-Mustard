Running Honey Mustard on your phone:
1. Open the Xcode Workspace file "YouTubeTopTen.xcworkspace"
2. Go to YouTubeTopTen Target Settings and edit the bundle id to be unique. Changing the middle portion of the string should suffice.
3. Change "Team" in the "Signing" section to your Apple ID so that the app may be signed properly with your bundle id
4. The App is now testable and executable, you may go into it and do a few searches yourself or you may use the included UITests.



Setting Up & Running Honey Mustard UITests:
1. Go to YouTubeTopTenUITests Target Settings and Change "Team" in the "Signing" section to your Apple ID
2. Go to the "Test Navigator" and press play to the right of "YouTubeTopTenUITests"

There are 4 UITests included.
 
Music. Music test searches for Top 10 for "Kanye West" and picks the first result using the "any" filter
Movie. Movie test searches for Top 10 for "Transformers" and picks the first result using the "movie" filter
Show. Show test searches for Top 10 "Teen Titans" and picks the first result using the "episode" filter
No Result. No Result test searches for Top 10 "Youth & Consequences" and picks the first result using the "episode" filter.
