require 'thread'

loop do
  Lazyoptim.watch
end

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