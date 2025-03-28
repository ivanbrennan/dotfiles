require 'rubygems'
require 'yaml'
require 'irb/completion'

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("3.2")
  require 'irb/ext/save-history'
end

IRB.conf[:SAVE_HISTORY] = 200
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"
IRB.conf[:BACK_TRACE_LIMIT] = 50

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end

  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b)
    end
  end
end

ANSI = {}
ANSI[:RESET]     = "\033[0m"
ANSI[:BOLD]      = "\033[1m"
ANSI[:UNDERLINE] = "\033[4m"
ANSI[:LGRAY]     = "\033[0;37m"
ANSI[:GRAY]      = "\033[1;30m"
ANSI[:RED]       = "\033[31m"
ANSI[:GREEN]     = "\033[32m"
ANSI[:YELLOW]    = "\033[33m"
ANSI[:BLUE]      = "\033[34m"
ANSI[:MAGENTA]   = "\033[35m"
ANSI[:CYAN]      = "\033[36m"
ANSI[:WHITE]     = "\033[37m"

# Build a simple colorful IRB prompt
IRB.conf[:PROMPT][:SIMPLE_COLOR] = {
  :PROMPT_I => "#{ANSI[:LGRAY]}%03n#{ANSI[:CYAN]}:#{ANSI[:LGRAY]}%i#{ANSI[:BLUE]} ❯#{ANSI[:RESET]} ",
  :PROMPT_N => "#{ANSI[:LGRAY]}%03n#{ANSI[:CYAN]}:#{ANSI[:LGRAY]}%i%l#{ANSI[:BLUE]} ❯#{ANSI[:RESET]} ",
  :PROMPT_C => "#{ANSI[:RED]}?❯#{ANSI[:RESET]} ",
  :PROMPT_S => "#{ANSI[:YELLOW]}?❯#{ANSI[:RESET]} ",
  :RETURN   => "#{ANSI[:GREEN]}=>#{ANSI[:RESET]} %s\n",
  :AUTO_INDENT => true }
IRB.conf[:PROMPT_MODE] = :SIMPLE_COLOR

# IRB.conf[:PROMPT_MODE][:DEFAULT] = {
#       :PROMPT_I => "%N(%m):%03n:%i> ",
#       :PROMPT_S => "%N(%m):%03n:%i%l ",
#       :PROMPT_C => "%N(%m):%03n:%i* ",
#       :RETURN => "%s\n"
# }

# Loading extensions of the console. This is wrapped
# because some might not be included in your Gemfile
# and errors will be raised
def extend_console(name, care = true, required = true)
  if care
    require name if required
    yield if block_given?
    $console_extensions << "#{ANSI[:GREEN]}#{name}#{ANSI[:RESET]}"
  else
    $console_extensions << "#{ANSI[:GRAY]}#{name}#{ANSI[:RESET]}"
  end
rescue LoadError
  $console_extensions << "#{ANSI[:RED]}#{name}#{ANSI[:RESET]}"
end
$console_extensions = []

# Wirble is a gem that handles coloring the IRB
# output and history
extend_console 'wirble' do
  Wirble.init
  Wirble.colorize
end

# Hirb makes tables easy.
# extend_console 'hirb' do
#   Hirb.enable
#   extend Hirb::Console
# end

# When you're using Rails 2 console, show queries in the console
# extend_console 'rails2', (ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')), false do
#   require 'logger'
#   RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
# end

# When you're using Rails 3 console, show queries in the console
extend_console 'rails3', defined?(ActiveSupport::Notifications), false do
  $odd_or_even_queries = false
  ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
    $odd_or_even_queries = !$odd_or_even_queries
    color = $odd_or_even_queries ? ANSI[:CYAN] : ANSI[:MAGENTA]
    event = ActiveSupport::Notifications::Event.new(*args)
    time  = "%.1fms" % event.duration
    name  = event.payload[:name]
    sql   = event.payload[:sql].gsub("\n", " ").squeeze(" ")
    puts "  #{ANSI[:UNDERLINE]}#{color}#{name} (#{time})#{ANSI[:RESET]}  #{sql}"
  end
end

# Add a method pm that shows every method on an object
# Pass a regex to filter these
extend_console 'pm', true, false do
  def pm(obj, *options) # Print methods
    methods = obj.methods
    methods -= Object.methods unless options.include? :more
    filter  = options.select {|opt| opt.kind_of? Regexp}.first
    methods = methods.select {|name| name =~ filter} if filter

    data = methods.sort.collect do |name|
      method = obj.method(name)
      if method.arity == 0
        args = "()"
      elsif method.arity > 0
        n = method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")})"
      elsif method.arity < 0
        n = -method.arity
        args = "(#{(1..n).collect {|i| "arg#{i}"}.join(", ")}, ...)"
      end
      klass = $1 if method.inspect =~ /Method: (.*?)#/
      [name.to_s, args, klass]
    end
    max_name = data.collect {|item| item[0].size}.max
    max_args = data.collect {|item| item[1].size}.max
    data.each do |item|
      print " #{ANSI[:CYAN]}#{item[0].to_s.rjust(max_name)}#{ANSI[:RESET]}"
      print "#{ANSI[:BLUE]}#{item[1].ljust(max_args)}#{ANSI[:RESET]}"
      print "   #{ANSI[:LGRAY]}#{item[2]}#{ANSI[:RESET]}\n"
    end
    data.size
  end
end

extend_console 'interactive_editor' do
  # no configuration needed
end

# Show results of all extension-loading
# puts "#{ANSI[:GRAY]}~> Console extensions:#{ANSI[:RESET]} #{$console_extensions.join(' ')}#{ANSI[:RESET]}"cat

# Methods to easily display an object's available methods
def lm
  (self.methods - Object.methods).sort
end

def lim
  (self.instance_methods - Object.instance_methods).sort
end
