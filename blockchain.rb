require 'digest'
require 'pp'

LEDGER =[]

class Block
    attr_reader :index, :nonce, :timestamp, :transaction, :transaction_count, :previous_transaction, :hash

    def initialize(index, transaction, previous_hash)
     @index = index
     @timestamp = Time.now
     @transaction = transaction
     @transaction_count = transaction.size
     @previous_hash = previous_hash
     @hash, @nonce = compute_hash_with_proof_of_work

    end
    
    def compute_hash_with_proof_of_work(difficulty="00")
      nonce = 0 
      loop do
        hash = compute_hash_with_nonce(nonce)
        if hash.start_with?(difficulty)
            return [hash, nonce]
        else
            nonce += 1
            print "#{nonce} - "
            
        end
      end 
    end

    def compute_hash_with_nonce(nonce=0)
      sha = Digest::SHA256.new
      sha.update( @index.to_s + 
                  nonce.to_s +
                  @timestamp.to_s + 
                  @transaction.to_s +
                  @transaction_count.to_s + 
                  @previous_hash
                )
      sha.hexdigest         
    end
    def self.first(data)
        Block.new(0, data, "0")
    end

    def self.next(previous, data=gets)
        Block.new(previous.index+1, data, previous.hash)
    end
        
end # class Block
#private 
def create_first_block
  i = 0
  instance_variable_set("@b#{i}", Block.first({ from: "vendeur", to: "acheteur", what:"BTC", qty: "100_000" }))   
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
    i += 1
  end
end

create_first_block