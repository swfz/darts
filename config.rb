require 'slim'
require 'middleman-gh-pages'

set :less
set :fonts_dir,  "fonts/less"

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy '/this-page-has-no-template.html', '/template-file.html', locals: {
#  which_fake_page: 'Rendering a fake page with a local variable' }

###
# Helpers
###
require 'helpers/darts_helpers'

helpers CricketRating
helpers ZerooneRating
helpers Stats
helpers Flight
helpers FormatFloat

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  activate :directory_indexes
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
configure :build do
  activate :directory_indexes
  # active   :relative_assets
  # activate :asset_host, :host => "/darts"
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end





