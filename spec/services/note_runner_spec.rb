require 'spec_helper'
require './spec/fixtures.rb'

describe NoteRunner do

  before(:all) do

    @key = Bitcoin::Key.from_base58("cPL4Lx1R19kdeW3DVkFDwbVMTc7A3HgeoLAjS3RAo9ZzKqtSVC6N")
    @address = @key.addr

    @addresses_array = [@address]
    @note = Note.create(
      content: "I love you baby for ever",
      address: @address,
      encrypted_private_key: AES.encrypt(@key.priv, ENV["DECRYPTION_KEY"])
      )

    10.times do
      key = Bitcoin.generate_key

      Note.create(
        content: SecureRandom.hex(30),
        address: Bitcoin.pubkey_to_address(key[1]),
        encrypted_private_key: AES.encrypt(key[0], ENV["DECRYPTION_KEY"])
        )
    end

    @notes = Note.pluck(:address)
    @transaction = FIXTURES::TRANSACTION

    end

    it "should check presence" do
      expect(NoteRunner::Task.address_present?(["random"], @notes)).to equal(false)
      expect(NoteRunner::Task.address_present?(@addresses_array, @notes)).to equal(true)
    end

    it "should create payment" do
      expect(NoteRunner::Task.create_payment(@transaction, @address)).to equal(true)

      payment = NotePayment.where(tx_hash: @transaction["tx_hash"])
      expect(payment.satoshis).to equal(@transaction["out"][0]["value"])
    end

    it "should create transaction" do

    end

    it "should create token" do

    end

    it "should create email" do

    end

  end