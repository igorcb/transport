require 'rails_helper'

describe OrdemServices::UpdateDeliveryService do

  describe "#call" do
    before(:each) do
      @user = User.first
      @boarding = OrdemService.first.boarding
      @ordem_service = OrdemService.first
      @ordem_service_other = OrdemService.last
    end

    context "when exist boarding" do
      before(:each) do
        @update_delivery = update_delivery_service(@ordem_service, @user)
      end

      it "should equal ENTREGA_EFETUADA" do
        expect(@ordem_service.reload.status).to equal(OrdemService::TipoStatus::ENTREGA_EFETUADA)
      end

      context "when not sendmail notification delivery" do
        it "when not exist billing_client" do
          expect(@ordem_service.billing_client).to be_nil
        end

        it "when not exist email" do
          @ordem_service.update(billing_client: Client.last) #-aqui
          expect(@ordem_service.reload.billing_client.emails.blank?).to be_truthy
          expect { update_delivery_service(@ordem_service, @user) }.not_to change { ActionMailer::Base.deliveries.count }
        end

        #Novos testes de email por conta dos dados que aparecem na view mailer
        it "when not exist vehicle" do
          expect(@ordem_service.boarding.boarding_vehicles.blank?).to be_truthy
          expect { update_delivery_service(@ordem_service, @user) }.not_to change { ActionMailer::Base.deliveries.count }
        end
      end

      context "when sendmail notification delivery" do
        before(:each) do
          #byebug
          @count_before_sendmail = ActionMailer::Base.deliveries.count
          @ordem_service = OrdemService.first
          @ordem_service.update(billing_client: Client.last)
          #@ordem_service.billing_client.emails.create(email) #, sector_id: Sector::TypeSector::CONFIRMACAO_ENTREGA))
          @ordem_service.billing_client.reload.emails.create(
            setor: Faker::Commerce.department(1),
            sector_id: Sector::TypeSector::CONFIRMACAO_ENTREGA,
            contato: Faker::Name.name,
            email: Faker::Internet.email,
            responsavel_carga: false,
            comprovante: false
          )
        end

        it { expect { OrdemServiceMailer.notification_delivery(@ordem_service).deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1) }
        #expect { subject.send_instructions }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it {expect(@update_delivery[:success]).to be_truthy}

      context "when all ordem services status ENTREGA_EFETUADA" do
        it "check_status_ordem_service_entregue? false" do
          @ordem_service.update(status: OrdemService::TipoStatus::ABERTO)#-aqui
          expect(@ordem_service_other.boarding.check_status_ordem_service_entregue?).to be_falsey
        end
        it "check_status_ordem_service_entregue? true" do

        end
      end

      # context "when all ordem services status not ENTREGA_EFETUADA" do
      #   before(:each) do
      #     @ordem_service_other.update(billing_client: Client.last)
      #     @ordem_service.billing_client.reload.emails.create(
      #       setor: Faker::Commerce.department(1),
      #       sector_id: Sector::TypeSector::CONFIRMACAO_ENTREGA,
      #       contato: Faker::Name.name,
      #       email: Faker::Internet.email,
      #       responsavel_carga: false,
      #       comprovante: false
      #     ) #-aqui
      #     @update_delivery_other = update_delivery_service(@ordem_service_other.reload, @user)
      #   end
      #
      #   it {expect(@update_delivery_other[:success]).to be_truthy}
      #   it "should status OrdemService ENTREGA_EFETUADA" do
      #     expect(@ordem_service_other.reload.status).to eq(OrdemService::TipoStatus::ENTREGA_EFETUADA)
      #   end
      #   it "should check_status_ordem_service_entregue? equal true" do
      #     expect(@ordem_service_other.reload.boarding.check_status_ordem_service_entregue?).to be_truthy
      #   end
      #   it "should status Boarding ENTREGUE" do
      #     expect(@ordem_service_other.reload.boarding.status).to equal(Boarding::TipoStatus::ENTREGUE)
      #   end
      #
      # end
    end

    context "when not exist boarding" do
      before(:each) do
        @ordem_service = FactoryBot.create(:ordem_service)
        @update_delivery = update_delivery_service(@ordem_service, @user)
      end
      it {expect(@update_delivery[:success]).to be_falsey}

      it { expect(@update_delivery[:error]).to match("undefined method `boarding'") }
    end
    #raise_error("")
    #<NoMethodError: undefined method `boarding' for nil:NilClass>

    def update_delivery_service(ordem_service, user)
      OrdemServices::UpdateDeliveryService.new(ordem_service, user).call
    end

  end

end
