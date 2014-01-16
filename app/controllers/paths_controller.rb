class PathsController < ApplicationController
#  require 'ostruct'
  require 'awesome_print'
  before_filter :user_must_be_logged_in, :except => [:login]

  def login
  end

  def index
#    @path_action = handle_post(path_params)
    set_meme or redirect_to paths_done_path
    @punches = cur_meme.punches_fresh_to_user(current_user, Meme.min_punches_per_meme_per_session)
    render template: "paths/punchlines"
  end


  def vote
    @decision = current_user.vote_decisions.create(path_params)
    session["cur_meme_num_punches_seen_in_session"] += @decision.votes.count if @decision.votes.any?
    redirect_to paths_path, notice: "Got your vote!"
  end

  def reset
    current_user.vote_decisions.destroy_all
    redirect_to paths_path, notice: "all your votes are destroyed! welcome to america!"
  end

  def done
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
    
    def cur_meme
      return @cur_meme if @cur_meme.present?
      return nil if session["cur_meme_id"].blank?
      @cur_meme = Meme.find_by_id(Integer(session["cur_meme_id"]))
    end

    def good_meme
      session["cur_meme_num_punches_seen_in_session"] = 0 if session["cur_meme_num_punches_seen_in_session"].blank?
      cur_meme.present? \
            and cur_meme.good_num_punches_left(current_user, session["cur_meme_num_punches_seen_in_session"])
    end

    def set_meme
      sorted_memes = Meme.sorted_by_score_for_user(current_user)
      sorted_memes.each do |sorted_meme| 
        break if good_meme
        # no good cur meme, so pick one
        @cur_meme = sorted_meme
        session["cur_meme_id"] = @cur_meme.blank? ? nil : @cur_meme.id
        session["cur_meme_num_punches_seen_in_session"] = 0
      end
      good_meme 
    end
        

    # Never trust parameters from the scary internet, only allow the white list through.
    def path_params
      params.require(:vote_decision).permit( :user_id, {votes_attributes: [:punch_id, :value ]})
    end

end
