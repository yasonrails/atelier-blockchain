class Block
    attr_reader :index, :timestamp, :data, :previous_data, :hash
    require 'digest'
    require 'pp'

    def initialize(index, data, previous_data)
     @index = index
     @timestamp = Time.now
     @data = data
     @previous_data = previous_data
     @hash = hash

    end

    def compute_hash
      sha = Digest::SHA256.new
      sha.update(@index.to_s + @timestamp.to_s + @data.to_s + @previous_data)
      sha.hexdigest
      p sha         
    end

    def self.first(data)
        Block.new(0, data, "0")
    end

    def self.next(previous, data)
        Block.new(previous.index+1, data, previous.hash)
    end
        
end

b0 = Block.first("BLK")
b1 = Block.next(b0, "BBBLLLLKKKK")
b2 = Block.next(b1, "BLK more data")
b3 = Block.next(b2, "more more more data")

pp [b0, b1, b2,b3]