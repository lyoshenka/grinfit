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
  exec('bundle exec jekyll --server')
end


desc 'List 10 recently modified posts'
task :ls do
  listPosts(is_i?(ARGV[1]) ? ARGV[1].to_i : 20)
  preventErrorsForCommandLineArgs()
end
task :list => :ls


desc 'Commit to git and update live site'
task :push do
  exec('git add -A && git commit -m "New post" && git push')
end


desc 'Add tag'
task :tag do
  args = parseArgs()
  tags = args[:rest].split(' ')
  post = getPost(args[:filename])
  post['meta']['tags'] = post['meta']['tags'].to_a().concat(tags).uniq().sort()
  savePost(args[:filename], post)
  listPosts(1)
end


desc 'Remove tag'
task :untag do
  args = parseArgs()
  tags = args[:rest].split(' ')
  post = getPost(args[:filename])
  post['meta']['tags'] = tags.empty? ? [] : post['meta']['tags'].to_a().reject{ |tag| tags.include?(tag) }
  savePost(args[:filename], post)
  listPosts(1)
end


desc 'Create a new post with the given title, then open it in vi'
task :new => [:new_no_vi, :edit] do
end


desc 'Create a new post with the given title'
task :new_no_vi do
  args = parseArgs(filenum: false)
  title = args[:rest]
  if title.empty?
    abort "Usage: rake new POST TITLE GOES HERE\n"
  end

  setTZ()
  now = Time.now()
  
  filename = makeFilename(now, title)

  if File.exists?(filename)
    print "File already exists\n"
    next
  end

  savePost(filename, {'meta' => {'title' => title, 'date' => now.strftime('%F %T')}, 'body' => ''})
  listPosts(1)
end


desc 'Open the nth most recent post in vi'
task :edit do
  args = parseArgs(endstring: false)
  exec('vi ' + args[:filename]);
end


desc 'Change the title of the nth most recent post'
task :rename do
  args = parseArgs()
  title = args[:rest]
  if title.empty?
    puts "Usage: rake rename [NUM] NEW TITLE GOES HERE\n"
    listPosts
    abort
  end
  oldFilename = args[:filename]
  newFilename = makeFilename(oldFilename.match(/\d{4}-\d{2}-\d{2}/)[0], title)

  if File.exists?(newFilename)
    print "!!! File with new name already exists !!!\n"
    next
  end

  File.rename(oldFilename,newFilename)

  print oldFilename + ' => ' + newFilename + "\n"

  post = getPost(newFilename)
  post['meta']['title'] = title
  savePost(newFilename, post)
end


desc 'Change the date on the nth most recent post'
task :redate do
  args = parseArgs()
  dateString = args[:rest]
  if dateString.empty?
    puts "Usage: rake redate [NUM] NEW DATE AS STRING\n"
    listPosts
    abort
  end

  changeDateTime(args[:filename], dateString, :date)
end


desc 'Change the time on the nth most recent post'
task :retime do
  args = parseArgs()
  timeString = args[:rest]
  if timeString.empty?
    puts "Usage: rake retime [NUM] NEW TIME AS STRING\n"
    listPosts
    abort
  end

  changeDateTime(args[:filename], timeString, :time)
end




def setTZ()
  ENV["TZ"] = "America/New_York"
end

def changeDateTime(filename, string, dateOrTime)
  require 'chronic'
  setTZ()

  post = getPost(filename)

  # get date from metadata. if thats not there, get it from filename
  postDateTime = Chronic.parse(post['meta']['date'] || File.basename(filename).split('-').first(3).join('-'))

  parsed = Chronic.parse(string, :context => :past)

  if (dateOrTime == :date)
    newDateTimeString = parsed.strftime('%F') + ' ' + postDateTime.strftime('%T')
  elsif (dateOrTime == :time)
    newDateTimeString = postDateTime.strftime('%F') + ' ' + parsed.strftime('%T')
  else
    raise "dateOrTime arg must be :date or :time"
  end

  newDateTime = Chronic.parse(newDateTimeString);

  post['meta']['date'] = newDateTime.strftime('%F %T');
  puts postDateTime.strftime("%F %T") + ' => ' + newDateTime.strftime('%F %T')
  savePost(filename, post)

  if (dateOrTime == :date)
    newFilename = makeFilename(newDateTime, post['meta']['title']);
    puts "#{filename} => #{newFilename}"
    File.rename(filename,newFilename);
  end
end

def getPost(filename)
  require 'yaml'
  parts = File.open(filename, 'r') { |f| f.read }.split(/(?:^|\n)---\n/, 3)
  if (parts.count() != 3)
    abort('Could not parse post ' + filename.to_s)
  end
  {'meta' => YAML.load(parts[1]), 'body' => parts[2]}
end

def savePost(filename, post)
  require 'yaml'
  content = post['meta'].to_yaml.strip() + "\n---\n\n" + post['body'].sub(/^\n+/,'')
  File.open(filename, 'w') { |file| file.write(content) }
end


def parseArgs(filenum: true, endstring: true)
  args = {:filename => nil, :rest => nil}
  skipFirstArg = false

  if filenum
    skipFirstArg = true
    firstArg = ARGV[1]
    # is firstarg a filename of an existing post
    if !firstArg.nil? && (firstArg[0] == '/' && File.exist?(firstArg) || File.exist?(postsDir()+'/'+firstArg))
      args[:filename] = postsDir()+'/' +File.basename(firstArg)
    elsif is_i?(firstArg)
      nthFile = firstArg.to_i >= 1 ? firstArg.to_i-1 : 0
      args[:filename] = getPostsInOrder.fetch(nthFile).strip
    else
      args[:filename] = getPostsInOrder.first.strip
      skipFirstArg = false
    end
  end

  if endstring
    args[:rest] = ARGV.drop(skipFirstArg ? 2 : 1).join(' ')
    preventErrorsForCommandLineArgs()
  end

  args
end


def postsDir()
  File.expand_path(File.dirname(__FILE__)) + '/_posts'
end

def listPosts(limit=10)
  require 'colorize'
  num = 1
  getPostsInOrder().first(limit).each() do |file|
    post = getPost(file)
    tags = post['meta']['tags'].to_a.empty? ? '' : (' [' + post['meta']['tags'].join(' ') + ']')
    printf "%2d)  %s%s\n" % [num, File.basename(file), tags.yellow]
    num += 1
  end
end

def getPostsInOrder()
  Dir.glob(postsDir()+'/*').sort_by{|f| File.mtime(f)}.reverse()
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
