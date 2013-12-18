STROKE_WIDTH = 25
TOTAL_RADIUS = 70
RESULTS_RADIUS = 40
CANVAS_SIZE = 170
totalArc = undefined
resultsArc = undefined

$ ->
  return unless $('body#output').length

  canvas = Raphael("results-canvas", CANVAS_SIZE, CANVAS_SIZE)
  canvas.customAttributes.arc = (xloc, yloc, value, total, R) ->
    alpha = 360 / total * value
    a = (90 - alpha) * Math.PI / 180
    x = xloc + R * Math.cos(a)
    y = yloc - R * Math.sin(a)
    path = undefined
    if total is value
      path = [["M", xloc, yloc - R], ["A", R, R, 0, 1, 1, xloc - 0.01, yloc - R]]
    else
      path = [["M", xloc, yloc - R], ["A", R, R, 0, +(alpha > 180), 1, x, y]]
    path: path

  totalArc = canvas.path().attr(
    stroke: "#1e2a36"
    "stroke-width": STROKE_WIDTH
    arc: [CANVAS_SIZE / 2, CANVAS_SIZE / 2, 0, 100, TOTAL_RADIUS]
  )
  resultsArc = canvas.path().attr(
    stroke: "#18bc9c"
    "stroke-width": STROKE_WIDTH
    arc: [CANVAS_SIZE / 2, CANVAS_SIZE / 2, 0, 100, RESULTS_RADIUS]
  )

  totalArc.animate
    arc: [CANVAS_SIZE / 2, CANVAS_SIZE / 2, 100, 100, TOTAL_RADIUS]
  , 1500, "ease-in-out"
  resultsArc.animate
    arc: [CANVAS_SIZE / 2, CANVAS_SIZE / 2, RESULTS_VALUE, 100, RESULTS_RADIUS]
  , 750, "ease-in-out"