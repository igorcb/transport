require "rails_helper"
require "fileutils"

RSpec.describe EdiNotfisMailer, type: :mailer do
  describe "when send mail delivery edi_notfis" do
    # "Arquivos Edi NotFis referente ao dia 06/12/2018"
    file_name = 'OCC.txt'
    file_path = Rails.root.join('public/system/file_edi', file_name)
    file = FileUtils.touch(file_path)

    let(:mail) { described_class.notification(file_name, file).deliver_now }

    it "renders the subject" do
      expect(mail.subject).to eql("Arquivos Edi NotFis referente ao dia 06/12/2018")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(['igor.batista@gmail.com'])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(['sistema@l7logistica.com.br'])
    end

    it "assigns @edi_notfis" do
      expect(mail.body.encoded).to match("Edi NotFis")
    end

    it "mail attachment" do
      expect(mail.attachments).to have(1).attachment
    end

  end
end
