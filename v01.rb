# I Ching Yarrow Stalks Method
# Looking at other codes on github I noticed that they all aproached the yarrow stalk method very literally
# i.e. https://en.wikibooks.org/wiki/I_Ching/The_Ancient_Yarrow_Stalk_Method
# Imo it could be done much simpler by taking in account the probability of outcome
# and comparing a random float between 0 and 1 with these. 
# Like this the program doesn't need a single loop to yield a line and is so much easier to read.
# v.1 - 2018-07-18 - basic class blueprint
# v.2 - 2018-07-21 - added module HexData with data of trigrams, hexagrams and probability
#                  - cleaned up @movinglines hash
#                  - added routine to show next hexagram when lines are moving
#                  - todo: this routine has to move to class Hexagram insteas of main


# probability values of the yarrow stalks method
module HexData
  Probability = Hash.new
  Probability[:six]   = 0.0625 # 1/16 =  6.25% =   === x ===
  Probability[:nine]  = 0.1875 # 3/16 = 18.75% =   ====o====
  Probability[:seven] = 0.3125 # 5/16 = 31.25% =   ========= 
  Probability[:eight] = 0.4375 # 7/16 = 43.75% =   ===   ===

  # binary values of trigrams
  Trigram = Hash.new
  Trigram["000"] = "08    Earth"
  Trigram["001"] = "07    Mountain" 
  Trigram["010"] = "06    Water"
  Trigram["011"] = "05    Wind"
  Trigram["100"] = "04    Thunder" 
  Trigram["101"] = "03    Fire"
  Trigram["110"] = "02    Lake"
  Trigram["111"] = "01    Heaven"


  # binary values of hexagrams
  Hexagram = Hash.new
  Hexagram["000000"] = "02    The Receptive"
  Hexagram["000001"] = "23    Splitting Apart"
  Hexagram["000010"] = "08    Holding Together (Union)"
  Hexagram["000011"] = "20    Contemplation (View)"
  Hexagram["000100"] = "16    Enthusiasm"
  Hexagram["000101"] = "35    Progress"
  Hexagram["000110"] = "45    Gathering Together (Massing"
  Hexagram["000111"] = "12    Standstill (Stagnation)"
  Hexagram["001000"] = "15    Modesty"
  Hexagram["001001"] = "52    Keeping Still, Mountain"
  Hexagram["001010"] = "39    Obstruction "
  Hexagram["001011"] = "53    Development (Gradual Progress)"
  Hexagram["001100"] = "62    Preponderance of the Small"
  Hexagram["001101"] = "56    The Wanderer"
  Hexagram["001110"] = "31    Influence (Wooing)"
  Hexagram["001111"] = "33    Retreat"
  Hexagram["010000"] = "07    The Army"
  Hexagram["010001"] = "04    Youthfull Folly"
  Hexagram["010010"] = "29    The Abysmal (Water)"
  Hexagram["010011"] = "59    Dispersion (Dissolution)"
  Hexagram["010100"] = "40    Deliverance"
  Hexagram["010101"] = "64    Before Completion"
  Hexagram["010110"] = "47    Oppression (Exhaustion)"
  Hexagram["010111"] = "06    Conflict"
  Hexagram["011000"] = "46    Pushing Upward"
  Hexagram["011001"] = "18    Work on what has been spoiled (Decay)"
  Hexagram["011010"] = "48    The Well"
  Hexagram["011011"] = "57    The Gentle (The Penetrating, Wind)"  
  Hexagram["011100"] = "32    Duration"
  Hexagram["011101"] = "50    The Caldron"
  Hexagram["011110"] = "28    Preponderance of the Great"
  Hexagram["011111"] = "44    Coming to Meet"
  Hexagram["100000"] = "24    Return (The Turning Point)"
  Hexagram["100001"] = "27    Corners of the Mouth (Providing Nourishment)"
  Hexagram["100010"] = "03    Difficulty at the Beginning"
  Hexagram["100011"] = "42    Increase"
  Hexagram["100100"] = "51    The Arousing (Shock, Thunder)"
  Hexagram["100101"] = "21    Biting Through"
  Hexagram["100110"] = "17    Following"
  Hexagram["100111"] = "25    Innocence (The Unexpected)"
  Hexagram["101000"] = "36    Darkening of the Light"
  Hexagram["101001"] = "22    Grace"
  Hexagram["101010"] = "63    After Completion"
  Hexagram["101011"] = "37    The Family (The Clan)"
  Hexagram["101100"] = "55    Abundance (Fullness)"
  Hexagram["101101"] = "30    The Clinging, Fire"
  Hexagram["101110"] = "48    The Well"
  Hexagram["101111"] = "13    Fellowship with Men"
  Hexagram["110000"] = "19    Approach"
  Hexagram["110001"] = "41    Decrease"
  Hexagram["110010"] = "60    Limitation"
  Hexagram["110011"] = "61    Inner Truth"
  Hexagram["110100"] = "54    The Marrying Maiden"
  Hexagram["110101"] = "38    Opposition"
  Hexagram["110110"] = "58    The Joyous, Lake"
  Hexagram["110111"] = "10    Treading (Conduct)"
  Hexagram["111000"] = "11    Peace"
  Hexagram["111001"] = "26    The Taming Power of the Great"
  Hexagram["111010"] = "05    Waiting (Nourishment)"
  Hexagram["111011"] = "09    The Taming Power of the Small"
  Hexagram["111100"] = "34    The Power of the Great"
  Hexagram["111101"] = "14    Possession in Great Measure"
  Hexagram["111110"] = "43    Break Through (Resoluteness)"
  Hexagram["111111"] = "01    The Creative"
end

class Hexagram
  include HexData
    
  def initialize(lines=[castLine, castLine, castLine, castLine, castLine, castLine])
    # Cast a new line for each hexagram[key]
    @hexagram = Hash.new
    @hexagram[:"bottom line"] = lines[0]
    @hexagram[:"second line"] = lines[1]
    @hexagram[:"third line"]  = lines[2]
    @hexagram[:"fourth line"] = lines[3]
    @hexagram[:"fifth line"]  = lines[4]
    @hexagram[:"top line"]    = lines[5]
 
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
        puts "   === x ==="
      when 8
        puts "   ===   ==="
      when 9
        puts "   ====o===="
      when 7
        puts "   ========= "
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
     
  def printData
    puts
    print "Hexagram      = ", @nameHexagram, "\n"
    print "Upper Trigram = ", @upperTrigram, "\n"
    print "Lower Trigram = ", @lowerTrigram, "\n"
  end

  def returnHexagram
    return @hexagram
  end

end # of Class Hexagram


hex = Hexagram.new()
hex.drawHexagram
hex.printData

hexValues = hex.returnHexagram

while hex.movingLines?
puts "\n   evolves to\n\n"
  
  hexValues.each do |key, value|
  
    if value == 6 
      hexValues[key] = 7
      break
    end
    if value == 9
      hexValues[key] = 8
      break
    end
  end
  evolveHex = Hexagram.new(hexValues.values.to_a)
  evolveHex.drawHexagram
  evolveHex.printData
  if !evolveHex.movingLines?
    break
  end
end
