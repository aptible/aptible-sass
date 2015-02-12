class App.Models.Upload extends Backbone.Model
  types: /(\.|\/)(gif|jpe?g|png|tif)$/i

  initialize: ->
    f = @get('file')
    return unless f
    @set('id', f.name.replace(/\s/ig, '_'))

  get_preview_url: ->
    return '' unless @get('file')
    window.URL.createObjectURL @get('file')

  is_image: ->
    @types.test(@get('file').type) || @types.test(@get('file').name)

  as_json: ->
    $.extend(@toJSON(), {
      is_image: @is_image(),
      preview_url: @get_preview_url()
    })