# Unsplash.com Downloader
Periodically downloads images from free photography resource site [unsplash.com](unsplash.com).

## Requirements
- Ruby 2.0+
  - Tested with [rbenv](https://github.com/sstephenson/rbenv) running Ruby 2.1.0 and Mavericks system Ruby (2.0.0p247)
- [RubyGems](http://rubygems.org/)
- [Bundler](https://github.com/bundler/bundler/)
  - Run `gem install bundler` to install

## Setup
1. Clone this repository:  
   `git clone https://github.com/istvanp/unsplash-rb.git ~/.unsplash`
2. Open Terminal.app
3. `cd ~/.unsplash`
4. `bundle --standalone`
5. `open unsplash.rb` and adjust the following to your liking:  
   * `MAX_IMAGES` How many images to try to retrieve. Make this a large number to initially retrieve all images. Reduce it to about 50 afterwards.  
   * `SAVE_PATH`: Where to save the images. Defaults to "Unsplash" inside your Pictures directory.
   
## Usage
Run `~/.unsplash/unsplash.rb` in the terminal.
   
## Run Periodically
To run this script every seven days do the following:

1. `cd ~/.unsplash`
2. `ln -sfv "$(pwd)" /usr/local/opt`
3. `ln -sfv "$(pwd)/co.istvan.unsplash.plist" ~/Library/LaunchAgents`
4. `launchctl load ~/Library/LaunchAgents/co.istvan.unsplash.plist`

## Credits
Created by Istvan Pusztai. Inspired by [mcdado/unsplash-dl](https://github.com/mcdado/unsplash-dl).