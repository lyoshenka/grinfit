require 'yaml'
require 'chronic'
require 'colorize'


#
# Constants (configure these as you wish)
#

POSTS_DIR = '_posts'
EDITOR = 'vi'
TIMEZONE = 'America/New_York'


#
# Generally useful tasks
#


desc 'List all tasks'
task :default do
  exec('rake -T');
end

desc 'Build and serve site locally via Jekyll'
task :serve do
  exec('bundle exec jekyll serve --watch')
end

desc 'Build and serve via Thin'
task :run do
  exec('jekyll build && bundle exec thin start -R config.ru')
end


desc 'Commit to git and push'
task :push do
  exec('bundle exec jekyll build && git add -A && git commit -m "new content" && git push && ./deploy.sh')
end



#
# Creating/Editing Posts
#


desc 'List posts (recently modified posts first)'
task :ls do
  listPosts(is_i?(ARGV[1]) ? ARGV[1].to_i : 20)
  preventErrorsForCommandLineArgs()
end
task :list => :ls


desc 'Show a post'
task :show do
  args = parseArgs(endstring: false)
  exec('cat ' + args[:filename]);
  preventErrorsForCommandLineArgs()
end
task :cat => :show


desc 'New stronglifts post'
task :sl do
  args = parseArgs(filenum: false)
  letter = args[:rest].upcase
  if not ['A', 'B'].include? letter
    abort "Usage: rake sl [a | b]\n"
  end

  setTZ()
  now = Time.now()

  title = "Stronglifts 5x5 " + letter.upcase
  filename = makeFilename(now, title)

  if File.exists?(filename)
    print "File already exists\n"
    next
  end

  slA = "- Bench:    {% w 5x5@lb %}\n- Row:      {% w 5x5@lb %}\n"
  slB = "- Press:    {% w 5x5@lb %}\n- Deadlift: {% w 1x5@lb %}\n"
  body = "- RLESS:    {% w 5x5@lb %}\n" + (letter == 'A' ? slA : slB) + "- Pullups:  {% w 5x5@lb %}\n"

  savePost(filename, {'meta' => {'title' => title, 'date' => now.strftime('%F %T'), 'tags' => ['lifting', 'stronglifts']}, 'body' => body})
  exec(EDITOR + ' ' + filename)
end


desc 'Copy an existing post to today and open for editing'
task :copy do
  args = parseArgs()
  post = getPost(args[:filename])
  now = Time.now()
  post['meta']['_id_'] = newID()
  post['meta']['date'] = now.strftime('%F %T')
  filename = makeFilename(now, post['meta']['title'])
  if File.exists?(filename)
    print "File already exists\n"
    next
  end
  savePost(filename, post)
  exec(EDITOR + ' ' + filename)
end


desc 'Create a new post with the given title and open it in the editor'
task :new do
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
  exec(EDITOR + ' ' + filename)
end


desc 'Open existing post in editor'
task :edit do
  args = parseArgs(endstring: false)
  exec(EDITOR + ' ' + args[:filename]);
end


desc 'Change the title of a post'
task :rename do
  args = parseArgs()
  title = args[:rest]
  if title.empty?
    puts "Usage: rake rename [ID] NEW TITLE GOES HERE\n"
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


desc 'Change the date on a post'
task :redate do
  args = parseArgs()
  dateString = args[:rest]
  if dateString.empty?
    puts "Usage: rake redate [ID] NEW DATE AS STRING\n"
    listPosts
    abort
  end

  changeDateTime(args[:filename], dateString, :date)
end


desc 'Change the time on a post'
task :retime do
  args = parseArgs()
  timeString = args[:rest]
  if timeString.empty?
    puts "Usage: rake retime [ID] NEW TIME AS STRING\n"
    listPosts
    abort
  end

  changeDateTime(args[:filename], timeString, :time)
end



#
# Tagging
#

desc 'List tags'
task :tags do
  tagCounts = {}
  maxLength = 0
  getPostsInOrder().each() do |file|
    post = getPost(file)
    post['meta']['tags'].to_a().each() do |tag|
      if !tagCounts.has_key?(tag)
        tagCounts[tag] = 0
      end
      tagCounts[tag] += 1
      if tag.length > maxLength
        maxLength = tag.length
      end
    end
  end

  tagBuckets = {}
  tagCounts.each() do |tag,count|
    if (!tagBuckets.has_key?(count))
      tagBuckets[count] = []
    end
    tagBuckets[count].push(tag)
  end

  maxLength += 1 # extra padding
  tagBuckets.sort_by{ |count,tags| count }.reverse().each() do |count,tags|
    tags.sort.each() do |tag|
      printf ("%-" + maxLength.to_s + "s %d\n") % [tag, count]
    end
  end
