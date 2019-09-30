class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    # elsif  user.has_role? :client
      #can :manage, Pallet

    if user.has_role? :admin
      can :manage, :all
    elsif  user.has_role? :oper
      can :manage, Boarding
      can :manage, InputControl
      can :manage, Task
    elsif  user.has_role? :port
      can :manage, Boarding
      can :manage, Checkin
    elsif  user.has_role? :sup
      can :manage, Boarding
      can :manage, InputControl
      can :manage, DriverRestriction
      can :manage, VehicleRestriction
      can :manage, Task
      can [:edit_qtde_pallet, :update_qtde_pallet], NfeXml
    elsif  user.has_role? :visit
      can :manage, Pallet
    elsif  user.has_role? :agent
      can :manage, OrdemService, :carrier_id => user.carrier_id
    elsif user.has_role? :boarding
      #can :manage, Client
      can :manage, [Boarding, OrdemService, Driver, Task, InternalComment, Link]
      can [:read, :search], [Client, InputControl, NfeXml, NfeKey, Vehicle]
      can [:create, :read, :type_account_select, :sub_centro_custo_by_custo, :sub_centro_custo_three_by_custo], AccountPayable
    elsif user.has_role? :input
      can :manage, [InputControl, NfeXml, NfeKey, OrdemService, Driver, Product, Link]
      can :create, [AccountReceivable]
      can [:read, :search, :get_driver_by_id, :get_driver_by_cpf], Driver
      can [:read, :search, :get_carrier_by_id, :get_carrier_by_cnpj], Carrier
      can [:read, :search, :get_client_by_cnpj], Client
      #can [:read, :search],
      #, Vehicle, Carrier]
    end
    #if user.has_role?(:agent, OrdemSerice.where(carrier_id: ?, user.carrier_id))
    #can :manage, OrdemService
    # can :write, Forum if user.has_role?(:moderator, Forum)
    # can :write, Forum, :id => Forum.with_role(:moderator, user).pluck(:id)

    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  # class Admin
  #   def create_access_admin
  #     puts "Criando acesso para create_access_admin"
  #   end
  # end
  #
  # class Oper
  #   def create_access_oper
  #     puts "Criando acesso para create_access_oper"
  #   end
  # end
  #
  # class Client
  #   def create_access_client
  #     puts "Criando acesso para create_access_client"
  #   end
  # end
  #
  # class Visit
  #   def create_access_visit
  #     puts "Criando acesso para create_access_visit"
  #   end
  # end
  #
  # class Agent
  #   def create_access_agent
  #     puts "Criando acesso para create_access_agent"
  #   end
  # end
  #
  # class Port
  #   def create_access_port
  #     puts "Criando acesso para create_access_port"
  #   end
  # end
  #
  # class Sup
  #   def create_access_sup
  #     puts "Criando acesso para create_access_sup"
  #   end
  # end

end
