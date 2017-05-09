module Geosiap
  module Geosiap::Helpers

    def self.public_models
      ['Geosiap::Contas::Usuario', 'Geosiap::Painel::Cliente', 'Geosiap::Painel::Licenca', 'Geosiap::Painel::Modulo', 'Geosiap::Painel::UsuarioPerfil']
    end

    def self.schemas(sigla)
      Geosiap::Painel::Cliente.por_modulo(sigla).order(:id).pluck(:nome_reduzido)
    end

  end
end
