require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.require(:default)
require 'thread'

class Lazyoptim
  PATH = '/srv/www/nadasuge/shared/public/system'

  def self.watch
    notifier = INotify::Notifier.new
    queue = Queue.new
    notifier.watch(PATH, :moved_to, :create) do |event|
      thread = Thread.new { ImageOptim.new.optimize_image!(event.name) }
      queue << thread
    end
  end
end

def main()
  if ARGV[0].nil?
    loop { Lazyoptim.watch }
  else
    queue = Queue.new
    Dir.entries(ARGV[0]).select do |f|
      unless File.directory?(f)
        thread = Thread.new { ImageOptim.new.optimize_image!(f.path) }
        queue << thread
      end
    end
  end
end

main()

