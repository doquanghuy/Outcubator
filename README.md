# Outcubator

This is an application used to scan QR Code in payment process.

There are few steps to run this app:

1. Languages: Swift 5.1
2. Minimum Version: iOS 11.0
3. How to install:  
  - Open Terminal on MacOS and clone this repository, the default branch is master.
  - Download Xcode 12 or higher
  - A real iOS device 
  - Open Terminal and run 'pod install'
  - Open .xcworkspace file, plug the phone into the Mac device and build it then.

4. Some notes:
  - This app is just runned on the real device
  - This app uses RxSwift and Clean Architecture + MVVM(in Presentation Layer)
  - This repository includes 5 PNG QRCode images to scan in the same JSON format way.
  - The QRCode JSON format is:
  
            {
                id: "1",
                companyName: "Google",
                currency: "USD",
                amount: 2350000,
                fee: 230000,
                isCredit: false
            }
        
    - Users can generate QRCode by their owns by using the following tool: https://codesandbox.io/s/generate-qrcode-with-json-data-forked-iu1up?file=/index.js:577-771
    
  - When users sign up this app, the app will automatically generate some transactions to get the initial balance.
  - When users sign up this app, the app will save info(email, password) into the device to auto-fill such infos later.
  - When users scan a QRCode, the app will check whether this amout of money is smaller than the current balance. If it is not, the payment wont be made.
  - When users sign up or login this app, the email field wull be checked by the regex, and other fields will be guaranteed not nil or empty.
  - Due to each time users sign up, users can use this account to sign in later, I wont provide 3 accounts in advance. Users can create by their owns.
  - Users can change currencies by click on the Top Up Button on the Wallet Tab. The app wll show a list of currencies of all the transactions that users have. Click to select a currency, the app will reload balance number and transactions below.


