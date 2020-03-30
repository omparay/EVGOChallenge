EVGOChallenge

A simple search app for past SpaceX launch events that uses GraphQL and RxSwift.

This project was developed on XCode 11.4 and uses Swift Package Manager (SPM) to manage packages.

Package Dependencies:
RxSwift
RxCocoa
Apollo (GraphQL Framework)

The code is set to run on iPhone and iPad devices with an iOS version of 13 or later.

The build phases of the app will include a script that will run the Apollo CodeGen script twice:

- The initial run will download the schema.json from the SpaceX GraphQL API
- The second run will convert the included .graphql query files into the API.swift file
