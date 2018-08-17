module SettingEdiOco
  extend ActiveSupport::Concern
  included do

    def ajeita_numero(numero, casas)
      numero.to_s.gsub(/\./, "").gsub(/-/, "").gsub(/\//, "").rjust(casas, "0")
    end

    def ajeita_texto(texto, casas)
      (texto || "").to_s[0,casas].ljust(casas)
    end

    def ajeita_data(data)
      data.day.to_s.rjust(2,"0") + data.month.to_s.rjust(2,"0") + data.year.to_s
    end

    def ajeita_hora(datetime)
      datetime.hour.to_s.rjust(2,"0") + datetime.minute.to_s.rjust(2,"0") + datetime.second.to_s.rjust(2,"0")
    end

    def ajeita_dinheiro(valor, casas)
      reais, centavos = valor.to_s.split(".")
      reais = reais.rjust (casas - 2), "0"
      centavos = centavos.present? ? centavos.ljust(2, "0") : "00"
      [reais, centavos].join
    end

    def remove_mask_cpf_cnpj(texto)
      texto.to_s.gsub('.','').gsub('/','').gsub('-','')
    end

    def ajeita_caracteres(texto)
      texto.mb_chars.upcase.to_s
      .gsub(/Ç/,"C")
      .gsub(/Á/,"A")
      .gsub(/À/,"A")
      .gsub(/Ã/,"A")
      .gsub(/É/,"E")
      .gsub(/Ê/,"E")
      .gsub(/Í/,"I")
      .gsub(/Ó/,"O")
      .gsub(/Ô/,"O")
      .gsub(/Õ/,"O")
      .gsub(/Ú/,"U")
      .gsub(/Ü/,"U")
    end

    def generate_header(trasnportadora, remetente)
      # TPREGISTRO 	Numérico	TAM 3 DEFAULT 000
      header = "000"
      # IDREMETENTE 	CARACTERE	TAM 35 
      header << ajeita_texto(trasnportadora.razao_social[0..35], 35)
      # IDREMETENTE 	CARACTERE	TAM 35 
      header << ajeita_texto(remetente.nome[0..35], 35)
      # DATA 	DATA	TAM 06 
      header << ajeita_data(DateTime.now.in_time_zone("Brasilia").to_date)
      # DATA 	HORA	TAM 04
      header << DateTime.current.strftime("%d%m")
      # IDINTERCAMBIO Caracter TAM 12
      header << ajeita_texto(" ", 12)
      # Preencher com espaços
      header << " " * 29
      ajeita_caracteres(header)
    end   

    def generate_body()
    	# TPREGISTRO Numérico TAM 3 DEFAULT 340
    	body = '340'
      # tipo do arquivo Caracter TAM 5
      body << 'OCORR'
      # DATA  DATA  TAM 04 
      body << DateTime.current.strftime("%M%H")
    	# IDDOCUMENTO Caracter TAM 14
    	body << "07580"
      
    end 

    def generate_body_nfe(trasnportadora)
    	# TPREGISTRO Numérico TAM 3 DEFAULT 341
    	body_nfe = '341'
    	# CGC Caracter TAM 14 
    	body_nfe << remove_mask_cpf_cnpj(trasnportadora.cnpj)
    	# RAZAOSOCIAL Caracter TAM 40
    	body_nfe << ajeita_texto(trasnportadora.razao_social[0..40], 40)
    end 

    def generate_nfe(nfe) 
      # LISTAGEM DAS NFE
			# 3 TPREGISTRO Numérico 3 TAM DEFAULT 342
      arq_nfe = '342'
      # 6 CGC Numérico TAM 14 
      arq_nfe << remove_mask_cpf_cnpj(nfe.ordem_service.billing_client.cpf_cnpj)
      # 9 CDSERIE Caracter TAM 3 
      arq_nfe << ajeita_texto(nfe.chave[24..26],3)
      # 12 CDNOTA Numérico TAM 8 
      arq_nfe << ajeita_texto(nfe.nfe, 8)
      # 15 CDOCORRE Numérico TAM 2 
      arq_nfe << ("0" * 2)
      # 18 DATA Numérico TAM 8 DDMMYYYY
      # DATA  DATA  TAM 06 
      arq_nfe << ajeita_data(DateTime.now.in_time_zone("Brasilia").to_date)
      # 21 HORA Numérico TAM 4 
      arq_nfe << DateTime.current.strftime("%H%M")
      # 24 CDENTREGA Numérico TAM 2 
      arq_nfe << ("0" * 2)
      # 27 TEXTO Caracter TAM 70 
      arq_nfe << (" " * 70)
    end

  end
end