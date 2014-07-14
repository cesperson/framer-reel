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

#background = new BackgroundLayer backgroundColor:"rgba(77, 208, 225, 1.00)"

createRectangle = ->
  layer = new Layer
      width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px", opacity: 0
  layer.shadowColor = "rgba(0, 0, 0, 0.2)"
  # Add rectangle to container and center it
  layer.superLayer = PSD.container
  layer.center()
  layer.original
  layer.originalFrame = layer.frame

  layer.states.add
    centerInvisible:
      scale: 0.01
      opacity: 1
    centerBig:
      scale: 1
      opacity: 1
      height: 400
    rotated:
      shadowY: 0
      rotation: 90
      height: 800
      y: -40
    unrotated:
      opacity: 1
      height: 400
      y: layer.originalFrame.y
      shadowY: 0
    barrotated:
      opacity: 0
    bar:
      rotation: 0
      opacity: 1
      width: 400
      height: 110
    rectangle2: { y: 0 }
    rectangle3: { y: 110 }
    rectangle4: { y: 220 }
    rectangle5: { y: 330 }

  return layer

# Create rectangle
rectangle = createRectangle()
rectangle2 = createRectangle()
rectangle3 = createRectangle()
rectangle4 = createRectangle()
rectangle5 = createRectangle()

rectangle.states.animationOptions =
  curve: "spring(95, 20, 10)"

# Set initial rectangle position
rectangle.states.switchInstant "centerInvisible"

# Rotate
utils.delay 0.5, -> rectangle.states.switch "centerBig"

# An object to hold animation sections
sections = {}

# Run the animations on Click
#rectangle.on Events.Click, ->
utils.delay 1, ->
  rectangle.states.animationOptions =
    curve: "spring(150, 22, 1)"
  rectangle.states.switch "rotated"
  rectangle.on Events.AnimationEnd, sections.twoBoxes

# afterRotate has animations that take place after rotating.
# We need it defined in its own function so that we can unbind it.
# Possibly a good idea to look into underscore's once _.once() function
# wrapepr to just run the animations once.
sections.twoBoxes = ->
  rectangle.off Events.AnimationEnd, sections.twoBoxes
  rectangle.fadeOut()
  rectangle2.fadeIn()
  rectangle3.fadeIn()
  # Separate into two
  rectangle2.move -250, 0
  rectangle3.move 250, 0
  # Move back in
  utils.delay 1, ->
    rectangle2.move 250, 0, "ease-in", 0.3
    rectangle3.move -250, 0, "ease-in", 0.3
    rectangle2.fadeOut()
    rectangle3.fadeOut()
    rectangle.states.switch "unrotated"
    rectangle.on Events.AnimationEnd, sections.fourBars

sections.fourBars = ->
  rectangle.off Events.AnimationEnd, sections.fourBars
  rectangle.states.switch "barrotated"
  common.switchInstantAll("bar", [rectangle2, rectangle3, rectangle4, rectangle5])
  rectangle2.moveInstant 0, 0
  rectangle3.moveInstant 0, 110
  rectangle4.moveInstant 0, 220
  rectangle5.moveInstant 0, 330

  utils.delay 0.05, -> rectangle4.move(0, 10, "ease-in")
  utils.delay 0.1, -> rectangle3.move(0, -10, "ease-in")
  utils.delay 0.15, -> rec2anim = rectangle2.move(0, -30, "ease-in")

  barMove = rectangle5.move(0, 30)
  barMove.on "end", ->
    shadowGrow = rectangle5.animate
      properties:
        shadowY: 27
        shadowBlur: 24
      curve: "linear"
      time: 0.2
    shadowGrow.on "end", ->
      barMove2 = rectangle5.move 0, -260, "ease-in-out", 0.4
      utils.delay 0.05, -> rectangle4.move 0, 130, "ease-in-out"
      utils.delay 0.1, -> rectangle3.move 0, 130, "ease-in-out"
      barMove2.on "end", ->
        utils.delay 0.2, ->
          rectangle5.animate
            properties:
              shadowY: 2
              shadowBlur: 5
            curve: "linear"
            time: 0.2
          rectangle4.move 0, -40
          rectangle3.move 0, -20
          rectangle2.move 0, 20
          rectangle5.fadeOut()
          rectangle4.fadeOut()
          rectangle3.fadeOut()
          rectangle2.fadeOut()
          utils.delay 0.1, -> rectangle.fadeIn()
