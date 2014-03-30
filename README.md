![Aptible](http://aptible-media-assets-manual.s3.amazonaws.com/web-horizontal-350.png)

aptible-sass
===
This repo contains Aptible's common assets. Depends on:  

- Bootstrap 3
- HAML
- SASS
- Coffeescript
- jQuery
- Underscore.js
- Our routes helpers

### Install

1. Add a `.bowerrc` file to the root of your project. Specify where Bower should install the files with the line `{"directory": "your/path"}`
2. `bower install aptible-sass`
3. Add the Bower install directory to your `.gitignore` file.
4. Add the aptible-sass resources to your asset manifests. For JavaScripts, if you use Sprockets, add the aptible-sass directory to `config.asset.paths` in `application.rb` in addition to the Sprockets manifest. For SASS, `@import` the mixins and a layout file before Bootstrap. Include the main aptible-sass manifest after Bootstrap. See below for an examples.

Example project `application.scss`:
```CSS
@import "../../../vendor/assets/aptible-sass/dist/styles/aptible_fixed";
@import "font-awesome";
@import "policy_manuals";
```

Example project `application.rb`:
```ruby
require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env)
module Policy
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
//= require_directory ../../../vendor/assets/aptible-sass/dist/scripts
//= require_tree .
```

### Use
1. For local development of both aptible-sass and a project that depends on it, `bower link` in this directory, then `bower link aptible-sass` in your project.
2. Render partials with references to the full path
3. Add a `logo.png` and `logo@2x.png` to the asset pipeline. In your custom SASS, redefine `#brand_link.navbar`'s height and width.

### TODO  
- Extract container/layout specific variables into separate spec.

<small>&copy; 2014 Aptible</small>
