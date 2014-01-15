class PathsController < ApplicationController
#  require 'ostruct'
  require 'awesome_print'

  def index
#    @path_action = handle_post(path_params)
    set_meme
    @punches = cur_meme.punches_fresh_to_user(current_user, Meme.min_punches_per_meme_per_session)
    render template: "paths/punchlines"
  end


  def vote
    @decision = current_user.vote_decisions.create(path_params)
    redirect_to paths_path, notice: "Vote recorded: #{@decision.deep_inspect}"
  end

  def reset
    current_user.vote_decisions.destroy_all
    redirect_to paths_path, notice: "all your votes are destroyed! welcome to america!"
  end

  private
    def handle_post(params)
      path_action = params.path_action
      path_action = :default if path_action.blank? 
#      case path_action do
#        when :vote
#        when :default
 #     end
    end

    def set_mode(params)
      prev_action = params.path_action
      session[:prev_mode]
    end
    
    def exit_meme
      session["cur_meme_id"] = nil
      session["cur_meme_num_punches_seen"] = 0
    end      

    def cur_meme
      return @cur_meme if @cur_meme.present?
      return nil if session["cur_meme_id"].blank?
      @cur_meme = Meme.find_by_id(Integer(session["cur_meme_id"]))
    end

    def set_meme
      @cur_meme = choose_meme
    end

    def set_meme
      num_punches_seen = session["cur_meme_num_punches_seen"]
      if cur_meme.present?
        if num_punches_seen.blank?
          num_punches_seen = 0
          session["cur_meme_num_punches_seen"] = 0
        end
        self.exit_meme unless cur_meme.good_num_punches_left(num_punches_seen)
      end
      
      if cur_meme.blank?
        # no current one, so pick one
        sorted_memes = Meme.sorted_by_score
        @cur_meme = sorted_memes.present? ? sorted_memes.first : nil
        session["cur_meme_id"] = nil if @cur_meme.blank?
        session["cur_meme_id"] = @cur_meme.id
      end
    end
        

    # Never trust parameters from the scary internet, only allow the white list through.
    def path_params
      params.require(:vote_decision).permit( :user_id, {votes_attributes: [:punch_id, :value ]})
    end

end
