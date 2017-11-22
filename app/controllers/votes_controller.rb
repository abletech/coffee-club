class VotesController < WelcomeController
  skip_before_action :verify_authenticity_token
  
  def create
    @vote = Vote.new
    @vote.voted_at = DateTime.now
    @vote.user_text = vote_params[:text].downcase
    @vote.rating = calculate_rating(@vote.user_text)

    response = if @vote.save
      "Successfully #{@vote.rating == 1 ? "upvoted" : "downvoted"} the batch"
    else
      "Error processing vote - the valid keywords are good (+1) and bad (-1)"
    end
    render json: response

    SendSlackNotification.new(vote_params[:response_url], response).perform
  end

  private

  def vote_params
    params.permit(:user_name, :text, :response_url)
  end

  def calculate_rating(user_text)
    (user_text == "good" || user_text == "+1") ? 1 : -1
  end
end
