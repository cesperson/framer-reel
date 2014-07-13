PSD = Framer.Importer.load("imported/google-reel")

# Add original frame information to each layer
common.storeOriginal(PSD)

# Add animations to Layer
Layer::fadeOut = (delay) ->
  this.animate
    properties:
      opacity: 0
    curve: 'ease-in'
    delay: delay

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

# Create rectangle
rectangle = new Layer
  width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px"
rectangle.shadowColor = "rgba(0, 0, 0, 0.2)"

# Add rectangle to container and center it
rectangle.superLayer = PSD.container
rectangle.center()

rectangle.states.add
  centerInvisible:
    scale: 0.01
  centerBig:
    scale: 1
  rotated:
    rotation: 90
    height: 800
    y: -40
#  bigger:
#    rotation: 90
#    height: 800
#    y: -40

rectangle.states.animationOptions =
    curve: "spring(200, 20, 10)"

# Ok I might need more rectangles
rectangle2 = new Layer
  opacity: 0, width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px"
rectangle2.superLayer = PSD.container
rectangle2.center()

rectangle3 = new Layer
  opacity: 0, width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px"
rectangle3.superLayer = PSD.container
rectangle3.center()

# Rotate and then
rectangle.states.switchInstant "centerInvisible"
utils.delay 0.5, -> rectangle.states.switch "centerBig"
utils.delay 1, -> rectangle.states.switch "rotated"

# Maybe just try shifting
Layer::move = (x, y) ->
  this.animate
    properties:
      x: this.x + x
      y: this.y + y
    curve: "spring(200, 20, 10)"

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

utils.delay 1.05, ->
  rectangle.fadeOut()
  rectangle2.fadeIn()
  rectangle3.fadeIn()
  rectangle2.move(-250, 0)
  rectangle3.move(250, 0)
