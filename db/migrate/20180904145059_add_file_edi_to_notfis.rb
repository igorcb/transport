class AddFileEdiToNotfis < ActiveRecord::Migration
  def change
    add_reference :notfis, :file_edi, index: true
  end
end
