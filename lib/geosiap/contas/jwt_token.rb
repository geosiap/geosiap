class Geosiap::Contas::JWTToken

  def encode(user)
    JWT.encode(payload(user), rsa, 'RS256')
  end

  def decode(token)
    JWT.decode(token, rsa_pub, true, {algorithm: 'RS256'}).first.with_indifferent_access
  end

private

  PATH = "#{ENV['HOME']}/.contas_rsa"

  def rsa
    @rsa ||= begin
      value = ENV['CONTAS_RSA'] || File.read("#{PATH}/#{Rails.env}")
      OpenSSL::PKey::RSA.new(value)
    end
  end

  def rsa_pub
    @rsa_pub ||= begin
      value = ENV['CONTAS_RSA_PUB'] || File.read("#{PATH}/#{Rails.env}.pub")
      OpenSSL::PKey::RSA.new(value)
    end
  end

  def payload(user)
    {id: user.id, email: user.email, username: user.username, nome: user.nome, foto_url: user.contas_foto_url}
  end

end
