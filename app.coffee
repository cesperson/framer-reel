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
Rectangle = new Layer
  width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px"
Rectangle.shadowColor = "rgba(0, 0, 0, 0.2)"

# Add rectangle to container and center it
Rectangle.superLayer = PSD.container
Rectangle.center()

Rectangle.states.add
  centerInvisible:
    scale: 0.01
  centerBig:
    scale: 1
  rotated:
    rotation: 90
    height: 800
    y: -50

Rectangle.states.animationOptions =
    curve: "spring(200, 20, 10)"


# Set
Rectangle.states.switchInstant "centerInvisible"
utils.delay 0.5, -> Rectangle.states.switch "centerBig"
utils.delay 1, -> Rectangle.states.switch "rotated"
