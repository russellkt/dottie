class Dottie
  NUL = 0.chr  #nul
  ESC = 27.chr #escape
  LF  = 10.chr #line feed/new line
  CR  = 13.chr #carriage return
  TAB = 9.chr  #horizontal tab
  FF  = 12.chr #form feed
  Q   = 81.chr #used for setting right margin
  D   = 44.chr #used for setting horizontal tabs
  C   = 67.chr
  X   = 88.chr #used for setting margins
  VT  = 11.chr #vertical tab
  HYPHEN  = 45.chr

  attr_accessor :stream, :printer, :current_line, :current_page, :form_length

  def initialize options={}
   printer = options[:printer]
   host = options[:host]
   file = options[:file]
   @printer = file ? File.open(file,"w") : File.open("\\\\#{host}\\#{printer}", "w")
   @current_line = 0
   @current_page = 1
   form_length = options[:length] || 66
  end

  def print chars
    @printer.print chars
  end

  def end_of_page?
    @current_line >= (form_length - 5)
  end

  def close
    @printer.close
  end

  def clear_tabs
    print ESC
    print "R"
  end

  def set_margins left, right
    print ESC
    print X
    print left.chr
    print right.chr
    print CR
  end

  def set_line_spacing
    print ESC
    print "2"
  end

  def form_length= length
    @form_length = length
    print ESC
    print "C"
    print length.chr
  end

  def carriage_return
    print CR
  end

  def line_feed
    print LF
    @current_line += 1
  end

  def incremental_line_feed increment=1
    print ESC
    print 74.chr
    print increment.chr
  end

  def form_feed
    print FF
    @current_line = 0
    @current_page += 1
  end

  def horizontal_tab number=1
    number.times{|n| print(TAB) }
  end

  def vertical_tab number=1
    number.times{|n| print(VT); carriage_return; }
  end

  def set_tabs(tab_stops, is_horizontal=true)
    tab_char = is_horizontal ? "D" : "B"
    print ESC
    print tab_char
    tab_stops.each do |stop|
      print stop.chr
    end
    print(NUL)
  end
  
  def set_horizontal_tabs(tab_stops)
    set_tabs(tab_stops,true)
  end
  
  def set_vertical_tabs(tab_stops)
    set_tabs(tab_stops,false)
  end
  
  def start_underline
    print ESC
    print HYPHEN
    print 1.chr
  end
  
  def stop_underline
    print ESC
    print HYPHEN
    print 2.chr
  end
  
  def underline(characters)
    start_underline
    print characters
    stop_underline
  end
  
  def start_overscore
    print ESC
    print 95.chr
    print 1.chr
  end
  
  def stop_overscore
    print ESC
    print 95.chr
    print 2.chr
  end
  
  def overscore(characters)
    start_overscore
    print characters
    stop_overscore
  end
end
