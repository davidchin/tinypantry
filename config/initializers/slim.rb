Rails.application.assets.register_engine('.slim', Slim::Template)

Slim::Engine.set_default_options attr_delims: { '(' => ')', '[' => ']' }
