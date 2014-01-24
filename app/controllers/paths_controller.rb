class PathsController < ApplicationController
#  require 'ostruct'
  require 'awesome_print'
#  before_filter :authenticate_user!, :except => [:login]
  before_filter :user_must_be_logged_in, :except => [:login]

  def login
  end

  def index
#      binding.pry
#    @path_action = handle_post(vote_params)
    if !determine_mode
#      binding.pry
      redirect_to paths_done_path
      return
    end

    case cur_mode
    when :start, :punches
      if !determine_meme
#        binding.pry
        redirect_to paths_done_path
        return
      end  
      @punches = cur_meme.n_best_punches_fresh_to_user(current_user, Meme.min_punches_per_meme_per_session)
#      binding.pry
      if @punches.blank?
 #       binding.pry
        redirect_to paths_done_path
        return
      else
        render template: "paths/punchlines"
      end
    when :choose_meme
      @alt_memes = Meme.memes_fresh_to_user(current_user).take(Meme.min_punches_per_meme_per_session)
      cur_meme # might be nil
      #binding.pry
      render template: "paths/memes"
    end
  end

  def show_meme # choose meme to show
    set_meme(Meme.find(meme_params[:id]))
    set_mode(:punches)
    redirect_to paths_path, notice: "Let's see some punchlines for that meme!"
  end

  def vote
    @decision = current_user.vote_decisions.create(vote_params)
    session["cur_meme_num_punches_seen_in_session"] += @decision.votes.count if @decision.votes.any?
    redirect_to paths_path, notice: "Got your vote!"
  end

  def soft_user_reset
    scope = reset_params[:scope].to_sym
    case scope
    when :all
      memes_to_reset = Meme.all
      notice = "ok, you can vote on all memes from scratch now"
    when :single
      memes_to_reset = [Meme.find(meme_params[:id])]
      notice = "ok, you can vote on that meme from scratch now"
    end
    memes_to_reset.each do |meme|
      meme.vote_decisions.where(user_id: current_user.id).each do |decision|
          decision.votes.each {|vote| vote.mark_repeatable}
      end
    end
    set_mode(:start)
    redirect_to paths_path, notice: notice
  end

  def hard_user_reset
    current_user.vote_decisions.destroy_all!
    set_mode(:start)
    redirect_to paths_path, notice: "all your votes are destroyed! welcome to america!"
  end

  def done
#    binding.pry
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

    def cur_mode
      return @cur_mode if @cur_mode.present?
      return :start if session["cur_mode"].blank?
      @cur_mode = session["cur_mode"].to_sym
    end

    def set_mode(new_mode)
      old_mode = cur_mode
      if new_mode != :punches or old_mode != :punches
        session["cur_meme_num_punches_seen_in_session"] = 0
      end
      session["cur_mode"] = new_mode.to_s
      @cur_mode = new_mode
    end

    def good_mode?(mode)
      return false if mode.blank?
      case mode
      when :start
        return true
      when :punches
        return good_meme?
      when :choose_meme
        return !good_meme?
      end
      return false
    end

    def modes
      [:start, :punches, :choose_meme]
    end

    def determine_mode
      return cur_mode if good_mode?(cur_mode)
      modes.each do |mode| 
        if good_mode?(mode)
          set_mode(mode)
          break
        end
        # no good cur mode, so pick one
      end
      cur_mode
    end
    
    def cur_meme
#      binding.pry
      return @cur_meme if @cur_meme.present?
      return nil if session["cur_meme_id"].blank?
      @cur_meme = Meme.find_by_id(Integer(session["cur_meme_id"]))
    end

    def good_meme?
      session["cur_meme_num_punches_seen_in_session"] = 0 if session["cur_meme_num_punches_seen_in_session"].blank?
      cur_meme.present? \
            and cur_meme.good_num_session_punches_left?(current_user, session["cur_meme_num_punches_seen_in_session"])
    end

    def set_meme(meme)
        session["cur_meme_id"] = meme.id
        session["cur_meme_num_punches_seen_in_session"] = 0
    end

    def determine_meme
      return true if good_meme? # only change meme if current one isn't going right
      sorted_memes = Meme.sorted_by_score_for_user(current_user)
      sorted_memes.each do |sorted_meme| 
        break if good_meme?
        # no good cur meme, so pick one
        @cur_meme = sorted_meme
        session["cur_meme_id"] = @cur_meme.blank? ? nil : @cur_meme.id
        session["cur_meme_num_punches_seen_in_session"] = 0
      end
      good_meme? 
    end
        

    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:vote_decision).permit( :user_id, :meme_id, {votes_attributes: [:punch_id, :value ]})
    end
    def reset_params
      params.permit(:scope)
    end
    def meme_params
#      binding.pry
      params.require(:meme).permit(:id)
 #     binding.pry
    end

end
