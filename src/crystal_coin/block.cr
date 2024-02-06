# src/crystal_coin/block.cr

require "openssl"
require "./proof_of_work"
require "./transaction"

module CrystalCoin
  class Block
    include ProofOfWork

    property current_hash : String
    property index : Int32
    property nonce : Int32
    property previous_hash : String

    def initialize(index = 0, transactions = [] of Transaction, previous_hash = "hash")
      @transactions = transactions
      @index = index
      @timestamp = Time.local
      @previous_hash = previous_hash
      @nonce = proof_of_work
      @current_hash = calc_hash_with_nonce(@nonce)
    end

    def self.first
      Block.new
    end

    def self.next(previous_node, transactions = [] of Transaction)
      Block.new(
        transactions: transactions,
        index: previous_node.index + 1,
        previous_hash: previous_node.current_hash
      )
    end

    private def hash_block
      hash = OpenSSL::Digest.new("SHA256")
      hash.update("#{@index}#{@timestamp}#{@transactions}#{@previous_hash}")
      hash.hexfinal
    end
  end
end

# blockchain = [ CrystalCoin::Block.first ]
# puts blockchain.inspect
# previous_block = blockchain[0]

# 5.times do |i|
#   new_block  = CrystalCoin::Block.next(previous_node: previous_block)
#   blockchain << new_block
#   previous_block = new_block
#   puts new_block.inspect
# end

# p blockchain