module Geosiap
  module Geosiap::Helpers

    def self.public_models
      ['Geosiap::Contas::Usuario', 'Geosiap::Acessos::Cliente', 'Geosiap::Acessos::Licenca', 'Geosiap::Acessos::Modulo', 'Geosiap::Acessos::UsuarioPerfil', 'Geosiap::Acessos::Perfil']
    end

    def self.schemas(sigla)
      Geosiap::Acessos::Cliente.por_modulo(sigla).order(:id).pluck(:nome_reduzido)
    end

  end
end
