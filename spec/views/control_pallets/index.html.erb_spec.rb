require 'spec_helper'
require 'rails_helper'

#RSpec.describe "control_pallets/index", type: :view do
  # before(:each) do
  #   @control_pallet = mock_model(ControlPallet)
  #   @control_pallet.stub!(:new_record?).and_return(true)
  #   assigns[:control_pallet] = @control_pallet
  # end

  # before(:each) do
  #   assign(:control_pallets, [
  #     stub_model(ControlPallet,
  #       #:client => nil,
  #       :data => Date.current,
  #       :qte => 1,
  #       :tipo => 2,
  #       :historico => "Historico"
  #     ),
  #     stub_model(ControlPallet,
  #       :data => Date.current,
  #       :qte => 1,
  #       :tipo => 2,
  #       :historico => "Historico"
  #     )
  #   ])
  # end
  #
  # it "renders a list of control_pallets" do
  #   render
  #   # Run the generator again with the --webrat flag if you want to use webrat matchers
  #   # assert_select "tr>td", :text => nil.to_s, :count => 2
  #   assert_select "tr>td", :text => 1.to_s, :count => 2
  #   assert_select "tr>td", :text => 2.to_s, :count => 2
  #   assert_select "tr>td", :text => "Historico".to_s, :count => 2
  # end

  #it "displays all the control_pallets" do

    # assign(:control_pallets, [
    #   #stub_model(ControlPallet, :random_attribute => true)
    #   # stub_model(ControlPallet,
    #   #   data => Date.current,
    #   #   qtd => 1,
    #   #   type_product => 1,
    #   #   tipo => 1,
    #   #   status => 1,
    #   #   historico => "HISTORICO PARA TESTE"
    #   # )
    #
    #   #stub_model(ControlPallet, :data => Date.current, :qte => 1, :tipo => 2, :historico => "Historico 1"),
    #   #stub_model(ControlPallet, :data => Date.current, :qte => 1, :tipo => 2, :historico => "Historico 2")
    # ])

  #   render
  #
  #   rendered.should contain("slicer")
  #   rendered.should contain("dicer")
  #end
#end

# spec/views/posts/index.html.slim_spec.rb

RSpec.describe 'control_pallets/index', type: :view do
  User.create(name: Faker::Lorem.word, cpf: Faker::CPF.cpf, email: Faker::Internet.email, password: 'secret123', active: true)

  let(:user) { User.first }

  before :each do
    qtde_first =  rand (1..10)
		qtde_second = rand (1..10)
		ControlPallet.create(data: Date.current, qte: qtde_first, tipo: :credito, type_product: :pallet, status: :open, historico: "HISTORICO PARA TESTE I")
		ControlPallet.create(data: Date.current, qte: qtde_second, tipo: :credito, type_product: :pallet, status: :open, historico: "HISTORICO PARA TESTE II")

    @control_pallets = assign(:control_pallets, ControlPallet.limit(2))
    puts ">>>>>>>>>>>>>>> Count Pallet #{ ControlPallet.count }"
  end

  context 'when user is signed in' do
    before do
      # mock current_user
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'shows edit link' do
      render

      puts ">>>>>>>>>>>>>>> User #{ User.first.to_json }"
      expect(rendered).to have_css('#profile-name', text: "Acesse aqui!")

      assert_select 'table' do
        assert 'tr:nth-child(1)' do
          assert_select 'td:nth-child(1)', "#{@control_pallets.first.title}"
          assert_select "#edit-post-#{@control_pallets.first.id}", 'Edit'
        end

        assert 'tr:nth-child(2)' do
          assert_select 'td:nth-child(1)', "#{@control_pallets.second.title}"
          assert_select "#edit-post-#{@control_pallets.second.id}", 'Edit'
        end
      end
    end
  end

  # context 'when user is not signed in' do
  #   it 'does not show edit link' do
  #     render
  #
  #     expect(rendered).not_to have_css('#name', text: user.name)
  #
  #     assert_select 'table' do
  #       assert 'tr:nth-child(1)' do
  #         assert_select 'td:nth-child(1)', "#{@posts.first.title}"
  #         assert_select "#edit-post-#{@posts.first.id}", false
  #       end
  #
  #       assert 'tr:nth-child(2)' do
  #         assert_select 'td:nth-child(1)', "#{@posts.second.title}"
  #         assert_select "#edit-post-#{@posts.second.id}", false
  #       end
  #     end
  #   end
  # end
end
