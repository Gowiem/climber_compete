describe 'Competition' do

  before(:each) do
    @user1 = create(:user_with_1_climbs_today)
    @user2 = create(:user_with_2_climbs_today)
    @competition = FactoryGirl.create(:competition, users: [@user1, @user2])
  end

  context '#users_by_climb_count' do
    it 'should correctly sort the competition users by their climb count' do
      sorted_users = @competition.users_by_climb_count
      expect(sorted_users.count).to eq(2)
      expect(sorted_users.first).to eq(@user2)
      expect(sorted_users.last).to eq(@user1)
      expect(sorted_users.first.climbs.count).to eq(2)
      expect(sorted_users.last.climbs.count).to eq(1)
    end

    it 'should ignore climbs that are outside start/end' do
      @competition.update_attributes(start_date: 1.day.ago, end_date: 1.day.from_now)
      create(:climb, climb_date: 2.days.ago, user: @user1)
      create(:climb, climb_date: 3.days.ago, user: @user1)

      sorted_users = @competition.users_by_climb_count
      expect(sorted_users.count).to eq(2)
      expect(sorted_users.first).to eq(@user2)
      expect(sorted_users.last).to eq(@user1)

      create(:climb, climb_date: 1.hour.ago, user: @user1)
      create(:climb, climb_date: 1.hour.ago, user: @user1)
      sorted_users = @competition.users_by_climb_count
      expect(sorted_users.first).to eq(@user1)
      expect(sorted_users.last).to eq(@user2)
    end
  end

  context '#winner' do
    it 'should correctly get the user with the most climbs' do
      expect(@competition.winner).to eq(@user2)
    end

    it 'should return nil when climb count is the same' do
      create(:climb, climb_date: 1.hour.ago, user: @user1)
      expect(@competition.winner).to eq(nil)
    end
  end

  context '#tie?' do
    it 'should not be a tie if the climbs are different counts' do
      expect(@competition.tie?).to eq(false)
    end

    it 'should be a tie if the climbs are the same count' do
      create(:climb, climb_date: 1.hour.ago, user: @user1)
      expect(@competition.tie?).to eq(true)
    end
  end

  context '#over?' do
    it 'should be over when the end date is past' do
      @competition.update_attribute(:end_date, 1.minute.ago)
      expect(@competition.over?).to eq(true)
    end

    it 'should not be over if end date is in future' do
      @competition.update_attribute(:end_date, 1.minute.from_now)
      expect(@competition.over?).to eq(false)
    end
  end
end
