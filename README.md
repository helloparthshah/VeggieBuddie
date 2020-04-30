# VeggieBuddie
VeggieBuddie is an app for those with diet restrictions, identifying a dish as vegetarian or vegan by a picture of the ingredients. It also checks for allergic ingredients that you can personalize.

## Inspiration
As first-year students living in the residence dorms, we frequently eat at the dining commons. Since we are vegetarians, we need to check the ingredients of all the dishes served at the dining commons. This can be a tedious process especially if you have more than one restriction. Therefore, we decided to build VeggieBuddie that would save us time and effort of reading everything and tell us if we could eat the dish. From this, we extended our app to also include a personalized list of allergies so that it can reach a wider audience.

## What it does
The app starts with a user login. Using Google Analytics, the user can log into their Google account or a default guest account to save any dietary preferences, specifically allergens. After login, the app is ready to take pictures of any ingredients list and determining whether the item is vegetarian, vegan or non vegetarian.

## How we built it
Using Optical Character Recognition, the foundation of the app was built. Specifically, the app could read the text out of an image, allowing us to read the contents out of the ingredient list without having to manually type every ingredient. After OCR, our next step was to store the list into cloud to effectively manage the list of ingredients without taking too much of the app’s storage. This was done through Firebase, and its three core services: a realtime database, user authentication, and hosting. We then pull the data from the cloud and compare the ingredients to a list of non-vegetarian, vegetarian, and vegan ingredients to determine a dietary restriction. The allergens list in the profile page customizes a unique list for the user which is also saved in the cloud and compares the ingredient list to determine whether the item contains any selected allergens.

## Challenges we ran into
One of the biggest challenges we faced during this project was interacting with the cloud database, Firebase. We captured the user data and uploaded it on the database but we were not able to parse it during the next session. To solve this, we created a Map that would map the values to the key when the user logged in again. We also had some difficulty with displaying the profile page but we debugged the issue and were able to display it.

## Accomplishments that we're proud of
We are proud that we were able to create this complex app despite the time constraints that were placed on us. We were elated when our personalized profile page was working as that is a big part of our project and can help a substantial amount of people.

## What's next for VeggieBuddie
VeggieBuddie has successfully integrated Google Analytics, Optical Character Recognition, and Firebase to create the app it is today. In the future, VeggieBuddie is hopeful to integrate character recognition for multiple languages to scan a broader variety of ingredients, integrate a search history feature to avoid multiple scans of the same items, as well as implement a bigger database of allergens and dietary restrictions to better predict the safeness of the item for the user.

## Built With
android-studio
camera
dart
firebase
flutter
gifs
github
google
google-authentication
google-cloud
phone
python
text-recognition
ui
