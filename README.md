![Aptible](http://aptible-media-assets-manual.s3.amazonaws.com/web-horizontal-350.png)

aptible-sass
===
This repo contains Aptible's common assets for many of our customer-facing sites. Compatible with Bootstrap 3.

It consists of layout partials, stylesheets, and scripts. You can use any or all of them as you see fit.

### Install

1. Add a `.bowerrc` file to the root of your project. Specify where Bower should install the files with the line `{"directory": "your/path"}`
2. `bower install aptible-sass`
3. Add the Bower install directory to your `.gitignore` file.
4. Add the aptible-sass resources to your asset manifests. For Javascripts, if you use Sprockets, add the aptible-sass directory to `config.asset.paths` in `application.rb`, in addition to the Sprockets manifest. For SASS, `@import` the mixins and a layout file before Bootstrap. Include the main aptible-sass manifest after Bootstrap. See below for an examples.

Example project `application.scss`:
TODO

Example project `application.rb`:
```ruby
require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env)
module PolicyAptibleCom
  class Application < Rails::Application
    # Sprockets needs this, in addition to the manifest
    config.assets.paths << Rails.root.join(
      'vendor',
      'aptible-sass',
      'dist',
      'scripts'
    )
  end
end
```
Example project `application.js`:
```javascript
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require bootstrap
//= require policy
//= require_directory ../../../vendor/aptible-sass/dist/scripts
//= require_tree .
```

### Use

1. Render partials with references to the full path
2. Add a `logo.png` and `logo@2x.png` to the asset pipeline. In your custom SASS, redefine `#brand_link.navbar`'s height and width.

### TODO  
- Extract container/layout specific variables into separate spec.

<small>&copy; 2014 Aptible</small>
