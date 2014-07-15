PSD = Framer.Importer.load("imported/google-reel")

# Add original frame information to each layer
tools.storeOriginal(PSD)

# Add blue background
background = new BackgroundLayer backgroundColor:"rgba(77, 208, 225, 1.00)"

## Fade from black ## --------------------------------------------------------------------------------------------------
PSD.container.brightness = 0
PSD.container.animate
  properties:
    brightness: 100
  curve: "linear"
  time: 0.5

# Part 1, the white boxes -------------------------------------------------------------------------------------------
# A lot of this is based on the Material Response Framerjs example:
# http://examples.framerjs.com/#material-response.framer

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

  # Rectangle layer states
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

  # Reset positions to allow animation to loop
  tools.switchInstantAll "default", [rectangle2, rectangle3, rectangle4, rectangle5]
  rectangle.states.switch "rotated"

   # rectangle.on Events.AnimationEnd, sections.twoBoxes
  utils.delay 0.3, sections.twoBoxes

# Run the animations automatically the first time through
utils.delay 0.5, sections.oneBox

# We need it defined in its own function so that we can unbind it.
# (It's also just better organization.)
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

# Section where box separates into four bars
sections.fourBars = ->
  rectangle.off Events.AnimationEnd, sections.fourBars
  rectangle.states.switch "barrotated"
  tools.switchInstantAll "bar", [rectangle2, rectangle3, rectangle4, rectangle5]

  # Stack bars to form single big box shape
  rectangle2.moveInstant 0, 0
  rectangle3.moveInstant 0, 110
  rectangle4.moveInstant 0, 220
  rectangle5.moveInstant 0, 330

  # Separate bars with a slight stagger
  utils.delay 0.05, -> rectangle4.move(0, 10, "ease-in")
  utils.delay 0.1, -> rectangle3.move(0, -10, "ease-in")
  utils.delay 0.15, -> rec2anim = rectangle2.move(0, -30, "ease-in")
  barMove = rectangle5.move(0, 30)

  # Might be able to do this strictly with delays to prevent all
  # the nesting.
  barMove.on "end", ->

    # Deeper shadow on activated bar
    shadowChange = rectangle5.animate
      properties:
        shadowY: 27
        shadowBlur: 24
      curve: "linear"
      time: 0.2
    shadowChange.on "end", ->

      # Move bars into place
      barMove2 = rectangle5.move 0, -260, "ease-in-out", 0.4
      utils.delay 0.05, -> rectangle4.move 0, 130, "ease-in-out"
      utils.delay 0.1, -> rectangle3.move 0, 130, "ease-in-out"
      barMove2.on "end", ->

        # Reset shadow on deactivated bar
        utils.delay 0.2, ->
          shadowReset = rectangle5.animate
            properties:
              shadowY: 3
              shadowBlur: 5
            curve: "linear"
            time: 0.2

          # Bring rectangles back into one square
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

              # Re-run forever, for ever, for ev er.
              finalFade.on "end", ->
                utils.delay 1, sections.oneBox
