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
  listPosts
end
task :list => :ls


desc 'Commit to git and update live site'
task :push do
  exec('git add -A && git commit -m "New post" && git push all master')
end


desc 'Add tag'
task :tag do
  args = parseArgs()
  tags = args[:rest].split(' ')
  post = getPost(args[:filename])
  post['meta']['tags'] = post['meta']['tags'].to_a().concat(tags).uniq()
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
    abort "Usage: rake newpost POST TITLE GOES HERE\n"
  end
  filename = makeFilename(Time.now(), title)

  if File.exists?(filename)
    print "File already exists\n"
    next
  end

  savePost(filename, {'meta' => {'layout' => 'post', 'title' => title}, 'body' => ''})
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
  require 'date'
  args = parseArgs()
  dateString = args[:rest]
  if dateString.empty?
    puts "Usage: rake redate [NUM] NEW DATE AS STRING\n"
    listPosts
    abort
  end

  date = Date.parse(`date +%Y-%m-%d -d "#{dateString}"`.strip())
  oldFilename = args[:filename]
  newFilename = makeFilename(date, File.basename(oldFilename).split('-').drop(3).join('-'))
  print oldFilename + " => " + newFilename + "\n"
  File.rename(oldFilename,newFilename)
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
  n = filenum && is_filenum?(ARGV[1]) ? ARGV[1].to_i : nil
  args = {:filename => nil, :rest => nil}
  if filenum
    args[:filename] = Dir.glob(postsDir()+'/*').sort_by{|f| File.mtime(f)}.reverse().fetch(n.nil? ? 0 : n-1).strip()
  end
  if endstring
    args[:rest] = ARGV.drop(n.nil? ? 1 : 2).join(' ')
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
  Dir.glob(postsDir()+'/*').sort_by{|f| File.mtime(f)}.reverse().first(limit).each() do |file|
    post = getPost(file)
    tags = post['meta']['tags'].to_a.empty? ? '' : (' [' + post['meta']['tags'].join(' ') + ']')
    printf "%2d)  %s%s\n" % [num, File.basename(file), tags.yellow]
    num += 1
  end
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
