require 'rubygems'
require 'mechanize'
require 'pry-byebug'
require 'launchy'
require 'open-uri'

def welcome

  puts "Welcome to Faster-Turking!"
  print "Enter website:"
  @website = gets.chomp

end

def initialize_mechanize
  @a = Mechanize.new
end

def inspect_links(page)
  if page.body.include?('There are no more available HITs') || page.body.include?('Your search did not match any HITs.') || page.body.include?('Your Qualifications do not meet the requirements to preview HITs in this group.') || page.body.include?('Not Qualified')
    false
  else
    true
  end
end

def bring_in_links(new_page)
  new_page.links_with(:href => %r{/mturk/}).each do |link|
    unless @links.include?(link.uri.to_s)
      new_page = link.click
      sleep 0.15
      if inspect_links(new_page) == true
        puts "Good link!"
        @links << link.uri.to_s
      else
        puts "Bad Link!"
      end
    end
  end
end

def click_through_pages(starter_page)
  @page = 1
  @new_pages = true
  while @new_pages
    puts "Compiling links on page #{@page}"
    bring_in_links(starter_page)
    if starter_page.links_with(:text => /Next/).last == nil
      @new_pages = false
    else
      starter_page = starter_page.links_with(:text => /Next/).last.click
      @page += 1
    end
  end
  puts "Links compiled! Total number is #{@links.length}"
  puts "Total pages was #{@page}"
end

def analyze
  puts "Analyzing..."
  @a = @a.get(@website)
  @links = []
  click_through_pages(@a)
end

def launch
  opener = 0
  @links.each do |link|
    if opener % 15 == 0
      puts "continue opening?"
      gets.chomp
    end
    Launchy.open(link)
    sleep 0.4
    opener += 1
  end
end

def cli_loop
  welcome
  initialize_mechanize
  analyze
  launch
end

cli_loop