# ``Gallery app``
## Objective:
Develop an image gallery app that allows users to browse and favourite images
fetched from an API. The app should demonstrate your proficiency in iOS
development, including user interface design, data retrieval and basic data
persistence.

## Requirements:
The app should have two screens:
Image Gallery Screen:
    Display a grid of thumbnail images fetched from the provided API.
    Each thumbnail should be tappable and lead to the Image Detail Screen.
    Implement pagination to load more images as the user scrolls to the bottom of the screen.
Image Detail Screen:
    Show the selected image in a larger view with additional details, such as the image title and description.
    Allow the user to mark the image as a favoгrite by tapping a heart-shaped button.
    Implement basic swipe gestures to navigate between images in the detail view.

## Networking:
Use the Unsplash API*(https://unsplash.com/developers) to fetch the images.
Register for a free API access key.
Use the "List Photos" endpoint to retrieve a list of curated photos.
Fetch the images in pages of 30 images per request.
Implement basic data persistence to store the user's favourite images locally.
Provide a mechanism to save and retrieve the list of favorite images.
Display a visual indicator on the thumbnail images in the gallery screen for the
user's favorite images.
Design the user interface with attention to usability and aesthetics.
Ensure a clean and intuitive layout, considering different device sizes and
orientations.
Use appropriate UI components and image caching techniques for smooth
scrolling and image loading.

## Technical Guidelines:
Use Swift as the programming language.
Support iOS 16 and above.
Use Swift for building the user interface.
Utilize URLSession or a suitable third-party library for network requests.
Follow modern iOS design patterns and best practices.
Structure the codebase with appropriate separation of concerns and
modularity.
Implement proper error handling and data parsing.
Demonstrate proficiency in asynchronous programming.
Basic unit tests are encouraged but not mandatory.

## Submission:
Provide a GitHub repository URL with the completed project.
Please, use .gitignore
Use MV(x) pattern or any other complex Clean-architecture. NOT MVC!
Include a README file with any necessary instructions or explanations.
(please, take a look at requirements below)
Please, use swiftlint or any other linter for code formatting.
Please, provide us with a structured commit history (see next)

## About Readme:
Project Overview:
Your contact information or a link you profile
Provide a brief introduction to this app.
Mention any assumptions made or additional features implemented
beyond the stated requirements.
Include key functionalities descriptions that make your app unique.
Overview the solutions you used: architecture, frameworks or pods,
patterns and any other cases.
Screenshots or Demo:
Include screenshots or a link to a demo video to showcase the app's user
interface.
Visual representation can help users understand the app better.
Configuration:
If your app requires configuration files or setup, provide details on how to
configure them.
Specify any environment variables or settings that need to be adjusted.

## About Commits:
Conventional Commits
A specification for adding human and machine readable meaning to commit messages
https://www.conventionalcommits.org/en/v1.0.0/
Working with Git, we expect brief and informative messages for each commit:
Commit messages should be concise, but informative.
Avoid creating super-commits. Complete one logical and comprehensive task
and commit it.
Use the past tense and start with a verb.
For example,
"Added a feature", "Fixed a bug", "Updated documentation".
You can use these prefixes in the commit header can help organize changes.
For example:
[ADDED] for new features.
[FIXED] for bug fixes.
[REFACTORED] for code refactoring.
