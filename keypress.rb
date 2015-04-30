require 'io/console'

# Reads keypresses from the user including 2 and 3 escape character sequences.
def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end

# oringal case statement from:
# http://www.alecjacobson.com/weblog/?p=75
def show_single_key
  c = read_char

  case c
  # when " "
  #   # logic here (e.g. move cursor, return stored value)
  #   puts "SPACE"
  when "\t"
    return :drop_off
  when "\r"
    return :pick_up
  # when "\n"
  #   puts "LINE FEED"
  when "\e"
    return "\e"
  when "\e[A"
    return [-1, 0]
  when "\e[B"
    return [1,0]
  when "\e[C"
    return [0, 1]
  when "\e[D"
    return [0, -1]
  # when "\177"
  #   puts "BACKSPACE"
  # when "\004"
  #   puts "DELETE"
  # when "\e[3~"
  #   puts "ALTERNATE DELETE"
  # when "\u0003"
  #   puts "CONTROL-C"
  #   exit 0
  # when /^.$/
  #   puts "SINGLE CHAR HIT: #{c.inspect}"
  # else
  #   puts "SOMETHING ELSE: #{c.inspect}"
  end
end

# show_single_key while(true)
