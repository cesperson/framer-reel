window.common =
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
