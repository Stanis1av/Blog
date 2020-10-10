class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
       t.text :name_autor
       t.text :content

       t.timestamps
     end
    create_table :comments do |t|
      t.belongs_to :post
      t.text :comment_content

      t.timestamps
    end
  end
end
