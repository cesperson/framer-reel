window.tools =
  fadeIn: (view, delay) ->
    view.animate
      properties:
        opacity: 1
      delay: delay
  fadeOut: (view, delay) ->
    view.animate
      properties:
        opacity: 0
      delay: delay
  originalPos: (view, delay) ->
    view.animate
      properties:
        x: view.originalFrame.x
        y: view.originalFrame.y
      delay: delay
  moveX: (view, distance, delay) ->
    view.animate
      properties:
        x: distance
      delay: delay
  originalHue: (view, delay) ->
    view.animate
      properties:
        hueRotate: 0
      delay: delay
  changeHue: (view, hueChange, delay) ->
    view.animate
      properties:
        hueRotate: hueChange
      delay: delay
      time: 0.75
  storeOriginal: (views) ->
    window.PSD = {}
    for key, value of views
      # store original frames https://medium.com/framer-js/ca55fc7cfc61
      views[key].originalFrame = views[key].frame
      # add original State
      views[key].states.add
        leftScreen:
          x: -1000
        rightScreen:
          x: 640
      window.PSD[key] = views[key]
  switchAll: (stateName, views) ->
    _.each views, (element, index) ->
      element.states.switch stateName
  switchInstantAll: (stateName, views) ->
    _.each views, (element, index) ->
      element.states.switchInstant stateName

# Add helper functions to Layer prototype
Layer::move = (x, y, curve, time) ->
  curve = curve || "spring(200, 20, 10)"
  time = time || 0.2
  this.animate
    properties:
      x: this.x + x
      y: this.y + y
    curve: curve
    time: time

Layer::moveInstant = (x, y) ->
  this.x = this.x + x
  this.y = this.y + y

Layer::fadeOut = (delay) ->
  this.animate
    properties:
      opacity: 0
    curve: 'ease-in'
    delay: delay
    time: 0.2

Layer::fadeIn = (delay) ->
  this.animate
    properties:
      opacity: 1
    curve: 'ease-in'
    delay: delay
    time: 0.2

# Set default spring animation from Android Album animation Framerjs example
# http://examples.framerjs.com/#album-animation.framer
#Framer.Defaults.Animation =
#  curve: "spring"
#  curveOptions:
#    tension: 260
#    friction: 30
#    velocity: 0
#    tolerance: 0.01
