require './lib/odf-report'
require 'ostruct'
require 'faker'
require 'launchy'


  class Item
    attr_accessor :name, :sid, :children
    def initialize(_name, _sid, _children=[])
      @name=_name
      @sid=_sid
      @children=_children
    end
  end


    @items = []
    @items << Item.new("LOST",           '007', %w(sawyer juliet hurley locke jack freckles))
    @items << Item.new("ALIAS",          '302', %w(sidney sloane jack michael marshal))
    @items << Item.new("GREY'S ANATOMY", '220', %w(meredith christina izzie alex george))
    @items << Item.new("BREAKING BAD",   '556', %w(pollos gus mike heisenberg))


    report = ODFReport::Report.new("test/templates/test_sections.odt") do |r|

      r.add_field("TAG_01", Time.now)
      r.add_field("TAG_02", "TAG-2 -> New tag")

      r.add_section("SECTION_01", @items) do |s|

        s.add_field('NAME') { |i| i.name }

        s.add_field('SID', :sid)

        s.add_table('TABLE_S1', :children, :header=>true) do |t|
          t.add_column('NAME1') { |item| "-> #{item}" }
          t.add_column('INV')   { |item| item.to_s.reverse.upcase }
        end

      end

    end

    report.generate("test/result/test_sections.odt")
