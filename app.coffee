PSD = Framer.Importer.load("imported/google-reel")

# Add original frame information to each layer
tools.storeOriginal(PSD)

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

background = new BackgroundLayer backgroundColor:"rgba(77, 208, 225, 1.00)"


# Returns a rectangle --- each rectangle doesn't really need each state so this
# is probably a bit much.
createRectangle = ->
  layer = new Layer
      width: 400, height: 400, backgroundColor: "#fff", shadowY: 12, shadowBlur: 15, borderRadius: "6px", opacity: 0
  layer.shadowColor = "rgba(0, 0, 0, 0.2)"

  # Add rectangle to container and center it
  layer.superLayer = PSD.container
  layer.center()
  layer.original
  layer.originalFrame = layer.frame

  # Add rectangle layer state
  layer.states.add
    centerInvisible:
      scale: 0.01
      opacity: 1
    centerBig:
      scale: 1
      opacity: 1
      height: 400
    rotated:
      rotation: 90
      height: 800
      y: -40
      shadowY: 0
      shadowX: 12
    unrotated:
      opacity: 1
      height: 400
      y: layer.originalFrame.y
    barrotated:
      opacity: 0
    bar:
      rotation: 0
      opacity: 1
      width: 400
      height: 110
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

rectangle.states.animationOptions =
  curve: "spring(150, 22, 1)"

# Rotate
utils.delay 0.5, -> rectangle.states.switch "centerBig"

# An object to hold animation sections
sections = {}

sections.oneBox = ->
  # Unbind click
  rectangle.off Events.Click, sections.oneBox
  # Reset positions to run animation
  tools.switchInstantAll "default", [rectangle2, rectangle3, rectangle4, rectangle5]
  rectangle.states.switch "rotated"
  # rectangle.on Events.AnimationEnd, sections.twoBoxes
  utils.delay 0.3, sections.twoBoxes

# Run the animations automatically the first time through
utils.delay 0.5, sections.oneBox

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
  tools.switchInstantAll "bar", [rectangle2, rectangle3, rectangle4, rectangle5]
  rectangle2.moveInstant 0, 0
  rectangle3.moveInstant 0, 110
  rectangle4.moveInstant 0, 220
  rectangle5.moveInstant 0, 330

  utils.delay 0.05, -> rectangle4.move(0, 10, "ease-in")
  utils.delay 0.1, -> rectangle3.move(0, -10, "ease-in")
  utils.delay 0.15, -> rec2anim = rectangle2.move(0, -30, "ease-in")

  barMove = rectangle5.move(0, 30)

  # Might be able to do this strictly with delays to prevent all
  # the nesting.
  barMove.on "end", ->
    shadowChange = rectangle5.animate
      properties:
        shadowY: 27
        shadowBlur: 24
      curve: "linear"
      time: 0.2
    shadowChange.on "end", ->
      barMove2 = rectangle5.move 0, -260, "ease-in-out", 0.4
      utils.delay 0.05, -> rectangle4.move 0, 130, "ease-in-out"
      utils.delay 0.1, -> rectangle3.move 0, 130, "ease-in-out"
      barMove2.on "end", ->
        utils.delay 0.2, ->
          shadowReset = rectangle5.animate
            properties:
              shadowY: 3
              shadowBlur: 5
            curve: "linear"
            time: 0.2
          shadowReset.on "end", ->
            rectangle4.move 0, -40
            rectangle3.move 0, -20
            rectangle2.move 0, 20
            rectangle5.fadeOut()
            rectangle4.fadeOut()
            rectangle3.fadeOut()
            rectangle2.fadeOut()
            utils.delay 0.1, ->
              finalFade = rectangle.fadeIn()
              # Rebind click to allow re-run
              # finalFade.on "end", -> rectangle.on Events.Click, sections.oneBox
              # Re-run forever, for ever, for ev er.
              finalFade.on "end", ->
                utils.delay 1, sections.oneBox
