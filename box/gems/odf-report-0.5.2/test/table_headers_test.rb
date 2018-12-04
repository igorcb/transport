require './lib/odf-report'
require 'ostruct'
require 'faker'
require 'launchy'


  class Item
    attr_accessor :name, :mail
    def initialize(_name,  _mail)
      @name=_name
      @mail=_mail
    end
  end



    @items = []
    50.times { @items << Item.new(Faker::Name.name, Faker::Internet.email) }



    report = ODFReport::Report.new("test/templates/test_table_headers.odt") do |r|

      r.add_table("TABLE_01", @items, :header => true) do |s|
        s.add_column(:name)
        s.add_column(:mail)
      end

      r.add_table("TABLE_02", @items, :header => true) do |s|
        s.add_column(:name)
        s.add_column(:mail)
      end

      r.add_table("TABLE_03", @items) do |s|
        s.add_column(:name)
        s.add_column(:mail)
      end

    end

    report.generate("test/result/test_table_headers.odt")