end


desc 'Add tag'
task :tag do
  args = parseArgs()
  tags = args[:rest].downcase().split(' ')
  post = getPost(args[:filename])
  post['meta']['tags'] = post['meta']['tags'].to_a().concat(tags).uniq().sort()
  savePost(args[:filename], post)
  printPostLine(args[:filename])
end


desc 'Remove tag'
task :untag do
  args = parseArgs()
  tags = args[:rest].downcase().split(' ')
  post = getPost(args[:filename])
  post['meta']['tags'] = tags.empty? ? [] : post['meta']['tags'].to_a().reject{ |tag| tags.include?(tag) }
  savePost(args[:filename], post)
  printPostLine(args[:filename])
end



#
# Housekeeping
#

desc 'Fill in missing post ids'
task :fixids do
  getPostsInOrder().each() do |file|
    post = getPost(file)
    if (!post['meta'].has_key?('_id_'))
      puts "Setting ID for " + file
      savePost(file, post)
    end
  end
end


desc 'Touch last 20 posts so "rake ls" lists them in the correct order'
task :retouch do
  puts "This is gonna take 20 seconds"
  Dir.glob(postsDir()+'/*').sort_by{|f| f}.last(20).each() do |file|
    FileUtils.touch(file)
    sleep(1)
  end
end



#
# Helper functions
#


def setTZ()
  ENV["TZ"] = TIMEZONE
end


def changeDateTime(filename, string, dateOrTime)
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

  if (dateOrTime == :date)
    newFilename = makeFilename(newDateTime, post['meta']['title']);
    if File.exists?(newFilename)
      print "!!! File named #{newFilename} already exists !!!\n"
      return
    end
  end

  post['meta']['date'] = newDateTime.strftime('%F %T');
  puts postDateTime.strftime("%F %T") + ' => ' + newDateTime.strftime('%F %T')
  savePost(filename, post)

  if (dateOrTime == :date)
    puts "#{filename} => #{newFilename}"
    File.rename(filename,newFilename);
  end
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
      postId = firstArg.to_i >= 1 ? firstArg : nil
      args[:filename] = getPostById(postId).strip
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


def printPostLine(file)
  post = getPost(file)
  tags = post['meta']['tags'].to_a.empty? ? '' : (' [' + post['meta']['tags'].join(' ') + ']')
  printf "%s %s%s\n" % [post['meta']['_id_'].slice(0,6).blue, File.basename(file), tags.yellow]
end


def listPosts(limit=10)
  getPostsInOrder().first(limit).each() do |file|
    printPostLine(file)
  end
end


def getPostsInOrder()
  #Dir.glob(postsDir()+'/*').sort_by{|f| File.mtime(f)}.reverse()
  Dir.glob(postsDir()+'/*').sort_by{|f| File.basename(f)}.reverse()
end


def getPostById(id)
  getPostsInOrder().each() do |file|
    post = getPost(file)
    if post['meta']['_id_'].start_with?(id.to_s)
      return file
    end
  end

  puts "Post with id #{id} does not exist"
  abort
end


def getPost(filename)
  parts = File.open(filename, 'r') { |f| f.read }.split(/(?:^|\n)---\n/, 3)
  if (parts.count() != 3)
    abort('Could not parse post ' + filename.to_s)
  end
  {'meta' => YAML.load(parts[1]), 'body' => parts[2]}
end


def savePost(filename, post)
  # check for ID, create if necessary
  if (!post['meta'].has_key?('_id_'))
    post['meta']['_id_'] = newID()
  end

  # alphabetize metadata
  post['meta'] = Hash[post['meta'].sort_by{|k, _| k}]

  content = post['meta'].to_yaml.strip() + "\n---\n\n" + post['body'].sub(/^\n+/,'')
  File.open(filename, 'w') { |file| file.write(content) }
end


def postsDir()
  File.expand_path(File.dirname(__FILE__)) + '/' + POSTS_DIR
end


def makeFilename(date,title)
  postsDir() + '/' +
  (date.respond_to?(:strftime) ? date.strftime('%Y-%m-%d') : date) +
  '-' + title.gsub(/\.md$/,'').downcase().gsub(/[^a-z0-9_]+/,'-') + '.md'
end


def is_i?(str)
  !!(str =~ /^[-+]?[0-9]+$/)
end

def newID()
  rand(10 ** 16).to_s.ljust(16,'0')
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
