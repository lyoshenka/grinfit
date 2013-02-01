namespace :assets do
  desc 'Compile assets after Jekyll generates site'
  task :postcompile do
    command = "for i in `find _site/ -type f -not -iregex '.*\.gz$'`; do gzip -c $i > $i.gz; done"
    output = %x{ #{command} 2>&1 }
    puts output if output.strip!
  end
end

task :test do
  desc 'For testing stuff'
end

task :preview do
  desc 'Build site locally and serve it at localhost:9292'
  exec('jekyll && rackup')
end

task :push do
  desc 'Commit to git and update live site'
  exec('git add -A && git commit -m "New post" && git push all master')
end

task :new => [:new_no_vi, :edit] do
  desc 'Create a new post with the given title, then open it in vi'
end

task :edit do
  desc 'Open the most recent post in vi'
  exec('vi ' + mostRecentPostFilename());
end

task :rename do
  desc 'Change the title of the most recent post'
  title = stringFromArgs('renamelast')
  oldFilename = mostRecentPostFilename()
  newFilename = makeFilename(oldFilename.match(/\d{4}-\d{2}-\d{2}/)[0], title)

  if File.exists?(newFilename)
    print "!!! File with new name already exists !!!\n"
    next
  end

  File.rename(oldFilename,newFilename)

  print oldFilename + ' => ' + newFilename + "\n"

  content = parsePostContent(File.open(newFilename, 'r') { |f| f.read })
  content['meta']['title'] = title
  File.open(newFilename, 'w') { |file| file.write(stringifyPostContent(content)) }
end

task :redate do 
  desc 'Change the date on the most recent post'
  require 'date'
  dateString = stringFromArgs('datelast')
  date = Date.parse(`date +%Y-%m-%d -d "#{dateString}"`.strip())
  oldFilename = mostRecentPostFilename()
  newFilename = makeFilename(date, File.basename(oldFilename).split('-').drop(3).join('-'))
  print oldFilename + " => " + newFilename + "\n"
  File.rename(oldFilename,newFilename)
end

task :new_no_vi do
  desc 'Create a new post with the given title'
  title = stringFromArgs('newpost')
  filename =  makeFilename(Time.now(), title)

  if File.exists?(filename)
    print "File already exists\n"
    next
  end

  File.open(filename, 'w') { |file| file.write("---\nlayout: post\ntitle: \"" + title + "\"\n---\n\n\n") }
  print filename + "\n"
end


def parsePostContent(content)
  require 'yaml'
  parts = content.split(/(?:^|\n)---\n/, 3)
  if (parts.count() != 3)
    abort('Could not parse post content')
  end
  Hash['meta' => YAML.load(parts[1]), 'body' => parts[2]]
end

def stringifyPostContent(postHash)
  require 'yaml'
  postHash['meta'].to_yaml.strip() + "\n---\n\n" + postHash['body'].sub(/^\n+/,'')
end

def stringFromArgs(taskName)
  args = ARGV.drop(1)
  if args.empty?
    abort("Usage: rake " + taskName + " Title or date or whatever goes here!\n")
  end
  preventErrorsForCommandLineArgs(args)
  args.join(' ')
end

def mostRecentPostFilename()
  Dir.glob(postsDir() + '/*').max()
end

def postsDir()
  File.expand_path(File.dirname(__FILE__)) + '/_posts'
end

def makeFilename(date,title)
  postsDir() + '/' + 
  (date.respond_to?(:strftime) ? date.strftime('%Y-%m-%d') : date) + 
  '-' + title.gsub(/\.md$/,'').downcase().gsub(/[^a-z0-9_]+/,'-') + '.md'
end

def preventErrorsForCommandLineArgs(args)
  # Rake treats each arg as a task, so we make fake tasks for each arg. Then it wont error.
  args.each do |arg|
    task arg.to_sym do ; end
  end
end
