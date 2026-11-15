# Rails 7+ uses Zeitwerk exclusively, which would otherwise expect
# app/models/xws.rb to define `Xws` rather than `XWS`.
Rails.autoloaders.main.inflector.inflect("xws" => "XWS")
