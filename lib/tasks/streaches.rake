namespace :db do
  desc "Fill database with the data from the site of streach"
  #  +   "http://www.febraban.org.br/arquivo/bancos/sitebancos2-0.asp"
  #task streaches: :environment do
  task :streaches, [:tenant] => [:environment] do |t, args|
    Apartment::Tenant.switch!(args.tenant)
    puts "Fill database with the data from the site of streach"
    Stretch.find_or_create_by(cidade: "ARACAJU", estado: "SE", destino: "AJU")
    Stretch.find_or_create_by(cidade: "BELEM", estado: "PA", destino: "BEL")
    Stretch.find_or_create_by(cidade: "BELO HORIZONTE", estado: "MG", destino: "BHZ")
    Stretch.find_or_create_by(cidade: "BELO HORIZONTE", estado: "MG", destino: "CNF")
    Stretch.find_or_create_by(cidade: "CAMPINAS", estado: "SP", destino: "VCP")
    Stretch.find_or_create_by(cidade: "CAMPO GRANDE", estado: "MS", destino: "CGR")
    Stretch.find_or_create_by(cidade: "CUIBA", estado: "MT", destino: "CGB")
    Stretch.find_or_create_by(cidade: "CURITIBA", estado: "PR", destino: "CWB")
    Stretch.find_or_create_by(cidade: "FLORIANOPOLIS", estado: "SC", destino: "FLN")
    Stretch.find_or_create_by(cidade: "FORTALEZA", estado: "CE", destino: "FOR")
    Stretch.find_or_create_by(cidade: "GOIANIA", estado: "GO", destino: "GYN")
    Stretch.find_or_create_by(cidade: "JOAO PESSOA", estado: "PB", destino: "JPA")
    Stretch.find_or_create_by(cidade: "JOINVILLE", estado: "SC", destino: "JOI")
    Stretch.find_or_create_by(cidade: "LONDRINA", estado: "PR", destino: "LDB")
    Stretch.find_or_create_by(cidade: "MACAPA", estado: "AP", destino: "MCP")
    Stretch.find_or_create_by(cidade: "MACEIO", estado: "AL", destino: "MCZ")
    Stretch.find_or_create_by(cidade: "MANAUS", estado: "AM", destino: "MAO")
    Stretch.find_or_create_by(cidade: "NATAL", estado: "RN", destino: "NAT")
    Stretch.find_or_create_by(cidade: "NAVEGANTES", estado: "SC", destino: "NVT")
    Stretch.find_or_create_by(cidade: "PALMAS", estado: "TO", destino: "PWM")
    Stretch.find_or_create_by(cidade: "PORTO ALEGRE", estado: "RS", destino: "POA")
    Stretch.find_or_create_by(cidade: "PORTO VELHO", estado: "RO", destino: "PVH")
    Stretch.find_or_create_by(cidade: "RECIFE", estado: "PE", destino: "REC")
    Stretch.find_or_create_by(cidade: "RIO BRANCO", estado: "AC", destino: "RBR")
    Stretch.find_or_create_by(cidade: "RIO DE JANEIRO", estado: "RJ", destino: "SDU")
    Stretch.find_or_create_by(cidade: "RIO DE JANEIRO", estado: "RJ", destino: "GIG")
    Stretch.find_or_create_by(cidade: "SAO PAULO", estado: "SP", destino: "GRU")
    Stretch.find_or_create_by(cidade: "SAO PAULO", estado: "SP", destino: "CGH")
    Stretch.find_or_create_by(cidade: "SALVADOR", estado: "BA", destino: "SSA")
    Stretch.find_or_create_by(cidade: "SAO LUIS", estado: "MA", destino: "SLZ")
    Stretch.find_or_create_by(cidade: "TERESINA", estado: "PI", destino: "THE")
    Stretch.find_or_create_by(cidade: "VITORIA", estado: "ES", destino: "VIX")
  end
end

