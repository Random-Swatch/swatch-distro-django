# Swatch generator

---

## Pre-requisites
* Python 3.6.1
* NodeJs 16.13.1
* Docker 19.03.8 `(Optional)`

## How to run

### 1. Using binary 

* Clone `swatch_server_django` and `swatch-ui` modules using following commands,
  * `git clone https://github.com/Random-Swatch/swatch_server_django.git`
  * `git clone https://github.com/Random-Swatch/swatch-ui.git`
* Navigate to the root of the `swatch_server_django` module and run the following command,
  * `pip3 install -r requirements.txt`
  * `python3 manage.py runserver 0.0.0.0:8080`
* Navigate to the root of the `swatch-ui` module and run following commands,
  * `npm install`
  * `npm start`
* Press `ctrl + c` to terminate.

### 2. Using Docker

* Run `./run.sh` script to start.
* Run `./stop.sh` script to stop.

#### Limitation:
Experienced a `port already in use` error while re-running the same application. The root cause was `docker-proxy` holds the port even after stopping the container.

If you get `port already in use` error while re-running the application use following commands to find PIDs of relevant processes,

* `sudo ss -lptn 'sport = :3000'`
* `sudo ss -lptn 'sport = :8080'`

And use following command to kill processes,

* `sudo kill -9 <Pid>`

## How to use

* Open the URL `http://localhost:3000` in a web browser and click on the `GENERATE SWATCH` button.

![image info](./resources/screen-1.png)

## Swatch API

* Method: `GET`
* URL: `http://localhost:8080/swatch`
* Response data:
```json
[

  {
    "type":"HSL",
    "syntax":"hsl(164, 75%, 93%)",
    "is_css_compatible":true
  },
  {
    "type":"HSL",
    "syntax":"hsl(29, 88%, 33%)",
    "is_css_compatible":true
  },
  {
    "type":"HSL",
    "syntax":"hsl(121, 72%, 69%)",
    "is_css_compatible":true
  },
  {
    "type":"RGB",
    "syntax":"rgb(161, 25, 95)",
    "is_css_compatible":true
  },
  {
    "type":"RGB",
    "syntax":"rgb(65, 116, 179)",
    "is_css_compatible":true
  }

]
```

## How to add a new color space

### `swatch_server_django` update
* Inherit the `api.color_space.ColorSpace` class and create a class for the new color space.
* Following methods should override in the class.
```python
# This method returns the color space type.
# RGB, HSL
def get_type(self):
    pass

# This method should return the syntax to use the color in Web UI.
# Ex: "hsl(29, 88%, 33%)"
def get_syntax(self):
    pass

#  This method should return the CSS compatibility status of the color space. 
#  Ex: If the color space is compatible with the latest CSS version,
#  this value should be `true` else, should be `false`.
def get_is_css_compatible(self):
    pass

# This method should generate a random color from the space.
# And should return an object of the api.color.Color class
def generate(self):
    pass
```
* Import the created class to the `swatch_server_django/settings.py` file.
Ex:
```python
from api.color_space import RgbSpace, HslSpace
```
* Add the class to the following list in `swatch_server_django/settings.py`.
```python
SWATCH_COLOR_SPACES = [RgbSpace, HslSpace]
```
* To change the swatch size change `SWATCH_SIZE = 5` value in `swatch_server_django/settings.py`.
* For a sample implementatin check `api.color_space.RgbSpace` class.

### `swatch-ui` update

* If the newly added color space supports the latest CSS version and can render in the browser, then no change requires in the `swatch-ui`.
* But,
  * If it doesn't support need to create a color component similar to `src/components/Color.js` with a custom implementation to render the color in the UI.
  * Then add the component in `src/components/Swatch.js` file and update the following condition accordingly.
    
```javascript
    if (color.is_css_compatible === true) {
        return <Color color={color} key={color.syntax}/>
    }
```