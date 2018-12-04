# encoding: UTF-8
require 'nokogiri'
require 'roxml'
require 'json'

module NFe
	class NFeProc
    include ROXML
    xml_name :NFeProc
	  xml_accessor :xmlns, :from => "http://www.portalfiscal.inf.br/nfe" # attribute with name 'ISBN'
	  #xmlns="http://www.portalfiscal.inf.br/nfe"
  	# xml_accessor :title
  	# xml_accessor :description, :cdata => true  # text node with cdata protection
  	# xml_accessor :author
	end

	class EntidadeNFe
		include ROXML
		@@validations = []

		class << self
			alias :nfe_attr :xml_accessor

			def xml_accessor(*attrs)
				attr_accessor *attrs
				# super(*attrs)
			end

			def nfe_attrs
				roxml_attrs.map(&attr_name)	
			end
		end

		def nfe_attributes
			self.class.nfe_attrs
		end

		def to_nfe_xml(file)
			#entidade = EntidadeNFe.from_xml(File.read(File.expand_path('example-user.xml', File.dirname(__FILE__))))
			#entidade = NFe::EntidadeNFe.from_xml(File.read(File.expand_path(file, File.dirname(__FILE__))))
			entidade = Nokogiri::XML(File.open(file))
			doc = Nokogiri::XML::Document.new
			doc.root = self.to_xml
			# open("entidade_nfe.xml", 'w') do |file|
			#   file << doc.serialize
			# end		
			puts ">>>>>> #{doc.root.to_s}"
	  end

		def to_nfe
			#depois fazer o teste com REXML
			doc = Nokogiri::XML::Document.new
			doc.root = to_xml
			doc.serialize
		end

		# def to_s
		# 	self.respond_to? :to_nfe ? to_nfe : super
		# end

    def serialize(params)
      params.each do |key, value|
        send("#{key}=", value) if respond_to?(key)
      end    
    end

		def xml_to_hash(xml)
			hash = {}
			xml.children.each do |i| 
				hash.store(i.name, i.text)
			end
			hash
		end

  	def to_xml(xml)
			hash = ''
			xml.children.each do |i| 
				hash << "<#{i.name}>#{i.text}</#{i.name}>" 
			end
			hash
		end

 	end
end
