#!/usr/bin/ruby
# https://github.com/istvanp/unsplash-rb

SOURCE     = "http://unsplash.tumblr.com/"
MAX_IMAGES = 50 # You can increase this number to fetch images further back
SAVE_PATH  = "~/Pictures/Unsplash/"

##### Don't edit below here #################################################

require File.expand_path(File.dirname(__FILE__)) + "/bundle/bundler/setup.rb"
require "mechanize"
require "nokogiri"

expanded_path = File.expand_path(SAVE_PATH.end_with?('/') ? SAVE_PATH : SAVE_PATH + '/')
source = SOURCE.end_with?('/') ? SOURCE : SOURCE + '/'
mecha = Mechanize.new
num   = [[50, MAX_IMAGES].min, 0].max
max   = [MAX_IMAGES, 0].max
loops = (max / 50.0).ceil
i = 0

FileUtils.mkdir_p expanded_path

begin
  offset = i * num
  uri = source + "api/read?type=photo&num=#{num}&start=#{offset}"
  xml = mecha.get(uri).body
  doc = Nokogiri::XML(xml)
  posts = doc.xpath("tumblr/posts/post")
  total = posts.length
  j = 0

  puts "Loop #{i + 1} of #{loops}"
  if total == 0
    puts "Stopping. No images found at offset #{offset}. (Reached the end?)"
    break
  end
  puts "Found #{total} images at #{uri}..."

  posts.each do |post|
    j += 1
    prefix = "[#{i + 1}/#{loops}][#{j}/#{total}] "
    name = post.xpath('@id').inner_text
    url  = post.xpath('@url').inner_text
    path = expanded_path + File::SEPARATOR + name + '.jpg'
    link = post.xpath('photo-link-url').inner_text
    if link.empty?
      link_text = post.xpath('photo-caption').inner_text
      link = link_text[/(http:\/\/[^\\"]*)/]
      if link.empty?
        puts "#{prefix}Skipping #{url} (no caption link) ..."
        next
      end
      html = mecha.get(link).body
      doc = Nokogiri::HTML(html)
      anchor = doc.css('.epsilon a[href*=download]')
      if anchor.empty?
        puts "#{prefix}Skipping #{url}/#{link} (no valid link) ..."
      next
    end
      link = anchor.xpath('@href')
    end
    if File.exists?(path)
      puts "#{prefix}Skipping #{link} #{path} exists ..."
      next
    end
    puts "#{prefix}Downloading #{link} to #{path} ..."
    mecha.get(link).save(path)
  end
  i += 1
end until i == loops

puts 'Done'
