require 'snapshot/renderer'

Tinypantry::Application.config.middleware.use(Snapshot::Renderer)
