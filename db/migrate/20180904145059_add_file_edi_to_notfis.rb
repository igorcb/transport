class AddFileEdiToNotfis < ActiveRecord::Migration[5.0]
  def change
    add_reference :notfis, :file_edi, index: true
  end
end
