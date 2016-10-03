_ = require "underscore"

BokehView = require "../../core/bokeh_view"
{Visuals} = require "../../core/visuals"
{logger} = require "../../core/logging"
p = require "../../core/properties"
proj = require "../../core/util/projections"
Model = require "../../model"

class RendererView extends BokehView

  initialize: (options) ->
    super(options)
    @plot_view = options.plot_view
    @visuals = new Visuals(@model)

  @getters {
    plot_model: () -> @plot_view.model
  }

  request_render: () ->
    @plot_view.request_render()

  set_data: (source) ->
    data = @model.materialize_dataspecs(source)
    _.extend(@, data)

    if @plot_model.use_map
      if @_x?
        [@_x, @_y] = proj.project_xy(@_x, @_y)
      if @_xs?
        [@_xs, @_ys] = proj.project_xsys(@_xs, @_ys)

  map_to_screen: (x, y) ->
    @plot_view.map_to_screen(x, y, @model.x_range_name, @model.y_range_name)

class Renderer extends Model
  type: "Renderer"

  @define {
    level: [ p.RenderLevel, null ]
    visible: [ p.Bool, true ]
  }

module.exports = {
  Model: Renderer
  View: RendererView
}
