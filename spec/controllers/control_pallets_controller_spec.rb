require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ControlPalletsController do

  # This should return the minimal set of attributes required to create a valid
  # ControlPallet. As you add validations to ControlPallet, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ControlPalletsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all control_pallets as @control_pallets" do
      control_pallet = ControlPallet.create! valid_attributes
      get :index, {}, valid_session
      assigns(:control_pallets).should eq([control_pallet])
    end
  end

  describe "GET show" do
    it "assigns the requested control_pallet as @control_pallet" do
      control_pallet = ControlPallet.create! valid_attributes
      get :show, {:id => control_pallet.to_param}, valid_session
      assigns(:control_pallet).should eq(control_pallet)
    end
  end

  describe "GET new" do
    it "assigns a new control_pallet as @control_pallet" do
      get :new, {}, valid_session
      assigns(:control_pallet).should be_a_new(ControlPallet)
    end
  end

  describe "GET edit" do
    it "assigns the requested control_pallet as @control_pallet" do
      control_pallet = ControlPallet.create! valid_attributes
      get :edit, {:id => control_pallet.to_param}, valid_session
      assigns(:control_pallet).should eq(control_pallet)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ControlPallet" do
        expect {
          post :create, {:control_pallet => valid_attributes}, valid_session
        }.to change(ControlPallet, :count).by(1)
      end

      it "assigns a newly created control_pallet as @control_pallet" do
        post :create, {:control_pallet => valid_attributes}, valid_session
        assigns(:control_pallet).should be_a(ControlPallet)
        assigns(:control_pallet).should be_persisted
      end

      it "redirects to the created control_pallet" do
        post :create, {:control_pallet => valid_attributes}, valid_session
        response.should redirect_to(ControlPallet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved control_pallet as @control_pallet" do
        # Trigger the behavior that occurs when invalid params are submitted
        ControlPallet.any_instance.stub(:save).and_return(false)
        post :create, {:control_pallet => {}}, valid_session
        assigns(:control_pallet).should be_a_new(ControlPallet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ControlPallet.any_instance.stub(:save).and_return(false)
        post :create, {:control_pallet => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested control_pallet" do
        control_pallet = ControlPallet.create! valid_attributes
        # Assuming there are no other control_pallets in the database, this
        # specifies that the ControlPallet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ControlPallet.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => control_pallet.to_param, :control_pallet => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested control_pallet as @control_pallet" do
        control_pallet = ControlPallet.create! valid_attributes
        put :update, {:id => control_pallet.to_param, :control_pallet => valid_attributes}, valid_session
        assigns(:control_pallet).should eq(control_pallet)
      end

      it "redirects to the control_pallet" do
        control_pallet = ControlPallet.create! valid_attributes
        put :update, {:id => control_pallet.to_param, :control_pallet => valid_attributes}, valid_session
        response.should redirect_to(control_pallet)
      end
    end

    describe "with invalid params" do
      it "assigns the control_pallet as @control_pallet" do
        control_pallet = ControlPallet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ControlPallet.any_instance.stub(:save).and_return(false)
        put :update, {:id => control_pallet.to_param, :control_pallet => {}}, valid_session
        assigns(:control_pallet).should eq(control_pallet)
      end

      it "re-renders the 'edit' template" do
        control_pallet = ControlPallet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ControlPallet.any_instance.stub(:save).and_return(false)
        put :update, {:id => control_pallet.to_param, :control_pallet => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested control_pallet" do
      control_pallet = ControlPallet.create! valid_attributes
      expect {
        delete :destroy, {:id => control_pallet.to_param}, valid_session
      }.to change(ControlPallet, :count).by(-1)
    end

    it "redirects to the control_pallets list" do
      control_pallet = ControlPallet.create! valid_attributes
      delete :destroy, {:id => control_pallet.to_param}, valid_session
      response.should redirect_to(control_pallets_url)
    end
  end

end