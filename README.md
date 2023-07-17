# Squishy Donuts 🍩 
<img width="1280" alt="Screenshot 2023-07-17 at 4 39 47 PM" src="https://github.com/debbieyuen/squishydonuts/assets/31296177/ff556b4d-d285-4ecf-9c8c-73fa5e3a5ec3">
Squishy Donuts is an abstract simulation made with Unity, MunBun, Squash and Stretch, and Obi Softbody


### Links
  * Unity 2021.1.24f1
  * Obi Softbody: https://assetstore.unity.com/packages/tools/physics/obi-softbody-130029
  * MudBun: https://assetstore.unity.com/packages/tools/particles-effects/mudbun-volumetric-vfx-modeling-177891
  * Squash & Stretch: https://assetstore.unity.com/packages/tools/particles-effects/squash-stretch-kit-106993

### Donut Interactions
| Action | Element | Description |
| --- | --- | --- |
| Drag yellow car | 🚌 | Swipe down to **reverse** and swipe up to **drive** |
| Yellow car swipe down | 🚌 | Opens up rear view cameras (your webcam in this prototype) |
| Yellow car swipe up | 🚌 | Displays navigation and music side panels |
| Press location button | 🎯 | Prompts you for your location to display your location on map |
| Tap pink MSB image | 🎆 | Plays the Magic School Bus theme song |
| Pinch map| 🗺 | Zoom in and out of navigation map |
| Type in search bar | 🔍 | Search bar will not populate information |
| Allow permissions| ✅ | Allow app to access your location and webcam |

### Magic School Bus Gears
| Gears | Symbol | Description |
| --- | --- | --- |
| `P`: Park |  ⭐️ | Life is a series of destinations. When and where can you park your car at your destination? Maybe choose some that bring joy, meaning, and fulfillment.  |
| `R`: Reverse |  ⬇️ |  Reverse is a direction in life. It is neither bad nor good unless you make it out to be so. Reverse is bringing you closer to home or your destination.  |
| `N`: Neutral |  🌎 | Earth. An important place full of mysteries. |
| `D`: Drive |  ⬆️ | Your journey to the stars. Eventually, you want to park. |

<img width="2048" alt="Screen Shot 2023-03-29 at 6 48 15 AM" src="https://user-images.githubusercontent.com/31296177/228559116-f68dde3d-69f7-4c27-868b-8554aa9ab37d.png">

## Requirements
  * Greensock GSAP3 (Shockingly)
  * Mapbox GL JS and token
  * Flask 1.1.2
  * Werkzeug 1.0.1
  * Python 3.8.8
  * NodeJS v18.8.1


## Project Setup
Clone the repo
```bash
$ git clone https://github.com/debbieyuen/magical.git
```

Make sure you have NPM. If not installed, install the latest version of NPM.
```bash
$ npm install -g npm
```

Check to make sure it was installed successfully.
```bash
$ npm -v
$ node -v
```

Set up GSAP by adding the following to your .npmrc file either for your profile ($ vim ~/.npmrc) or at the root of your project.
```bash
$ //npm.greensock.com/:_authToken=b7bce164-5019-4e5d-98b5-70eba6754ec4@gsap:registry=https://npm.greensock.com
```

The first time you install GSAP to a project, install via.
```bash
$ npm install gsap@npm:@gsap/shockingly
```

You may also install all free and bonus plugins by downloading the zip file and installing via the following command.
```bash
$ npm install ./gsap-bonsu.tgz
```

Or install GSAP without bonus plugins. 
```bash
$ npm install gsap
```

Install Flask
```bash
$ pip install flask
```

In Visual Studio Code, install the Live Server Extension to quickly run the website locally on your machine. Else, run the program in your terminal.
Clone the repo
```bash
$ open index.html
```
## Bonus Question

I attempted the bonus question using Flask. Feel free to see my code in the 'bonus' folder.

Run app.py at http://127.0.0.1:5000/ and test.py at http://127.0.0.1:4444/
```bash
$ flask run
$ python3 test.py   
```
