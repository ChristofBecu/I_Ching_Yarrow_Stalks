# I Ching Yarrow Stalks Method
# Looking at other codes on github I noticed that they all aproached the yarrow stalk method very literally
# i.e. https://en.wikibooks.org/wiki/I_Ching/The_Ancient_Yarrow_Stalk_Method
# Imo it could be done much simpler by taking in account the probability of outcome
# and comparing a random float between 0 and 1 with these. 
# Like this the program doesn't need a single loop to yield a line and is so much easier to read.

# probability values of the yarrow stalks method
module Probability
  Probability = Hash.new
  Probability[:six]   = 0.0625 # 1/16 =  6.25% = old yin  === x ===
  Probability[:nine]  = 0.1875 # 3/16 = 18.75% = old yang ====o====
  Probability[:seven] = 0.3125 # 5/16 = 31.25% = young yang ========= 
  Probability[:eight] = 0.4375 # 7/16 = 43.75% = young yin ===   ===
end

module InfoTrigram
  # binary values of trigrams
  Trigram = Hash.new
  Trigram["000"] = "K'oen - Earth"
  Trigram["001"] = "Ken - Mountain" 
  Trigram["010"] = "K'an - Water"
  Trigram["011"] = "Soen - Wind"
  Trigram["100"] = "Tsjen - Thunder" 
  Trigram["101"] = "Li - Fire"
  Trigram["110"] = "Twèi - Lake"
  Trigram["111"] = "Tj'ièn - Heaven"
end

module InfoHexagram
  Hexagram = Hash.new
  Hexagram["000000"] = "2"
  Hexagram["000001"] = "23"
  Hexagram["000010"] = "8"
  Hexagram["000011"] = "20"
  Hexagram["000100"] = "16"
  Hexagram["000101"] = "35"
  Hexagram["000110"] = "45"
  Hexagram["000111"] = "12"
  Hexagram["001000"] = "15"
  Hexagram["001001"] = "52"
  Hexagram["001010"] = "39"
  Hexagram["001011"] = ""
  Hexagram["001100"] = ""
  Hexagram["001101"] = ""
  Hexagram["001110"] = ""
  Hexagram["001111"] = ""
  Hexagram["010000"] = ""
  Hexagram["010001"] = ""
  Hexagram["010010"] = ""
  Hexagram["010011"] = ""
  Hexagram["010100"] = ""
  Hexagram["010101"] = ""
  Hexagram["010110"] = ""
  Hexagram["010111"] = ""
  Hexagram["011000"] = ""
  Hexagram["011001"] = ""
  Hexagram["011010"] = ""
  Hexagram["011011"] = ""  
  Hexagram["011100"] = ""
  Hexagram["011101"] = ""
  Hexagram["011110"] = ""
  Hexagram["011111"] = ""
  Hexagram["100000"] = ""
  Hexagram["100001"] = ""
  Hexagram["100010"] = ""
  Hexagram["100011"] = ""
  Hexagram["100100"] = ""
  Hexagram["100101"] = ""
  Hexagram["100110"] = ""
  Hexagram["100111"] = ""
  Hexagram["101000"] = ""
  Hexagram["101001"] = ""
  Hexagram["101010"] = ""
  Hexagram["101011"] = ""
  Hexagram["101100"] = ""
  Hexagram["101101"] = ""
  Hexagram["101110"] = ""
  Hexagram["101111"] = ""
  Hexagram["110000"] = ""
  Hexagram["110001"] = ""
  Hexagram["110010"] = ""
  Hexagram["110011"] = ""
  Hexagram["110100"] = ""
  Hexagram["110101"] = ""
  Hexagram["110110"] = ""
  Hexagram["110111"] = ""
  Hexagram["111000"] = ""
  Hexagram["111001"] = ""
  Hexagram["111010"] = ""
  Hexagram["111011"] = ""
  Hexagram["111100"] = ""
  Hexagram["111101"] = ""
  Hexagram["111110"] = ""
  Hexagram["111111"] = ""
end

