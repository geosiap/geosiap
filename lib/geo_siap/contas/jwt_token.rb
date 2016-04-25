class GeoSiap::Contas::JWTToken

  def encode(user)
    JWT.encode(payload(user), rsa, 'RS256')
  end

  def decode(token)
    JWT.decode(token, rsa_pub, true, {algorithm: 'RS256'}).first.with_indifferent_access
  end

private

  PATH = "#{ENV['HOME']}/.contas_rsa"

  def rsa
    rsa_file = File.read("#{PATH}/#{Rails.env}")
    @rsa ||= OpenSSL::PKey::RSA.new(rsa_file)
  end

  def rsa_pub
    rsa_pub_file = File.read("#{PATH}/#{Rails.env}.pub")
    @rsa_pub ||= OpenSSL::PKey::RSA.new(rsa_pub_file)
  end

  def payload(user)
    {id: user.id, email: user.email, username: user.username, nome: user.nome, foto_url: user.contas_foto_url}
  end

end
