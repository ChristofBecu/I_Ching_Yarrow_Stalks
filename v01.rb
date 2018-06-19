# I Ching Yarrow Stalks Method
# Looking at other codes on github I noticed that they all aproached the yarrow stalk method very literally
# i.e. https://en.wikibooks.org/wiki/I_Ching/The_Ancient_Yarrow_Stalk_Method
# Imo it could be done much simpler by taking in account the probability of outcome
# and comparing a random float between 0 and 1 with these. 
# Like this the program doesn't need a single loop to yield a line and is so much easier to read.

# probability values of the yarrow stalks method
$Probability = Hash.new
$Probability[:six]   = 0.0625 # 1/16 =  6.25% = old yin
$Probability[:nine]  = 0.1875 # 3/16 = 18.75% = old yang
$Probability[:seven] = 0.3125 # 5/16 = 31.25% = young yang
$Probability[:eight] = 0.4375 # 7/16 = 43.75% = young yin

# binary values of trigrams
$Trigram = Hash.new
$Trigram["000"] = "K'oen - Earth"
$Trigram["001"] = "Ken - Mountain" 
$Trigram["010"] = "K'an - Water"
$Trigram["011"] = "Soen - Wind"
$Trigram["100"] = "Tsjen - Thunder" 
$Trigram["101"] = "Li - Fire"
$Trigram["110"] = "Twèi - Lake"
$Trigram["111"] = "Tj'ièn - Heaven"

class Hexagram

  def initialize
    # Cast a new line for each hexagram[key]
    @hexagram = Hash.new
    @hexagram[:"bottom line"] = castLine
    @hexagram[:"second line"] = castLine
    @hexagram[:"third line"]  = castLine
    @hexagram[:"fourth line"] = castLine
    @hexagram[:"fifth line"]  = castLine
    @hexagram[:"top line"]    = castLine
    
    # Determine if hexagram[key] is a moving line
    @movinglines = Hash.new
    @movinglines[:"bottom line"]  = @hexagram[:"bottom line"] == :"old yin"  ? true : @hexagram[:"bottom line"] == :"old yang"  ? true : false
    @movinglines[:"second line"]  = @hexagram[:"second line"] == :"old yin"  ? true : @hexagram[:"second line"] == :"old yang"  ? true : false
    @movinglines[:"third line"]   = @hexagram[:"third line"]  == :"old yin"  ? true : @hexagram[:"third line"]  == :"old yang"  ? true : false
    @movinglines[:"fourth line"]  = @hexagram[:"fourth line"] == :"old yin"  ? true : @hexagram[:"fourth line"] == :"old yang"  ? true : false
    @movinglines[:"fifth line"]   = @hexagram[:"fifth line"]  == :"old yin"  ? true : @hexagram[:"fifth line"]  == :"old yang"  ? true : false
    @movinglines[:"top line"]     = @hexagram[:"top line"]    == :"old yin"  ? true : @hexagram[:"top line"]    == :"old yang"  ? true : false
    
    # Solid line (Yang) = 1; broken line (Yin) = 0
    @binary = Hash.new
    @binary[:"bottom line"]  = @hexagram[:"bottom line"] == :"old yin" ? 0 :  @hexagram[:"bottom line"] == :"young yin" ? 0 : 1
    @binary[:"second line"]  = @hexagram[:"second line"] == :"old yin" ? 0 :  @hexagram[:"second line"] == :"young yin" ? 0 : 1
    @binary[:"third line"]   = @hexagram[:"third line"]  == :"old yin" ? 0 :  @hexagram[:"third line"]  == :"young yin" ? 0 : 1
    @binary[:"fourth line"]  = @hexagram[:"fourth line"] == :"old yin" ? 0 :  @hexagram[:"fourth line"] == :"young yin" ? 0 : 1
    @binary[:"fifth line"]   = @hexagram[:"fifth line"]  == :"old yin" ? 0 :  @hexagram[:"fifth line"]  == :"young yin" ? 0 : 1
    @binary[:"top line"]     = @hexagram[:"top line"]    == :"old yin" ? 0 :  @hexagram[:"top line"]    == :"young yin" ? 0 : 1
    
    @lowerTrigram = $Trigram[@binary.values.to_s.tr("[ ,]", "")[0..2]]
    @upperTrigram = $Trigram[@binary.values.to_s.tr("[ ,]", "")[3..5]]
  end
  
  def castLine
    # The core of the program:
    # cast a random number between 0 and 1
    # and compare this number with the probability
    # of the yarrow stalks to generate a line accordingly
    cast = rand 
    case 
    when cast < $Probability[:six]
      :"old yin"
    when cast < $Probability[:six] + $Probability[:nine]
      :"old yang"
    when cast < $Probability[:six] + $Probability[:nine] + $Probability[:seven]
      :"young yang"
    when cast < $Probability[:six] + $Probability[:nine] + $Probability[:seven] + $Probability[:eight]
      :"young yin"
    end
  end
  
  def drawHexagram
    #convert hash to array, reverse, and back to hash
    Hash[@hexagram.to_a.reverse].each do |key, value|
      case value
      when :"old yin"
        puts "=== x ===   |   ===   ===   >   ========="
      when :"young yin"
        puts "===   ===   |   ===   ===   >   ===   ==="
      when :"old yang"
        puts "====o====   |   =========   >   ===   ==="
      when :"young yang"
        puts "=========   |   =========   >   ========="
      end
    end
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
end

end # of Class Hexagram

hex = Hexagram.new
hex.drawHexagram
hex.printTrigrams
hex.printMovingLines

h = Hexagram.new
h.drawHexagram
h.printTrigrams
h.printMovingLines

# end
