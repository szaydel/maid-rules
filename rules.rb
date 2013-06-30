# Sample Maid rules file -- some ideas to get you started.
#
# To use, remove ".sample" from the filename, and modify as desired.  Test using:
#
#     maid clean -n
#
# **NOTE:** It's recommended you just use this as a template; if you run these rules on your machine without knowing
# what they do, you might run into unwanted results!
#
# Don't forget, it's just Ruby!  You can define custom methods and use them below:
# 
#     def magic(*)
#       # ...
#     end
# 
# If you come up with some cool tools of your own, please send me a pull request on GitHub!  Also, please consider sharing your rules with others via [the wiki](https://github.com/benjaminoakes/maid/wiki).
#
# For more help on Maid:
#
# * Run `maid help`
# * Read the README, tutorial, and documentation at https://github.com/benjaminoakes/maid#maid
# * Ask me a question over email (hello@benjaminoakes.com) or Twitter (@benjaminoakes)
# * Check out how others are using Maid in [the Maid wiki](https://github.com/benjaminoakes/maid/wiki)

Maid.rules do
  # **NOTE:** It's recommended you just use this as a template; if you run these rules on your machine without knowing
  # what they do, you might run into unwanted results!

dmg_dir = '~/Downloads/AppPkgs'
win_iso_dir = '~/Downloads/isos/Windows'

  rule 'Deleting or Moving dmg\'s to: '+ dmg_dir do
    mkdir(dmg_dir)
    dir(['~/Downloads/*.dmg',]).each do |file|
      trash(file) if 8.week.since?(accessed_at(file)) 
    end

    dir(['~/Downloads/*.dmg',]).each do |file|
      move(file, dmg_dir) if 1.week.since?(modified_at(file))
    end  
  end

  rule 'Move Windows iso archives to iso/Windows dir after 1 week' do    
    mkdir(win_iso_dir)
    for file in dir('~/Downloads/*windows*.iso')
      move(file, win_iso_dir) if 1.week.since?(modified_at(file))
    end
  end

  rule 'Move rar archives to rars dir after 2 weeks' do    
    rars_dir = '~/Downloads/rars'
    mkdir(rars_dir)
    for file in dir('~/Downloads/*.rar')
      move(file, rars_dir) if 2.week.since?(accessed_at(file))
    end
  end

  rule 'Move .epub files to unsorted after 3 days' do
    ## We should not clutter the Downloads directory with books, instead we should move them
    ## and sort them later. Some .pdfs may not be books, but majority will be.
    unsorted_books_dir='~/Books/Unsorted'
    mkdir(unsorted_books_dir)
    for file in dir('~/Downloads/*.epub')
      move(file, unsorted_books_dir) if 3.days.since?(accessed_at(file))
    end
  end

  rule 'Move .pdf files to unsorted after 3 days' do
    ## We should not clutter the Downloads directory with books, instead we should move them
    ## and sort them later. Some .pdfs may not be books, but majority will be.
    unsorted_books_dir='~/Books/Unsorted'
    mkdir(unsorted_books_dir)
    for file in dir('~/Downloads/*.{pdf}')
      if  disk_usage(file) > 8192
        puts disk_usage(file)
        move(file, unsorted_books_dir) if 3.days.since?(accessed_at(file))
      end
    end
  end

  rule "Trash files that shouldn't have been downloaded" do
    # It's rare that I download these file types and don't put them somewhere else quickly.
    # More often, these are still in Downloads because it was an accident.
    dir('~/Downloads/*.{csv,doc,docx,ics,ppt,pptx,js,rb,xml,xlsx}').each do |file|
      trash(file) if accessed_at(file) > 3.days.ago
    end

    # Quick 'n' dirty duplicate download detection
    trash(dir('~/Downloads/* (1).*'))
    trash(dir('~/Downloads/* (2).*'))
    trash(dir('~/Downloads/*.1'))
  end

#  rule 'List all zip archives' do
#    dir('~/Downloads/*.zip')
#  end

#  rule 'Linux ISOs, etc' do
#    trash(dir('~/Downloads/*.iso'))
#  end

#  rule 'Linux applications in Debian packages' do
#    trash(dir('~/Downloads/*.deb'))
#  end

#  rule 'Mac OS X applications in disk images' do
#    trash(dir('~/Downloads/*.dmg'))
#  end

#  rule 'Mac OS X applications in zip files' do
#    found = dir('~/Downloads/*.zip').select { |path|
#      zipfile_contents(path).any? { |c| c.match(/\.app$/) }
#    }

#    trash(found)
#  end

#  rule 'Misc Screenshots' do
#    dir('~/Desktop/Screen shot *').each do |path|
#      if 1.week.since?(accessed_at(path))
#        move(path, '~/Documents/Misc Screenshots/')
#      end
#    end
#  end

  # NOTE: Currently, only Mac OS X supports `duration_s`.
#  rule 'MP3s likely to be music' do
#    dir('~/Downloads/*.mp3').each do |path|
#      if duration_s(path) > 30.0
#        move(path, '~/Music/iTunes/iTunes Media/Automatically Add to iTunes/')
#      end
#    end
#  end
  
  # NOTE: Currently, only Mac OS X supports `downloaded_from`.
#  rule 'Old files downloaded while developing/testing' do
#    dir('~/Downloads/*').each do |path|
#      if downloaded_from(path).any? { |u| u.match('http://localhost') || u.match('http://staging.yourcompany.com') } &&
#          1.week.since?(accessed_at(path))
#        trash(path)
#      end
#    end
#  end

#  rule 'Mac OS X applications in zip files' do
#    found = dir('~/Downloads/*.zip').select do |path|
#      zipfile_contents(path).any? { |c| c.match(/\.app[\/]*$/) }
#    end
#
#    trash(found)
#  end
end
