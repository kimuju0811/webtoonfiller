# Webtoonfiller

This repository contains a sample iOS app built with SwiftUI that lets you manage and review webtoons. The app implements the features described in [WEBTOON_APP_SCRIPT.md](WEBTOON_APP_SCRIPT.md).

Open the `WebtoonApp` folder in Xcode to run it on iOS.

### API setup

The app contains placeholder URLs for fetching webtoon information from KakaoPage and Naver Webtoon. Replace the constants in `WebtoonApp/Models/WebtoonAPI.swift` with your own API endpoints and keys if required.

### Auto update

The Settings tab includes a toggle to enable automatic background updates. When enabled, the app periodically fetches the latest information for your saved webtoons using the provided APIs.

### Customization

From the Settings tab you can edit the list of genre categories and choose a theme. The selected theme controls the app's color scheme.

### Reading progress

The detail screen displays a progress bar showing how many episodes you've read. Adjust the stepper to update your progress.
