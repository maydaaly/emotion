Overview:
This Flutter application displays a list of popular people using TheMovieDB API. The app features functionalities to view detailed information about each person, including images, biography, and more. the user can select an image to be opened in a full-size screen and download it locally on his device gallery. It also implements local storage using sqflite to save and display data when offline.

Features:
- Displays a logo image upon startup with modern and dynamic app ui.
- Popular People List: Fetches and displays a list of popular people from TheMovieDB API.
- Person Details: View detailed information about a selected person. the screen includes 2 tabs, one for the person's basic info and the other for his images display in a grid view.
- save image locally: the user can view a selected image in full size and download it on his device, the image will be saved in his photos app.
- Local Storage: Saves the popular people list in a local database to display when there is no network.

Technologies Used:
TheMovieDB API
Provider for state management
Dio for image saving
sqflite for local storage
CachedNetworkImage for efficient image loading
