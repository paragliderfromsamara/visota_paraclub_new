require 'test_helper'

class VoicesControllerTest < ActionController::TestCase
  setup do 
    @vote_value_1 = vote_values(:voiceTestVoteVoteValueOne)
    @vote_value_2 = vote_values(:voiceTestVoteVoteValueTwo)
    @vote_value_completed_vote_1 = vote_values(:voiceTestVoteCompletedVoteValueOne)
    @vote_value_completed_vote_2 = vote_values(:voiceTestVoteCompletedVoteValueTwo)
  end
  
  
  test "should post create" do
    comeAsClubPilot
    assert_difference("Voice.count", 1, "Не удалось проголосовать") do
      post :create, voice: {vote_id: @vote_value_1.vote_id, vote_value_id: @vote_value_1.id}
    end
    assert_response :success
  end
  
  test "shouldn't give voice twice" do
    comeAsClubPilot
    count = Voice.count
    assert_no_difference(count.to_s, "Удалось проголосовать дважды ") do
      post :create, voice: {vote_id: @vote_value_1.vote_id, vote_value_id: @vote_value_1.id}
    end
    assert_response :success
  end

  test "shouldn't give voice for completed vote" do
    comeAsClubPilot
    count = Voice.count
    assert_no_difference(count.to_s, "Удалось отдать голос в завершенном опросе") do
      post :create, voice: {vote_id: @vote_value_completed_vote_1.vote_id, vote_value_id: @vote_value_completed_vote_1.id}
    end
    assert_response :success
  end

end
