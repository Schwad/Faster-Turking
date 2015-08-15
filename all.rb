require 'rubygems'
require 'mechanize'
require 'pry-byebug'
require 'launchy'
require 'open-uri'

#Stepping away from feature to open links in reverse order from both pages. Just general reverse now.


def welcome

  puts "Welcome to Faster-Turking!"
  print "Enter MTURKGRIND website:"
  @mturkgrind = gets.chomp
  print "Enter MTURKFORUM website:"
  @mturkforum = gets.chomp

end

def initialize_mechanize
  @a = Mechanize.new
  @b = Mechanize.new
end

def inspect_links(page)
  if page.body.include?('There are no more available HITs') || page.body.include?('Your search did not match any HITs.') || page.body.include?('Your Qualifications do not meet the requirements to preview HITs in this group.') || page.body.include?('Not Qualified')
    false
  else
    true
  end
end

def bring_in_links(new_page, type)
  new_page.links_with(:href => %r{/mturk/}).each do |link|
<<<<<<< HEAD
    begin
      unless @links.include?(link.uri.to_s)
        begin
          new_page = link.click
          sleep 0.15
          if inspect_links(new_page) == true
            puts "Good link!"
            @links << link.uri.to_s
          else
            puts "Bad Link!"
          end
        rescue
          puts "Page error in bring_in_links -unless-!"
        end
=======
    unless @links.flatten.include?(link.uri.to_s)
      new_page = link.click
      sleep 0.15
      if inspect_links(new_page) == true
        puts "Good link!"
        if type == "grind"
          @links[0] << link.uri.to_s
        elsif type == "forum"
          @links[1] << link.uri.to_s
        end
      else
        puts "Bad Link!"
>>>>>>> 0641ba5dea3bfaacc929eb5c4054420040e4cb27
      end
    rescue
      puts "Page error in bring_in_links!"
    end
  end
end

def click_through_pages(starter_page, type)
  @page = 1
  @new_pages = true
  while @new_pages
    puts "Compiling #{type} links on page #{@page}"
<<<<<<< HEAD
    bring_in_links(starter_page)
    begin
      if type == 'grind'
        if starter_page.links_with(:text => /Next/).last == nil
          puts "Out of pages!"
          @new_pages = false
        else
         starter_page = starter_page.links_with(:text => /Next/).last.click
          @page += 1
        end
      elsif type == 'forum'
        if starter_page.links_with(:text => /Next/)[-3] == nil
          @new_pages = false
        else
          starter_page = starter_page.links_with(:text => /Next/)[-3].click
          @page += 1
        end
=======
    bring_in_links(starter_page, type)

    if type == 'grind'
      if starter_page.links_with(:text => /Next/).last == nil
        puts "Out of pages!"
        @new_pages = false
      else
       starter_page = starter_page.links_with(:text => /Next/).last.click
        @page += 1
      end
    elsif type == 'forum'
      if starter_page.links_with(:text => /Next/).length == 1
        puts "Out of pages!"
        @new_pages = false
      else
        starter_page = starter_page.links_with(:text => /Next/)[-3].click
        @page += 1
>>>>>>> 0641ba5dea3bfaacc929eb5c4054420040e4cb27
      end
    rescue
      puts "Page error in click_through_pages"
    end
  end
<<<<<<< HEAD
  puts "Links compiled! Total #{type} number is now #{@links.length}"
=======
  puts "Links compiled! Total number is now #{@links.flatten.length}"
>>>>>>> 0641ba5dea3bfaacc929eb5c4054420040e4cb27
  puts "Total pages was #{@page}"
  sleep 3
end


def analyze
  puts "Analyzing..."
  @a = @a.get(@mturkgrind)
  @b = @b.get(@mturkforum)
  @links = [[],[]]
  click_through_pages(@a, 'grind')
  click_through_pages(@b, 'forum')
end

def launch
  opener = 0
<<<<<<< HEAD
  @links.reverse_each do |link|
=======
  switcher = 0
  link_num = @links.flatten.length
  final_links = []
  link_num.times do
    final_links << @links[switcher].pop
    if switcher == 0
      switcher += 1
    elsif switcher == 1
      switcher -= 1
    else
      puts "Switcher error"
    end
  end
  final_links.reverse_each do |link|
>>>>>>> 0641ba5dea3bfaacc929eb5c4054420040e4cb27
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