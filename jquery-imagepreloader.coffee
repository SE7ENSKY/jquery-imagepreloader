###! jquery-imagepreloader 2.0.0 http://github.com/Se7enSky/jquery-imagepreloader###
###
@name jquery-imagepreloader
@description Just another wheel reinvent. Advanced image preloader.
@version 2.0.0
@author Se7enSky studio <info@se7ensky.com>
@dependencies async
###

plugin = ($, async) ->
	###
		opts:
			attr: 'data-src'
			threads: 5
			retries: 5
			done: ->
			percentage: (percentage) ->
	###

	$.fn.imagepreloader = (opts) ->
		attrName = opts.attr or 'data-src'
		images = @toArray()
		if images.length is 0
			opts.percentage 100 if opts.percentage
			opts.done() if opts.done()
			return
		baseImagesToLoad = imagesToLoad = images.length

		reportProgress = ->
			opts.percentage Math.floor(100 * (baseImagesToLoad - imagesToLoad) / baseImagesToLoad) if opts.percentage
			opts.done() if opts.done and imagesToLoad is 0

		loadImage = (image, retryLimit, cb) ->
			src = $(image).attr attrName
			$(image).bind 'load', ->
				$(image).unbind 'load error'
				imagesToLoad--
				$(image).removeAttr attrName
				reportProgress()
				# cb null
				setTimeout ->
					cb null
				, 1000 * Math.random()
			$(image).bind 'error', ->
				$(image).unbind 'load error'
				if retryLimit is 0
					imagesToLoad--
					$(image).removeAttr attrName
					reportProgress()
					cb null
				else
					loadImage image, retryLimit - 1, cb
			image.src = null if image.src
			image.src = src

		async.eachLimit images, (opts.threads or 5), (image, cb) ->
			loadImage image, (opts.retries or 5), cb

		@ # chaining


# UMD 
if typeof define is 'function' and define.amd then define(['jquery', 'async'], plugin) else plugin(jQuery, async)
