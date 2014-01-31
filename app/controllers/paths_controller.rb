class PathsController < ApplicationController
#  require 'ostruct'
  require 'awesome_print'
#  before_filter :authenticate_user!, :except => [:login]
  before_filter :user_must_be_logged_in, :except => [:login]

  def login
    @suppress_nav_auth = true
  end

  def index
    session["init"] = true
#      binding.pry
#    @path_action = handle_post(vote_params)
    if !determine_mode
#      binding.pry
      logger.info 'could not determine valid mode'
      redirect_to paths_done_path
      return
    end

    if cur_mode == :starting
      session["num_decisions_made"] = 0
      set_mode(:punches)
    end

    case cur_mode
    when :starting, :punches
      if !determine_meme
#        binding.pry
        logger.info 'could not determine valid meme'
        redirect_to paths_done_path
        return
      end  
      @punches = cur_meme.n_best_punches_fresh_to_user(current_user, Meme.min_punches_per_meme_per_session)
#      binding.pry
      if @punches.blank?
 #       binding.pry
        logger.info "no punches for meme #{cur_meme}"
        redirect_to paths_done_path
        return
      else
        render template: "paths/punchlines"
      end
    when :choose_meme
      cur_meme # grab current meme from params, session; might be nil
      @alt_memes = Meme.n_best_memes_fresh_to_user(current_user, Meme.min_punches_per_meme_per_session, exclude: [cur_meme])
      if @alt_memes.empty?
        logger.info 'no alternative memes found'
        redirect_to paths_done_path
        return
      end  

      if !good_meme?
        set_meme(nil)
      end
#      #binding.pry
      render template: "paths/memes"
    end
  end

  def show_meme # choose meme to show
    set_meme(Meme.find(meme_params[:id]))
    set_mode(:punches)
    session["num_decisions_made"] += 1 if session["num_decisions_made"].present?
    redirect_to paths_path, notice: "Let's see some punchlines for that meme!"
  end

  def vote
    @decision = current_user.vote_decisions.create(vote_params)
    session["cur_meme_num_punches_seen_in_session"] += @decision.votes.count if @decision.votes.any?
    session["num_decisions_made"] += 1 if session["num_decisions_made"].present?
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
    set_mode(:starting)
    redirect_to paths_path, notice: notice
  end

  def hard_user_reset
    current_user.vote_decisions.destroy_all!
    set_mode(:starting)
    redirect_to paths_path, notice: "all your votes are destroyed! welcome to america!"
  end

  def done
#    binding.pry
  end

  private
  def handle_post(params)
    path_action = params.path_action
    path_action ||= :default
    case path_action
    when :vote
    when :default
    end
  end

    def cur_mode
      return @cur_mode if @cur_mode.present?
      return :starting if session["cur_mode"].blank?
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
      when :starting
#        binding.pry
        return (session["num_decisions_made"].blank? or session["num_decisions_made"] == 0)
      when :punches
        return good_meme?
      when :choose_meme
        return !good_meme?
      end
      return false
    end

    def modes
      [:starting, :punches, :choose_meme]
    end

    # randomly look for a good mode
    def determine_mode
#      binding.pry
      return cur_mode if good_mode?(cur_mode)
      modes.shuffle.each do |mode| 
        if good_mode?(mode)
          set_mode(mode)
          return cur_mode
        end
      end
#      binding.pry
      set_mode(nil)
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
      @cur_meme = meme
      session["cur_meme_id"] = meme.present? ? meme.id : nil
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
