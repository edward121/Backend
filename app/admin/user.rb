ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :status

  index do
    selectable_column
    id_column
    column :email
    column :status
    column "Password", :password_as_asteric
    actions
  end

  filter :email
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :status, as: :select, collection: [[:pending, 'pending'], [:approved, 'approved'], [:denied, 'denied']]
      # f.input :password
      # f.input :password_confirmation
    end
    f.actions
  end

end
