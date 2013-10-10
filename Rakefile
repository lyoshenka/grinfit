namespace :assets do
  desc 'Compile assets after Jekyll generates site'
  task :postcompile do
    command = "for i in `find _site/ -type f -not -iregex '.*\.gz$'`; do gzip -c $i > $i.gz; done"
    output = %x{ #{command} 2>&1 }
    puts output if output.strip!
  end
end


desc 'List all tasks'
task :default do
  exec('rake -T');
end


desc 'For testing stuff'
task :test do
end


desc 'Build site locally and serve it at localhost:9292'
task :preview do
  exec('jekyll && rackup')
end


desc 'List 10 recently modified posts'
task :list do
  listPosts
end


desc 'Commit to git and update live site'
task :push do
  exec('git add -A && git commit -m "New post" && git push all master')
end


desc 'Create a new post with the given title, then open it in vi'
task :new => [:new_no_vi, :edit] do
end


desc 'Open the nth most recent post in vi'
task :edit do
  n = ARGV[1].nil? ? 1 : ARGV[1].to_i()
  exec('vi ' + nthPostFilename(n));
end


desc 'Change the title of the nth most recent post'
task :rename do
  n = is_filenum?(ARGV[1]) ? ARGV[1].to_i() : nil
  title = stringFromArgs(n.nil? ? 0 : 1)
  if title.empty?
    puts "Usage: rake rename [NUM] NEW TITLE GOES HERE\n"
    listPosts
    abort
  end
  oldFilename = nthPostFilename(n.nil? ? 1 : n)
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


desc 'Change the date on the nth most recent post'
task :redate do 
  require 'date'
  n = is_filenum?(ARGV[1]) ? ARGV[1].to_i() : nil
  dateString = stringFromArgs(n.nil? ? 0 : 1)
  if dateString.empty?
    puts "Usage: rake redate [NUM] NEW DATE AS STRING\n"
    listPosts
    abort
  end

  date = Date.parse(`date +%Y-%m-%d -d "#{dateString}"`.strip())
  oldFilename = nthPostFilename()
  newFilename = makeFilename(date, File.basename(oldFilename).split('-').drop(3).join('-'))
  print oldFilename + " => " + newFilename + "\n"
  File.rename(oldFilename,newFilename)
end


desc 'Create a new post with the given title'
task :new_no_vi do
  title = stringFromArgs()
  if title.empty?
    abort "Usage: rake newpost POST TITLE GOES HERE\n"
  end
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

def stringFromArgs(prevArgs=0)
  # prevArgs is how many arguments went before this one. that is, how many to skip
  args = ARGV.drop(1+prevArgs)
  preventErrorsForCommandLineArgs()
  args.join(' ')
end

def nthPostFilename(n=1)
  # n=0 means get the latest file by date. otherwise, get the nth most recently modified file
  n == 0 ? 
    Dir.glob(postsDir() + '/*').max() : 
    postsDir + '/' + `#{'ls -1t ' + postsDir() + '/ | sed -n ' + n.to_s() + 'p'}`.strip()
end

def postsDir()
  File.expand_path(File.dirname(__FILE__)) + '/_posts'
end

def listPosts()
  exec 'ls -1t ' + postsDir() + '/ | head -n 10 | nl -w 3'
end

def makeFilename(date,title)
  postsDir() + '/' + 
  (date.respond_to?(:strftime) ? date.strftime('%Y-%m-%d') : date) + 
  '-' + title.gsub(/\.md$/,'').downcase().gsub(/[^a-z0-9_]+/,'-') + '.md'
end

def is_filenum?(str)
  is_i?(str) && str.to_i() >= 1 && str.to_i() <= 10
end

def is_i?(str)
  !!(str =~ /^[-+]?[0-9]+$/)
end

def preventErrorsForCommandLineArgs()
  # Rake treats each arg as a task, so we make fake tasks for each arg. Then it wont error.
  ARGV.each do |arg|
    sym = arg.to_sym
    if !Rake::Task.task_defined?(sym)
      task sym do ; end
    end
  end
end
