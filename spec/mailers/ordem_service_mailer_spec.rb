require "rails_helper"

RSpec.describe OrdemServiceMailer, type: :mailer do
  describe "notification_delivery" do

    before do
      # @campaign = create(:campaign)
      # @member   = create(:member, campaign: @campaign)
      # @friend = create(:member, campaign: @campaign)
      # @mail = CampaignMailer.raffle(@campaign, @member, @friend)
      @ordem_service = OrdemService.first
      @email = 'igor.batista@gmail.com'
      @mail = OrdemServiceMailer.notification_delivery(@ordem_service)
    end

    it "renders the headers" do
      expect(@mail.subject).to eq("NOTIFICAÇÃO DE ENTREGA - NF: #{@ordem_service.danfes}")
    end

    # it "body have member name" do
    #   expect(@mail.body.encoded).to match(@member.name)
    # end
    #
    # it "body have campaign creator name" do
    #   expect(@mail.body.encoded).to match(@campaign.user.name)
    # end
    #
    # it "body have member link to set open" do
    #   expect(@mail.body.encoded).to match("/members/#{@member.token}/opened")
    # end
  end

end
