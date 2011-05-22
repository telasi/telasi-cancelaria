# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Canc::Application.initialize!

# CSS mime type
Mime::Type.register 'text/css', :css