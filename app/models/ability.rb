class Ability
  include CanCan::Ability

  # def self.levels
  #   [Admin, Oper, Visit, Client, Agent]
  # end

  # def prepare
  #   puts "Classe Preparadora de alguma coisa"
  #   self.class.levels.each do |level|
  #     puts ">>>>>>>>>>>> #{level.is_a}"

  #     if level.is_a? Admin
  #       puts "Classe admin"
  #       level.create_access_admin
  #     end
        
  #     # elsif level.is_a? :oper
  #     #   level.create_access_oper
  #     # elsif level.is_a? :visit
  #     #   level.create_access_visit
  #     # elsif level.is_a? :agent
  #     #   level.create_access_agent
  #     # end
  #   end
  # end

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    if user.has_role? :admin
      can :manage, :all
    elsif  user.has_role? :oper
      #can :manage, OrdemService
    elsif  user.has_role? :visit
      can :manage, Pallet
    elsif  user.has_role? :client
      #can :manage, Pallet
    elsif  user.has_role? :agent
      can :manage, OrdemService, :carrier_id => user.carrier_id
      #if user.has_role?(:agent, OrdemSerice.where(carrier_id: ?, user.carrier_id))
      #can :manage, OrdemService
      # can :write, Forum if user.has_role?(:moderator, Forum)
      # can :write, Forum, :id => Forum.with_role(:moderator, user).pluck(:id)
    end
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

  class Admin
    def create_access_admin
      puts "Criando acesso para create_access_admin"
    end
  end

  class Oper
    def create_access_oper
      puts "Criando acesso para create_access_oper"
    end
  end

  class Client
    def create_access_client
      puts "Criando acesso para create_access_client"
    end
  end

  class Visit
    def create_access_visit
      puts "Criando acesso para create_access_visit"
    end
  end

  class Agent
    def create_access_agent
      puts "Criando acesso para create_access_agent"
    end
  end

end
