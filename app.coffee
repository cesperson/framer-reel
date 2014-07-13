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

# Section 1, the white boxes
# A lot of this is based on the Material Response Framerjs example: http://examples.framerjs.com/#material-response.framer
Rectangle = new Layer
  width: 400, height: 400, backgroundColor: "#fff", shadowY: 2, shadowBlur: 5, borderRadius: "6px"

Rectangle.superLayer = PSD.container

Rectangle.scale = 0.01
Rectangle.center()

Rectangle.animate
  properties:
    scale: 1
  time: 0.2


