module Shield::Utils
  def self.center(all, limit : Int32)
    l = (all - limit) / 2_i32
    r = all - l
    i = r - l + 1_i32 - limit
    r -= 1_i32 if i < 2_i32
    r -= 2_i32 if i >= 2_i32
    [Int32.new(l), Int32.new(r)]
  end

  def self.uuid : Array(Regex | String)
    [/(.{8})(.{4})(.{4})(.{4})(.{12})/,
     "\\1-\\2-\\3-\\4-\\5"]
  end

  def self.create_id(title : String) : String
    hash = Utils.digest title, "sha384"
    l, r = Utils.center hash.size, 32_i32
    hash[l..r].gsub(uuid.first,
      uuid.last.as String).upcase
  end

  def self.crc32(text : String) : String
    CRC32.checksum(text).to_s 16_i32
  end

  def self.digest(text, algorithm = "sha512WithRSAEncryption")
    OpenSSL::Digest.new(algorithm).update(text).to_s
  end

  def self.hmac(data, key, algorithm = OpenSSL::Algorithm::SHA512)
    OpenSSL::HMAC.hexdigest algorithm, key, data
  end

  def self.input : String
    STDIN.gets.to_s.chomp.rstrip
  end
end