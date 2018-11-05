require 'rails_helper'

describe OrdemServices::UpdateDeliveryService do

  describe "when call execute" do
    before(:each) do
      @user = User.first
      @ordem_service = OrdemService.first
    end

    context "when exist boarding" do
      before(:each) do
        @update_delivery = update_delivery_service(@ordem_service, @user)
      end

      it {expect(@update_delivery[:success]).to be_truthy}

      it "should equal ENTREGA_EFETUADA" do
        expect(@ordem_service.reload.status).to equal(OrdemService::TipoStatus::ENTREGA_EFETUADA)
      end

      context "when all ordem_service"

        it "should false" do
          expect(@ordem_service.boarding.reload.status).to equal(Boarding::TipoStatus::EMBARCADO)
        end

        it "should true" do
          expect(@ordem_service.boarding.reload.status).to equal(Boarding::TipoStatus::ENTREGUE)
        end

      end
    end

    context "when not exist boarding" do
      before(:each) do
        @ordem_service = FactoryBot.create(:ordem_service)
        @update_delivery = update_delivery_service(@ordem_service, @user)
      end
      it {expect(@update_delivery[:success]).to be_falsey}
      #it " undefined " do
      it { expect(@update_delivery[:error]).to match("undefined method `boarding'") }
      #end
    end
    #raise_error("")
    #<NoMethodError: undefined method `boarding' for nil:NilClass>

    def update_delivery_service(ordem_service, user)
      OrdemServices::UpdateDeliveryService.new(ordem_service, user).call
    end

  end

end
