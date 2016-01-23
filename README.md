# zenigame

## Description

zenigame is CSS Framework.
**Under development.**

## Installation

```
$ npm i zenigame
```

## Usage

1. import zenigame

  ```styl
  // base.styl
  
  @import 'zenigame'
  ```

2. sholuld compile stylus

  ```
  $ npm i stylus
  ```
  
  ```js
  // package.json
  
  scripts: {
    "build:css": "stylus -c base.styl --include-css -I node_modules -o dist/base.css"
  }
  ```
