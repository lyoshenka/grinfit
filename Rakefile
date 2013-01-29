namespace :assets do
  desc 'Compile assets after Jekyll generates site'
  task :postcompile do
    command = "for i in `find _site/ -type f -not -iregex '.*\.gz$'`; do gzip -c $i > $i.gz; done"
    output = %x{ #{command} 2>&1 }
    puts output if output.strip!
  end
end

task :test do
  exec('jekyll && rackup')
end

# newpost = make a new post, then edit the last post
task :newpost => [:newpost_no_vi, :editlast] do ; end

task :editlast do
  filename = Dir.glob(postsDir() + '/*').max()
  exec('vi ' + filename);
end

task :newpost_no_vi do
  args = ARGV.drop(1)
  if args.empty?
    print "Need a post title!\n"
    next
  end

  preventErrorsForCommandLineArgs(args)

  title = args.join(' ')
  filename =  postsDir()  + '/' + Time.now().strftime('%Y-%m-%d') + '-' + titleToFilename(title)

  if File.exists?(filename)
    print "File already exists\n"
    next
  end

  File.open(filename, 'w') { |file| file.write("---\nlayout: post\ntitle: \"" + title + "\"\n---\n\n\n") }
  print filename + "\n"
end

def postsDir()
  File.expand_path(File.dirname(__FILE__)) + '/_posts'
end

def titleToFilename(title)
  title.downcase().gsub(/[^a-z0-9_]+/,'-') + '.md'
end

def preventErrorsForCommandLineArgs(args)
  # Rake treats each arg as a task, so we make fake tasks for each arg. Then it wont error.
  args.each do |arg|
    task arg.to_sym do ; end
  end
end
