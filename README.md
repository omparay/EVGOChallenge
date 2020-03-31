EVGOChallenge

A simple search app for past SpaceX launch events that uses GraphQL and RxSwift.

This project was developed on XCode 11.4 and uses Swift Package Manager (SPM) to manage packages.

Package Dependencies:
- RxSwift
- RxCocoa
- Apollo (GraphQL Framework)

The code is set to run on iPhone and iPad devices with an iOS version of 13 or later.

The build phases of the app will include a script that will run the Apollo CodeGen script twice:

- The initial run will download the schema.json from the SpaceX GraphQL API
- The second run will convert the included .graphql query files into the API.swift file

As of 3/31/2020 4:00am

I have verified this code works on both my iPhone 11 Max and iPad Pro 13 (Gen 1)

In essence there is only one viewcontroller: MainViewController which has a single viewmodel MainViewModel.

The viewcontroller creates the viewmodel and it tells the viewmodel to observe the following UI elements:

1. A segmented control where the user can select to search by Mission, Rocket or Year
2. A text field that can be used by the user to further filter the results.

The viewcontroller also binds itself to an RxSwift BehaviorSubject observable queue on the viewmodel.

The viewmodel executes one of the following GraphQL queries in its Apollo network client (based on the selected critera for filtering by the user):

1. LaunchesByMission
2. LaunchesByRocket
3. LaunchesByYear

Results by all queries are summarized into an array of a struct called LaunchData... I would have preferred that the data be used directly from the Apollo framework but I had issues using these directly with RxSwift. In fact I initially had set up different observable queues for each GraphQLK query but ended up deciding it should just be a single queue with a single data type (Apollo generates different datatypes for each query you specify unfortunately).

After converting and summarizing, the resulting array is then fed into a BehaviourSubject within the viewmodel (the one that the viewcontroller binds itself to). The viewcontroller converts the elements of the resulting array into the cells being displayed by a TableView.

The final binding is a cell selection binding that displays the videolink in a contained safari instance.

I had left in some debugPrint statements for my own debugging. I would normally remove these before release.

I also did not put any error alerts. These I would normally add after some initial testing by QA.

STANDING ON CRATE:

I am not a fan of MVVM in general. I had bad experiences with it ever since my days as a Microsoft.Net developer. But with RxSwift and in the use of SwiftUI + Combine I am more accepting of the technology because there is a LOT less code to develop when using MVVM with these frameworks. I will just say that reducing code (especially with Swift techniques that use high-order functions such as map, reduce and filter) that I will warn developers that code should be human readable first and machine readable second. Reducing code too much can ruin its readability and be a blocker for new developers to adopt code.

As a final warning for RxSwift: I have experienced a time when Apple updated its iOS and we had issues using RxSwift because at the time it was using system calls that became deprecated after the Apple iOS update. Apple does have a habit of mentioning (months in advance, even years in advance) when it will deprecate system calls. One just needs to ensure they keep apace with Apple developer notes. I have noted these deprecations to the community over at RxSwift but it went ignored until too late. This leaves me with a bad taste in my mouth with RxSwift. Sometimes groups of developers can be too into their own BS to realize: Sure, its your code but its THEIR system and it will always be THEIR say SINCE YOU ARE A GUEST.

