# WeatherForcast

It's an iOS project which displaying a list of tomorrow weather forcast of some selected cities using **MetaWeather API** and allows the user to pick one  city and display more details about the weather.

The project is built using **MVVM-C architecture** where **M** represents **Model** to hold the data entities, **VM** represents **ViewModel** to handle the flow and work with the different services, **V** represents **View** to hold the UI, **C** represents **Coordinator** to handle the navigation and passing data between different modules and it's built with using **Clean Architecture** to keep the SOLID principle applied and make the project scalable.
It's using combine framework to apply observer pattern.
It's built by applying clean architecture by using use cases, repositories to deal with the services.


## List of Modules
1. **Weather List** handling the process of fetching the locations and retrieve the weather data from the APIs, displaying that list to UI.

## Technologies

Project is created using:

* **MVVM-C** Architecture
* **Combine** framework
* **Clean Architecture**
* iOS SDK **14.0**
* Swift version **5.0**
* XCode version **13.2.1**

## Third-Party libraries
No third-party libraries used in the project.

### Test Cases

* Repository Test cases:
  1. FindLocationWithSuccess and ReturnsLocation.
  2. FindLocationWithError and ReturnsFailedFindLocation.
  3. FetchWeatherWithSuccess and ReturnsCityWeather.
  4. FetchWeatherWithError and ReturnsFailedFetchWeather.
