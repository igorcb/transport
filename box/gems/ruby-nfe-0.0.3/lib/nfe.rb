lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "nfe/version"
require 'nfe/entidades/entidade_nfe.rb'
require 'nfe/entidades/infNFe/nota_fiscal.rb'
require 'nfe/entidades/infNFe/ide/identificacao_nfe.rb'
require 'nfe/entidades/infNFe/emit/emitente.rb'
require 'nfe/entidades/infNFe/emit/endereco_emitente.rb'
require 'nfe/entidades/infNFe/dest/destinatario.rb'
require 'nfe/entidades/infNFe/dest/endereco_destinatario.rb'
require 'nfe/entidades/infNFe/det/produto.rb'
require 'nfe/entidades/infNFe/det/imposto.rb'
require 'nfe/entidades/infNFe/total/icmstot.rb'
require 'nfe/entidades/infNFe/transp/transportadora.rb'
require 'nfe/entidades/infNFe/transp/veiculo.rb'
require 'nfe/entidades/infNFe/transp/volume.rb'
require 'nfe/entidades/infNFe/infAdic/info.rb'
require 'nfe/entidades/protNFe/infProt.rb'



