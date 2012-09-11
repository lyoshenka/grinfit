namespace :assets do
  desc 'Compile assets after Jekyll generates site'
  task :postcompile do
    return # not enabled yet
    command = "for i in `find _site/ -type f -not -iregex '.*\.gz$'`; do gzip -c $i > $i.gz; done"
    output = %x{ #{command} 2>&1 }
    puts output if output.strip!
  end
end
