require 'snapshot/renderer'

Tinypantry::Application.config.middleware.insert_before(Rack::Lock, Snapshot::Renderer)
