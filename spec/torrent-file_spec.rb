require "rspec"
require "torrent-file"

describe "encode" do
  describe "int encode" do
    it " should equals the encode string" do
      expect(12.bencode).to eq("i12e")
    end
  end

  describe "string encode" do
    it "should equals the encode string" do
      expect("what".bencode).to eq("4:what")
    end
  end

  describe "hash encode" do
    it "should equals the encode string" do
      expect({"author"=>"wangdong","city"=>"beijing"}.bencode).to eq("d6:author8:wangdong4:city7:beijinge")
    end
  end

  describe "array encode" do
    it "should equals the encode array" do
      expect([1,2,3].bencode).to eq("li1ei2ei3ee")
    end
  end

  describe "bencode string decode" do
    it " should equals the obj" do
      expect("d4:name9:mashengxi3:agei12e5:filmsli1ei2ei3eee".bdecode).to eq({"name"=>"mashengxi","age"=>12,"films"=>[1,2,3]})
    end
  end
end