class Hexagram
  include Probability
  include InfoTrigram
  include InfoHexagram
  
  def initialize(lines=[castLine, castLine, castLine, castLine, castLine, castLine])
    # Cast a new line for each hexagram[key]
    @hexagram = Hash.new
    @hexagram[:"top line"]    = lines[0]
    @hexagram[:"fifth line"]  = lines[1] 
    @hexagram[:"fourth line"] = lines[2]
    @hexagram[:"third line"]  = lines[3]
    @hexagram[:"second line"] = lines[4]
    @hexagram[:"bottom line"] = lines[5]
    Hash[@hexagram.to_a.reverse]

   
    
    # Determine if hexagram[key] is a moving line
    @movinglines = Hash.new
    @movinglines[:"bottom line"]  = @hexagram[:"bottom line"] == 6  ? true : @hexagram[:"bottom line"] == 9  ? true : false
    @movinglines[:"second line"]  = @hexagram[:"second line"] == 6  ? true : @hexagram[:"second line"] == 9  ? true : false
    @movinglines[:"third line"]   = @hexagram[:"third line"]  == 6  ? true : @hexagram[:"third line"]  == 9  ? true : false
    @movinglines[:"fourth line"]  = @hexagram[:"fourth line"] == 6  ? true : @hexagram[:"fourth line"] == 9  ? true : false
    @movinglines[:"fifth line"]   = @hexagram[:"fifth line"]  == 6  ? true : @hexagram[:"fifth line"]  == 9  ? true : false
    @movinglines[:"top line"]     = @hexagram[:"top line"]    == 6  ? true : @hexagram[:"top line"]    == 9  ? true : false
    
    # Solid line (Yang) = 1; broken line (Yin) = 0
    @binary = Hash.new
    @binary[:"bottom line"]  = @hexagram[:"bottom line"] == 6 ? 0 :  @hexagram[:"bottom line"] == 8 ? 0 : 1
    @binary[:"second line"]  = @hexagram[:"second line"] == 6 ? 0 :  @hexagram[:"second line"] == 8 ? 0 : 1
    @binary[:"third line"]   = @hexagram[:"third line"]  == 6 ? 0 :  @hexagram[:"third line"]  == 8 ? 0 : 1
    @binary[:"fourth line"]  = @hexagram[:"fourth line"] == 6 ? 0 :  @hexagram[:"fourth line"] == 8 ? 0 : 1
    @binary[:"fifth line"]   = @hexagram[:"fifth line"]  == 6 ? 0 :  @hexagram[:"fifth line"]  == 8 ? 0 : 1
    @binary[:"top line"]     = @hexagram[:"top line"]    == 6 ? 0 :  @hexagram[:"top line"]    == 8 ? 0 : 1
    
    @lowerTrigram = Trigram[@binary.values.to_s.tr("[ ,]", "")[0..2]]
    @upperTrigram = Trigram[@binary.values.to_s.tr("[ ,]", "")[3..5]]
    
    @nameHexagram = Hexagram[@binary.values.to_s.tr("[ ,]", "")]
    
  end
  
  def castLine
    # The core of the program:
    # cast a random number between 0 and 1
    # and compare this number with the probability
    # of the yarrow stalks to generate a line accordingly
    cast = rand 
    case 
    when cast < Probability[:six]
      6
    when cast < Probability[:six] + Probability[:nine]
      9
    when cast < Probability[:six] + Probability[:nine] + Probability[:seven]
      7
    when cast < Probability[:six] + Probability[:nine] + Probability[:seven] + Probability[:eight]
      8
    end
  end
  
  def drawHexagram
    #convert hash to array, reverse, and back to hash
    Hash[@hexagram.to_a.reverse].each do |key, value|
      case value
      when 6
        puts "=== x ==="
      when 8
        puts "===   ==="
      when 9
        puts "====o===="
      when 7
        puts "========= "
      end
    end
  end
  
  def movingLines?
    @movinglines.values.include?(true) 
  end

  def printMovingLines
    if @movinglines.values.include?(true) 
      print "\nmoving lines:\n"
      @movinglines.each do |key, value|
        if value
          puts key
        end
      end
    end
  end
     
def printTrigrams
  puts
  print "Upper Trigram = ", @upperTrigram, "\n"
  print "Lower Trigram = ", @lowerTrigram, "\n"
  print "Hexagram = ", @nameHexagram, "\n"
end

def returnHexagram
  return @hexagram
end

end # of Class Hexagram

hex = Hexagram.new
hex.drawHexagram
hex.printTrigrams


h = hex.returnHexagram

puts "\n   evolves to:\n\n"

while hex.movingLines?
  h.each do |key, value|
  
    if value == 6 
      h[key] = 7
      break
    end
    if value == 9
      h[key] = 8
      break
    end
  end
  e = Hexagram.new(h.values.to_a)

  e.drawHexagram
  e.printTrigrams
  if !e.movingLines?
    break
  end
  puts "\n   evolves to:\n\n" 

end


