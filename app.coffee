PSD = Framer.Importer.load("imported/google-reel")

# Add original frame information to each layer
common.storeOriginal(PSD)

# Maybe just try shifting
Layer::move = (x, y, curve, time) ->
  curve = curve || "spring(200, 20, 10)"
  time = time || 0.2
  this.animate
    properties:
      x: this.x + x
      y: this.y + y
    curve: curve
    time: time

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

## Fade from black ## --------------------------------------------------------------------------------------------------
PSD.container.brightness = 0
PSD.container.animate
  properties:
    brightness: 100
  curve: "linear"
  time: 0.5

# Section 1, the white boxes -------------------------------------------------------------------------------------------

# A lot of this is based on the Material Response Framerjs example:
# http://examples.framerjs.com/#material-response.framer

createRectangle = ->
  layer = new Layer
      width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px", opacity: 0
  layer.shadowColor = "rgba(0, 0, 0, 0.2)"
  # Add rectangle to container and center it
  layer.superLayer = PSD.container
  layer.center()
  return layer

# Create rectangle
rectangle = createRectangle()
rectangle2 = createRectangle()
rectangle3 = createRectangle()
rectangle4 = createRectangle()

rectangle.states.add
  centerInvisible:
    scale: 0.01
    opacity: 1
  centerBig:
    scale: 1
  rotated:
    rotation: 90
    height: 800
    y: -40

rectangle.states.animationOptions =
  curve: "spring(95, 20, 10)"

# Set initial rectangle position
rectangle.states.switchInstant "centerInvisible"

# Rotate
utils.delay 0.5, -> rectangle.states.switch "centerBig"

# afterRotate has all the animations that take place after rotating.
# We need it defined in its own function so that we can unbind it.
# Possibly a good idea to look into underscore's once _.once() function
# wrapepr to just run the animations once.
afterRotate = ->
  rectangle.fadeOut()
  rectangle2.fadeIn()
  rectangle3.fadeIn()
  # Separate into two
  rectangle2.move(-250, 0)
  rectangle3.move(250, 0)
  # Move back in
  utils.delay 1, -> rectangle2.move(250, 0, "ease-in", 0.3)
  utils.delay 1, -> rectangle3.move(-250, 0, "ease-in", 0.3)
  # Unbind AnimationEnd
  rectangle.off Events.AnimationEnd, afterRotate

# Run the animations on Click
#rectangle.on Events.Click, ->
utils.delay 1, ->
  rectangle.states.animationOptions =
    curve: "spring(150, 22, 1)"
  rectangle.states.switch "rotated"
  rectangle.on Events.AnimationEnd, afterRotate
