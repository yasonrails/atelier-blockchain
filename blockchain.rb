require 'digest'
require 'pp'

LEDGER =[]

class Block
    attr_reader :index, :timestamp, :data, :previous_data, :hash

    def initialize(index, data, previous_hash)
     @index = index
     @timestamp = Time.now
     @data = data
     @previous_hash = previous_hash
     @hash = compute_hash

    end

    def compute_hash
      sha = Digest::SHA256.new
      sha.update( @index.to_s + 
                  @timestamp.to_s + 
                  @data + 
                  @previous_hash )
      sha.hexdigest         
    end

    def self.first(data)
        Block.new(0, data, "0")
    end

    def self.next(previous, data=gets)
        Block.new(previous.index+1, data, previous.hash)
    end
        
end # class Block

def create_first_block
  i = 0
  instance_variable_set("@b#{i}", Block.first("BLK"))   
  LEDGER << @b0
  pp @b0
  add_block
end
def add_block
  i = 1
  loop do
    instance_variable_set("@b#{i}", Block.next(instance_variable_get("@b#{i-1}")))  
    LEDGER << instance_variable_get("@b#{i}")
    p "======================================"
    pp instance_variable_get("@b#{i}")
    p "======================================"

  end
end

create_first_block